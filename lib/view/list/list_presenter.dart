import 'package:quran/data/model/surah.mdl.dart';
import 'package:quran/data/repo/surah.repo.dart';
import 'package:quran/view/list/list_method.dart';

class ListPresenter {
  late ListMethod _method;

  void initialize(ListMethod method) {
    _method = method;
  }

  void getDataOfSurah() async {
    _method.actionLoading(true);
    List<SurahMdl> surah = await SurahRepo.getSurah();
    _method.dataOfSurah(surah);
    _method.actionLoading(false);
  }
}