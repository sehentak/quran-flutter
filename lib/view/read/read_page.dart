import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:quran/data/model/ayah.mdl.dart';
import 'package:quran/data/model/surah.mdl.dart';
import 'package:quran/data/model/tafsir.mdl.dart';
import 'package:quran/internal/resource/colors.rsc.dart';
import 'package:quran/view/read/read_method.dart';
import 'package:quran/view/read/read_presenter.dart';

class ReadPage extends StatefulWidget {
  const ReadPage({super.key});

  @override
  State<ReadPage> createState() => _ReadPageState();
}

class _ReadPageState extends State<ReadPage> implements ReadMethod {

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
    String? tahlili = tafsir.tahlili;
    if (wajiz == null) {
      return showAlertError();
    }

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text(
                  'Tafsir $_surahName ayat $ayahNumber',
                  style: TextStyle(
                      color: QuranColor.black
                  )
              ),
              icon: const Icon(Icons.library_books_outlined),
              actions: <Widget>[
                MaterialButton(
                    child: const Text('Tutup'),
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
                        Text(
                            'Ringkasan',
                            style: TextStyle(
                                color: QuranColor.primaryDark,
                                fontWeight: FontWeight.bold
                            )
                        ),
                        Text(
                            wajiz,
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                                color: QuranColor.black
                            )
                        ),
                        const SizedBox(height: 16),
                        Text(
                            'Tafsir Tahlili',
                            style: TextStyle(
                                color: QuranColor.primaryDark,
                                fontWeight: FontWeight.bold
                            )
                        ),
                        Text(
                            tahlili ?? '-',
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                                color: QuranColor.black
                            )
                        )
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
    String detail = '';
    int number = 0;

    if (!_isLoaded) {
      _isLoaded = true;

      final arguments = (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;
      SurahMdl surah = arguments['surah'];

      _surahName = surah.latin.trim();
      number = surah.id;
      detail = '${surah.ayahCount} Ayat • ${surah.translation.trim()}';

      _pagingController.addPageRequestListener((pageKey) {
        _presenter.getAyah(_pagingController, pageKey, surah.id, surah.ayahCount);
      });
    }

    return Scaffold(
        backgroundColor: QuranColor.foreground,
        appBar: _appBar(number, _surahName, detail),
        body: _isLoading ? Center(
            child: CircularProgressIndicator(
                color: QuranColor.primaryDark
            )
        ) : SafeArea(
            child: _listViewPaged()
        )
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
            padding: const EdgeInsets.only(top: 16),
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
      _ayahArabic(ayah.ayah, ayah.arabic.trim()),
      _ayahLatin(latin)
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
      icon: Icon(
        Icons.info_outline_rounded,
        color: QuranColor.accent,
      ),
      onPressed: () => {
        _presenter.getTafsir(ayahId, ayahNumber)
      }
  );

  Container _ayahArabic(int number, String arabic) => Container(
      padding: const EdgeInsets.only(left: 16, right: 16),
      width: double.infinity,
      child: Row(
          children: <Widget>[
            Text(
                number.toString().trim(),
                style: TextStyle(
                    color: QuranColor.primaryDark,
                    fontWeight: FontWeight.bold
                )
            ),
            const SizedBox(width: 18),
            Expanded(
                flex: 1,
                child: Text(
                    arabic.trim(),
                    textAlign: TextAlign.end,
                    style: TextStyle(
                        color: QuranColor.black,
                        fontSize: 30,
                        height: 1.5
                    )
                )
            )
          ]
      )
  );

  Container _ayahLatin(String latin) => Container(
      padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
      width: double.infinity,
      child: Text(
          latin.trim(),
          textAlign: TextAlign.start,
          style: TextStyle(
            color: QuranColor.primary,
            fontSize: 13,
            fontStyle: FontStyle.italic,
          )
      )
  );

  Container _ayahTranslation(String translation) => Container(
      padding: const EdgeInsets.only(top: 8, left: 16, right: 16),
      width: double.infinity,
      child: Text(
          translation.trim(),
          textAlign: TextAlign.start
      )
  );

  Container _ayahNote(String note) => Container(
      padding: const EdgeInsets.only(left: 16, right: 16),
      width: double.infinity,
      child: Text(
          note.trim(),
          textAlign: TextAlign.justify,
          style: TextStyle(
              color: QuranColor.black,
              fontSize: 13
          )
      )
  );

  AppBar _appBar(int number, String title, String detail) => AppBar(
      backgroundColor: QuranColor.primaryDark,
      // elevation: 0,
      automaticallyImplyLeading: false,
      centerTitle: false,
      flexibleSpace: SafeArea(
          child: Container(
              padding: const EdgeInsets.only(
                  right: 16
              ),
              child: Row(
                  children: <Widget>[
                    IconButton(
                        onPressed: (){
                          Navigator.pop(context);
                        },
                        icon: Icon(
                            Icons.arrow_back_ios_new,
                            color: QuranColor.background
                        )
                    ),
                    const SizedBox(width: 2),
                    ClipRRect(
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
                    ),
                    const SizedBox(width: 16),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                              title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: QuranColor.background
                              )
                          ),
                          const SizedBox(height: 6),
                          Text(
                              detail,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  color: QuranColor.background
                              )
                          )
                        ]
                    )
                  ]
              )
          )
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