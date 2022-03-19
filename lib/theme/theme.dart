import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// All of our constant stuff

Color primaryColor = const Color(0xFF0084ff);
Color primaryLight = const Color(0xFFE5CDCD);
Color backgroundColor = const Color(0xFFF9F9F9);

Color greyColor = const Color(0xFFAAAAAA);
Color secondaryColor = const Color(0xFF010203);

Color brownColor = const Color(0xFFFAF0EB);

Color inputBg = const Color(0xFFFAFAFA);

Color inputText = const Color(0xFFBABABA);

Color header1Color = const Color(0xFF06244B);

Color errorLight = const Color(0xFFFDE8EA);

Color errorColor = const Color(0xFFED2F46);

Color textColor = const Color(0xff1C1C1C);

Color text = const Color(0xff1A1A1A);

Color supportingText = const Color(0xff8D9091);

const kDefaultPadding = 20.0;

ThemeData light = ThemeData(
  brightness: Brightness.light,
  primaryColor: primaryColor,
  primaryColorDark: primaryColor,
  primarySwatch: const MaterialColor(
    0xFF0084ff,
    <int, Color>{
      50: Color(0xFF000000),
      100: Color(0xFF000000),
      200: Color(0xFF000000),
      300: Color(0xFF000000),
      400: Color(0xFF000000),
      500: Color(0xFF000000),
      600: Color(0xFF000000),
      700: Color(0xFF000000),
      800: Color(0xFF000000),
      900: Color(0xFF000000),
    },
  ),
  focusColor: primaryColor,
  scaffoldBackgroundColor: Color(0xfff8f8f8),
  cardColor: Color(0xffffffff),
);

// ThemeData dark = ThemeData(
//   brightness: Brightness.dark,
//   primaryColor: Color(0xffff7700),
//   primaryColorDark: Color(0xff222444),
//   primarySwatch: const MaterialColor(
//     0xFFFFFFFF,
//     const <int, Color>{
//       50: const Color(0xFFFFFFFF),
//       100: const Color(0xFFFFFFFF),
//       200: const Color(0xFFFFFFFF),
//       300: const Color(0xFFFFFFFF),
//       400: const Color(0xFFFFFFFF),
//       500: const Color(0xFFFFFFFF),
//       600: const Color(0xFFFFFFFF),
//       700: const Color(0xFFFFFFFF),
//       800: const Color(0xFFFFFFFF),
//       900: const Color(0xFFFFFFFF),
//     },
//   ),
//   accentColor: Color(0xffff7700),
//   scaffoldBackgroundColor: Color(0xff18191a),
//   cardColor: Color(0xff242526),
// );

class ThemeNotifier with ChangeNotifier {
  final String key = "theme";
  late SharedPreferences _prefs;
  late bool _darkTheme;

  bool get darkTheme => _darkTheme;

  ThemeNotifier() {
    _darkTheme = false;
    _loadFromPrefs();
  }

  toggleTheme() {
    _darkTheme = !_darkTheme;
    _saveToPrefs();
    notifyListeners();
  }

  _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  _loadFromPrefs() async {
    await _initPrefs();
    _darkTheme = _prefs.getBool(key) ?? false;
    print(_darkTheme);
    notifyListeners();
  }

  _saveToPrefs() async {
    await _initPrefs();
    _prefs.setBool(key, _darkTheme);
  }
}
