import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:quran/data/model/ayah.mdl.dart';
import 'package:quran/data/model/surah.mdl.dart';
import 'package:quran/data/model/tafsir.mdl.dart';
import 'package:quran/internal/resource/colors.rsc.dart';
import 'package:quran/internal/resource/strings.rsc.dart';
import 'package:quran/view/read/read_method.dart';
import 'package:quran/view/read/read_presenter.dart';

class ReadPage extends StatelessWidget {
  const ReadPage({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;
    SurahMdl surah = arguments['123'];

    String _surahName = surah.latin.trim();
    int number = surah.id;
    String detail = '${surah.ayahCount} ${QuranString.labelAyah} • ${surah.translation.trim()}';

    return Scaffold(
        backgroundColor: QuranColor.foreground,
        appBar: _appBar(context, number, _surahName, detail),
        body: PageState(surah: surah)
    );
  }

  AppBar _appBar(BuildContext context, int number, String title, String detail) => AppBar(
      backgroundColor: QuranColor.primaryDark,
      automaticallyImplyLeading: false,
      centerTitle: false,
      flexibleSpace: SafeArea(
          child: Container(
              padding: const EdgeInsets.only(
                  right: 16
              ),
              child: Row(
                  children: <Widget>[
                    _surahBackAction(context),
                    const SizedBox(width: 2),
                    _surahNumber(number),
                    const SizedBox(width: 16),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          _surahTitle(title),
                          const SizedBox(height: 6),
                          _surahDetail(detail)
                        ]
                    )
                  ]
              )
          )
      )
  );

  IconButton _surahBackAction(BuildContext context) => IconButton(
      onPressed: (){
        Navigator.pop(context);
      },
      icon: Icon(
          Icons.arrow_back_ios_new,
          color: QuranColor.background
      )
  );

  ClipRRect _surahNumber(int number) => ClipRRect(
      borderRadius: const BorderRadius.all(
          Radius.circular(20)
      ),
      child: SizedBox.fromSize(
          size: const Size.fromRadius(20),
          child: Container(
            color: QuranColor.primary,
            child: Center(
                child: Text(
                    number.toString(),
                    style: TextStyle(
                        color: QuranColor.background,
                        fontWeight: FontWeight.bold
                    )
                )
            ),
          )
      )
  );

  Text _surahTitle(String title) => Text(
      title,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: QuranColor.background
      )
  );

  Text _surahDetail(String detail) => Text(
      detail,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w400,
          color: QuranColor.background
      )
  );
}

class PageState extends StatefulWidget {
  const PageState({super.key, required this.surah});

  final SurahMdl surah;

  @override
  State<PageState> createState() => _PageView();
}

class _PageView extends State<PageState> implements ReadMethod {

  late ReadPresenter _presenter;

  String _surahName = '';
  bool _isLoaded = false;
  bool _isLoading = false;

  final PagingController<int, AyahMdl> _pagingController = PagingController(
      firstPageKey: 0
  );

  @override
  void initState() {
    super.initState();
    _presenter = ReadPresenter();
    _presenter.initialize(this);
  }

  @override
  void actionLoading(bool isLoading) {
    _isLoading = isLoading;
  }

