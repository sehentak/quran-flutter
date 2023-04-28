import 'package:flutter/material.dart';
import 'package:quran/data/model/surah.mdl.dart';
import 'package:quran/internal/resource/colors.rsc.dart';
import 'package:quran/internal/resource/routes.rsc.dart';
import 'package:quran/view/list/list_presenter.dart';
import 'package:quran/view/list/list_method.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> implements ListMethod {

  late ListPresenter _presenter;

  bool _isLoaded = false;
  bool _isLoading = false;
  List<SurahMdl> _listOfSurah = [];

  @override
  void initState() {
    super.initState();
    _presenter = ListPresenter();
    _presenter.initialize(this);
  }

  @override
  void actionLoading(bool isLoading) {
    setState(() {
      _isLoading = isLoading;
    });
  }

  @override
  void dataOfSurah(List<SurahMdl> surah) {
    if (surah.isEmpty) {
      return;
    }

    setState(() {
      _listOfSurah = surah;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoaded) {
      _isLoaded = true;
      _presenter.getDataOfSurah();
    }

    return Scaffold(
        backgroundColor: QuranColor.foreground,
        appBar: AppBar(
            backgroundColor: QuranColor.primaryDark,
            // elevation: 0,
            title: Text(
                'القرآن',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: QuranColor.background
                )
            ),
            centerTitle: true
        ),
        body: _isLoading ? Center(
          child: CircularProgressIndicator(
            color: QuranColor.primaryDark,
          ),
        ) : SafeArea(
            child: _listView()
        )
    );
  }

  ListView _listView() => ListView.builder(
      itemCount: _listOfSurah.length,
      itemBuilder: (BuildContext context, int index) {
        if (_listOfSurah.isEmpty) {
          return null;
        }

        SurahMdl model = _listOfSurah.elementAt(index);
        return ListTile(
          contentPadding: EdgeInsets.only(
              top: index == 0 ? 16 : 6, left: 16, right: 16, bottom: 6
          ),
          title: _listItem(model),
          onTap: () {
            _onClickItemListener(model);
          }
        );
      }
  );

  Widget _listItem(SurahMdl surah) {
    return Container(
        padding: const EdgeInsets.all(16),
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
        child: Row(
            children: <Widget>[
              Text(
                surah.id.toString(),
                style: TextStyle(
                    color: QuranColor.black
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Row(
                            children: <Widget>[
                              Text(
                                  surah.latin.trim(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: QuranColor.primaryDark
                                  )
                              ),
                              const SizedBox(width: 8),
                              Text(
                                  '(${surah.location} • ${surah.ayahCount} Ayat)',
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: false,
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w200,
                                      color: QuranColor.black
                                  )
                              )
                            ]
                        ),
                        const SizedBox(height: 8),
                        Text(
                          surah.translation.trim(),
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w200,
                              color: QuranColor.black
                          ),
                        )
                      ]
                  )
              ),
              const SizedBox(width: 16),
              Text(
                surah.arabic.trim(),
                style: TextStyle(
                  fontSize: 18,
                    color: QuranColor.black
                )
              )
            ]
        )
    );
  }

  void _onClickItemListener(SurahMdl surah) {
    Navigator.pushNamed(
        context,
        QuranRoute.readPath,
        arguments: {
          'surah': surah
        }
    );
  }
}