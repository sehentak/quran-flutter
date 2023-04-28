import 'dart:convert';
import 'dart:developer';
import 'package:quran/data/database/ayah.db.dart';
import 'package:quran/data/database/surah.db.dart';
import 'package:quran/data/database/tafsir.db.dart';
import 'package:quran/data/model/ayah.mdl.dart';
import 'package:quran/data/model/data.mdl.dart';
import 'package:quran/data/model/surah.mdl.dart';
import 'package:quran/data/model/tafsir.mdl.dart';
import 'package:quran/internal/gen/default.dart';
import 'package:http/http.dart' as http;

class SurahRepo {
  static Future<List<SurahMdl>> getSurah() async {
    List<SurahMdl> listSurah = await SurahDb.getSurah();
    if (listSurah.isNotEmpty) {
      return listSurah;
    }

    String url = 'quran-surah';
    List<dynamic> list = await _getPayloadData(url);

    for (var json in list) {
      SurahMdl surah = SurahMdl.fromJson(json);
      try {
        int id = await SurahDb.insertSurah(surah);
        if (id > 0) {
          listSurah.add(SurahMdl(
              id: id,
              arabic: surah.arabic,
              latin: surah.latin,
              transliteration: surah.transliteration,
              translation: surah.translation,
              ayahCount: surah.ayahCount,
              page: surah.page,
              location: surah.location
          ));
        }
      } catch (e) {
        log('${surah.id}: ${e.toString()}');
      }
    }

    return listSurah;
  }

  static Future<List<AyahMdl>> getAyah(int surahId, int surahCount, int startAyah, int limitPerLoad) async {
    int limitAyah = limitPerLoad;
    if (surahCount - startAyah < limitPerLoad) {
      limitAyah = surahCount - startAyah;
    }

    List<AyahMdl> listAyah = await AyahDb.getAyah(surahId, startAyah, limitAyah);
    if (listAyah.isNotEmpty && listAyah.length == limitAyah) {
      return listAyah;
    }

    String url = 'quran-ayah?surah=$surahId&start=$startAyah&limit=$limitAyah';
    log('url: getAyah: $url');
    List<dynamic> list = await _getPayloadData(url);

    listAyah = [];
    for (var json in list) {
      AyahMdl ayah = AyahMdl.fromJson(json);
      try {
        AyahMdl? model = await AyahDb.getAyahByNumber(surahId, ayah.ayah);
        if (model == null) {
          int id = await AyahDb.insertAyah(ayah);
          model = AyahMdl(
              id: id,
              surahId: ayah.surahId,
              ayah: ayah.ayah,
              page: ayah.page,
              juz: ayah.juz,
              manzil: ayah.manzil,
              arabic: ayah.arabic,
              kitabah: ayah.kitabah,
              latin: ayah.latin,
              translation: ayah.translation,
              footnotes: ayah.footnotes
          );
        }

        listAyah.add(model);
      } catch (e) {
        log('${ayah.id}: ${e.toString()}');
      }
    }

    if (listAyah.isEmpty) {
      return [];
    }

    return listAyah;
  }

  static Future<TafsirMdl?> getTafsir(int ayahId) async {
    TafsirMdl? tafsir = await TafsirDb.getTafsir(ayahId);
    if (tafsir != null) {
      return tafsir;
    }

    var uri = Uri.parse('${Default.urlHost}/quran-tafsir/$ayahId');
    http.Response response = await http.get(uri);
    if (response.statusCode != 200) {
      return null;
    }

    dynamic jsonMap = jsonDecode(response.body);
    DataMdl<dynamic> jsonModel = DataMdl.fromJson(jsonMap);
    AyahMdl ayah = AyahMdl.fromJson(jsonModel.data);
    if (ayah.rawTafsir == null) {
      return null;
    }

    tafsir = TafsirMdl.fromJson(ayah.rawTafsir);
    int tafsirId = await TafsirDb.insertTafsir(ayahId, tafsir);
    if (tafsirId <= 0) {
      return null;
    }

    return tafsir;
  }

  static Future<List<dynamic>> _getPayloadData(String url) async {
    var uri = Uri.parse('${Default.urlHost}/$url');
    http.Response response = await http.get(uri);
    if (response.statusCode != 200) {
      return [];
    }

    dynamic jsonMap = jsonDecode(response.body);
    DataMdl<List<dynamic>> jsonModel = DataMdl.fromJson(jsonMap);
    return jsonModel.data;
  }
}