  @override
  void showAlertDialog(TafsirMdl tafsir, int ayahNumber) {
    String? wajiz = tafsir.wajiz;
    String tahlili = tafsir.tahlili ?? '-';
    if (wajiz == null) {
      return showAlertError();
    }

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: _ayahTitle('${QuranString.labelAyahTafsir} $_surahName ${QuranString.labelAyah.toLowerCase()} $ayahNumber'),
              icon: const Icon(Icons.library_books_outlined),
              actions: <Widget>[
                MaterialButton(
                    child: const Text(QuranString.actionAyahClose),
                    onPressed: () {
                      Navigator.pop(context);
                    }
                )
              ],
              content: SingleChildScrollView(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        _ayahSection(QuranString.labelAyahSummary),
                        const SizedBox(height: 4),
                        _ayahTranslation(wajiz),
                        const SizedBox(height: 16),
                        _ayahSection('${QuranString.labelAyahTafsir} ${QuranString.labelAyahTahlili}'),
                        const SizedBox(height: 4),
                        _ayahTranslation(tahlili)
                      ]
                  )
              )
          );
        }
    );
  }

  @override
  void showAlertError() {

  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoaded) {
      _isLoaded = true;
      _surahName = widget.surah.latin.trim();

      _pagingController.addPageRequestListener((pageKey) {
        _presenter.getAyah(_pagingController, pageKey, widget.surah.id, widget.surah.ayahCount);
      });
    }

    return _isLoading ? Center(
        child: CircularProgressIndicator(
            color: QuranColor.primaryDark
        )
    ) : SafeArea(
        child: _listViewPaged()
    );
  }

  PagedListView _listViewPaged() => PagedListView.separated(
      pagingController: _pagingController,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      builderDelegate: PagedChildBuilderDelegate<AyahMdl>(
          itemBuilder: _listItem
      )
  );

  Widget _listItem(BuildContext context, dynamic itemData, int index) {
    AyahMdl ayah = itemData as AyahMdl;
    double top = index == 0 ? 16 : 0;
    return Padding(
        padding: EdgeInsets.only(
            top: top, left: 16, right: 16
        ),
        child: Container(
            padding: const EdgeInsets.only(
                left: 16, right: 16, top: 16
            ),
            decoration: BoxDecoration(
                color: QuranColor.background,
                borderRadius: const BorderRadius.all(
                    Radius.circular(8)
                ),
                border: Border.all(
                    color: QuranColor.black,
                    width: 0.1
                )
            ),
            child: _ayahItem(ayah)
        )
    );
  }

  Column _ayahItem(AyahMdl ayah) {
    String latin = ayah.latin.trim();
    if (latin.contains('')) {
      latin = latin.replaceAll('', ' ');
    }

    if (latin.contains('  ')) {
      latin = latin.replaceAll('  ', ' ');
    }

    List<Widget> widgets = [
      _ayah(ayah.ayah, ayah.arabic.trim()),
      const SizedBox(height: 8),
      _ayahLatin(latin),
      const SizedBox(height: 12),
      _ayahSection(QuranString.labelAyahTranslation)
    ];

    String translation = ayah.translation.trim();
    if (ayah.footnotes != null) {
      String note = ayah.footnotes.toString().trim();
      int number = int.parse(note.split(')')[0]);

      String no = _subscript(number);
      if (note.contains('$number)')) {
        note = note.replaceAll('$number)', '$no\u207E');
      }

      if (translation.contains('$number)')) {
        translation = translation.replaceAll('$number)', '$no\u207E');
      }

      widgets.add(_ayahTranslation(translation));
      widgets.add(_ayahDivider());
      widgets.add(_ayahSection(QuranString.labelAyahNote));

      widgets.add(_ayahNote(note));
    } else {
      widgets.add(_ayahTranslation(translation));
    }

    widgets.add(_ayahBtnDetail(ayah.id, ayah.ayah));

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }

  Divider _ayahDivider() => Divider(
      height: 16,
      thickness: 0.1,
      color: QuranColor.black
  );

  IconButton _ayahBtnDetail(int ayahId, int ayahNumber) => IconButton(
      alignment: Alignment.centerLeft,
      icon: Icon(
        Icons.info_outline_rounded,
        color: QuranColor.accent,
      ),
      onPressed: () => {
        _presenter.getTafsir(ayahId, ayahNumber)
      }
  );

  Row _ayah(int number, String arabic) => Row(
      children: <Widget>[
        _ayahNumber(number),
        const SizedBox(width: 18),
        Expanded(
            flex: 1,
            child: _ayahArabic(arabic)
        )
      ]
  );

  Text _ayahNumber(int number) => Text(
      number.toString().trim(),
      style: TextStyle(
          color: QuranColor.primaryDark,
          fontWeight: FontWeight.bold
      )
  );

  Text _ayahTitle(String title) => Text(
      title,
      style: TextStyle(
          color: QuranColor.black
      )
  );

  Text _ayahArabic(String arabic) => Text(
      arabic.trim(),
      textAlign: TextAlign.end,
      style: TextStyle(
          color: QuranColor.black,
          fontSize: 30,
          height: 1.5
      )
  );

  Text _ayahLatin(String latin) => Text(
      latin.trim(),
      textAlign: TextAlign.start,
      style: TextStyle(
          color: QuranColor.primary,
          fontSize: 13,
          fontStyle: FontStyle.italic
      )
  );

  Text _ayahTranslation(String translation) => Text(
      translation.trim(),
      textAlign: TextAlign.justify
  );

  Text _ayahNote(String note) => Text(
      note.trim(),
      textAlign: TextAlign.justify,
      style: TextStyle(
          color: QuranColor.black,
          fontSize: 13
      )
  );

  Text _ayahSection(String section) => Text(
      section,
      style: TextStyle(
          color: QuranColor.accent
      )
  );

  String _subscript(int number) {
    String result = '';

    for (var char in number.toString().trim().split('')) {
      switch (int.parse(char)) {
        case 0:
          result = '$result\u2070';
          break;
        case 1:
          result = '$result\u00B9';
          break;
        case 2:
          result = '$result\u00B2';
          break;
        case 3:
          result = '$result\u00B3';
          break;
        case 4:
          result = '$result\u2074';
          break;
        case 5:
          result = '$result\u2075';
          break;
        case 6:
          result = '$result\u2076';
          break;
        case 7:
          result = '$result\u2077';
          break;
        case 8:
          result = '$result\u2078';
          break;
        case 9:
          result = '$result\u2079';
          break;
      }
    }

    return result;
  }
}