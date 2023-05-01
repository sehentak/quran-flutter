import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:quran/data/model/tafsir.mdl.dart';
import 'package:quran/data/repo/surah.repo.dart';
import 'package:quran/view/read/read_method.dart';

class ReadPresenter {
  static const _limitPerPage = 10;
  late ReadMethod _method;

  void initialize(ReadMethod method) {
    _method = method;
  }

  void getAyah(PagingController controller, int pageKey, int surahId, int surahCount) async {
    _method.actionLoading(true);
    try {
      final newItems = await SurahRepo.getAyah(surahId, surahCount, pageKey, _limitPerPage);
      final isLastPage = newItems.length < _limitPerPage;
      if (isLastPage) {
        controller.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
        controller.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      controller.error = error;
    }
    _method.actionLoading(false);
  }

  void getTafsir(int ayahId, int ayahNumber) async {
    TafsirMdl? tafsir = await SurahRepo.getTafsir(ayahId);
    if (tafsir == null) {
      _method.showAlertError();
    } else {
      _method.showAlertDialog(tafsir, ayahNumber);
    }
  }
}