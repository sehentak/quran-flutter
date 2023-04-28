import 'dart:ui';

class QuranColor {
  static final Color foreground = _HexColor('#F6F6F6');
  static final Color background = _HexColor('#FFFFFF');
  static final Color black = _HexColor('#31394A');
  static final Color primary = _HexColor('#649C8F');
  static final Color primaryDark = _HexColor('#25564D');
  static final Color accent = _HexColor('#B68E66');
}

class _HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor';
    }
    return int.parse(hexColor, radix: 16);
  }

  _HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}