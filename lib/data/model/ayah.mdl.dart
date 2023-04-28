import 'package:quran/data/model/tafsir.mdl.dart';

class AyahMdl {
  final int id;
  final int surahId;
  final int ayah;
  final int page;
  final int juz;
  final int manzil;
  final String arabic;
  final String? kitabah;
  final String latin;
  final String translation;
  final String? footnotes;
  final dynamic rawTafsir;

  const AyahMdl({
    required this.id, required this.surahId, required this.ayah,
    required this.page, required this.juz, required this.manzil,
    required this.arabic, required this.kitabah, required this.latin,
    required this.translation, this.footnotes, this.rawTafsir
  });

  factory AyahMdl.fromJson(Map<String, dynamic> json) => AyahMdl(
    id: json['id'],
    surahId: json['surah_id'],
    ayah: json['ayah'],
    page: json['page'],
    juz: json['juz'],
    manzil: json['manzil'],
    arabic: json['arabic'],
    kitabah: json['kitabah'],
    latin: json['latin'],
    translation: json['translation'],
    footnotes: json['footnotes'],
    rawTafsir: json['tafsir']
  );

  Map<String, dynamic> toJson([bool? isRealId]) => {
    'id': isRealId != null && isRealId == true ? id : null,
    'surah_id': surahId,
    'ayah': ayah,
    'page': page,
    'juz': juz,
    'manzil': manzil,
    'arabic': arabic.trim(),
    'kitabah': kitabah,
    'latin': latin.trim(),
    'translation': translation.trim(),
    'footnotes': footnotes
  };
}