import 'package:flutter/material.dart';
import 'package:quran/view/list/list_page.dart';
import 'package:quran/view/read/read_page.dart';

class QuranRoute {
  static const listPath = '/list';
  static const readPath = '/read';

  static const listPage = ListPage();
  static const readPage = ReadPage();

  static var routes = <String, WidgetBuilder> {
    listPath: (context) => listPage,
    readPath: (context) => readPage
  };
}