import 'package:flutter/material.dart';
import 'package:quran_app/util/enums.dart';
import 'package:quran_app/util/hive_box.dart';

class ThemeColor extends ChangeNotifier {
  //Colour Theme
  final Color _primaryColour =
      Color.fromRGBO(0, 31, 62, 1); //Color.fromRGBO(0, 128, 129, 1);
  final Color _secondaryColour = Color.fromRGBO(23, 47, 81, 1);
  final Color _backgroundColour = Color.fromRGBO(0, 31, 62, 1);
  final Color _cardColour = Color.fromRGBO(23, 47, 81, 1);
  final Color _playerCardColour = Color.fromRGBO(23, 47, 81, 0.845);
  final Color _playerPageColour = Color.fromRGBO(220, 170, 221, 1);
  final Color _quranBackgroundColour = Color.fromARGB(255, 255, 239, 231);
  final Color _quranTextColour = Color.fromARGB(255, 87, 62, 54);
  final Color _quranTransColour = Color.fromRGBO(0, 31, 62, 1);
  final Color _textColour = Colors.white;
  final Color _controlColour = Color.fromRGBO(0, 31, 62, 1);

  //Dark Theme
  // final Color _primaryDark = Colors.grey.shade800;
  final Color _secondaryDark = Colors.grey.shade900;
  //final Color _backgroundDark = Colors.grey.shade900;
  //final Color _cardDark = Colors.grey.shade900;
  //final Color _playerCardDark = Color.fromARGB(159, 5, 5, 5);
  //final Color _playerPageDark = Colors.grey.shade800;
  // final Color _quanBackgroundDark = Color.fromARGB(255, 255, 239, 231);
  final Color _quranTextDark = Color.fromARGB(255, 255, 255, 255);
  final Color _quranTransDark = Color.fromRGBO(0, 31, 62, 1);
  final Color _textDark = Colors.white;
  final Color _controlDark = Colors.white;

  //Light Theme
  final Color _primaryLight = Color.fromRGBO(0, 31, 62, 1);
  final Color _secondaryLight = Color.fromRGBO(23, 47, 81, 1);
  //final Color _backgroundLight = Color.fromRGBO(0, 31, 62, 1);
  final Color _cardLight = Color.fromRGBO(23, 47, 81, 1);
  final Color _playerCardLight = Color.fromRGBO(23, 47, 81, 0.845);
  final Color _playerPageLight = Color.fromRGBO(220, 170, 221, 1);
  final Color _quranBackgroundLight = Color.fromARGB(255, 255, 239, 231);
  final Color _quranTextLight = Color.fromARGB(255, 87, 62, 54);
  final Color _quranTransLight = Color.fromRGBO(0, 31, 62, 1);
  final Color _textLight = Color.fromRGBO(0, 31, 62, 1);
  final Color _controlLight = Color.fromRGBO(0, 31, 62, 1);

  //ThemeData
  //ThemeData _theme = ThemeData.dark(useMaterial3: true);
  ThemeData _theme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Color.fromRGBO(0, 31, 62, 1),
      primary: Color.fromRGBO(0, 31, 62, 1),
      secondary: Color.fromRGBO(23, 47, 81, 1),
      brightness: Brightness.dark,
    ),
    useMaterial3: true,
  );
  ThemeMode _themeMode = ThemeMode.dark;

  final Color _themeDesign = Color.fromRGBO(0, 31, 62, 1);
  final Color _selectedCardColour = Color.fromRGBO(220, 170, 221, 1);
  final Color _selectedTextColour = Color.fromRGBO(0, 31, 62, 1);

  late Color? _primary;
  late Color _secondary;
  late Color? _background;
  late Color? _card;
  late Color? _playerCard;
  late Color? _playerPage;
  late Color? _quranBackground;
  late Color _quranText;
  late Color _quranTrans;
  late Color _text;
  late Color _control;

  String currentTheme = settings.get("currentTheme") ?? SetTheme.colured.name;

  ThemeColor() {
    switchCaseMode(SetTheme.values.firstWhere(
      (element) => element.name == currentTheme,
    ));
  }

  Color? get primary => _primary;
  Color get secondary => _secondary;
  Color? get background => _background;
  Color? get card => _card;
  Color? get playerCard => _playerCard;
  Color? get playerPage => _playerPage;
  Color? get quranBackground => _quranBackground;
  Color get quranText => _quranText;
  Color get quranTrans => _quranTrans;
  Color get text => _text;
  Color get control => _control;
  Color get selectedCardColour => _selectedCardColour;
  Color get selectedTextColour => _selectedTextColour;

  ThemeData get theme => _theme;
  ThemeMode get themeMode => _themeMode;

  Color get themeDesign => _themeDesign;

  void swichTheme({required SetTheme mode}) {
    settings.put("currentTheme", mode.name);

    currentTheme = settings.get("currentTheme");

    switchCaseMode(mode);

    notifyListeners();
  }

  void switchCaseMode(SetTheme mode) {
    switch (mode) {
      case SetTheme.colured:
        _primary = _primaryColour;
        _secondary = _secondaryColour;
        _background = _backgroundColour;
        _card = _cardColour;
        _playerCard = _playerCardColour;
        _playerPage = _playerPageColour;
        _quranBackground = _quranBackgroundColour;
        _quranText = _quranTextColour;
        _quranTrans = _quranTransColour;
        _text = _textColour;
        _control = _controlColour;

        _theme = ThemeData.light();
        _themeMode = ThemeMode.light;

        break;
      case SetTheme.light:
        _primary = _primaryLight;
        _secondary = _secondaryLight;
        _background = null;
        _card = _cardLight;
        _playerCard = _playerCardLight;
        _playerPage = _playerPageLight;
        _quranBackground = _quranBackgroundLight;
        _quranText = _quranTextLight;
        _quranTrans = _quranTransLight;
        _text = _textLight;
        _control = _controlLight;
        _theme = ThemeData.light();
        _themeMode = ThemeMode.light;

        break;
      case SetTheme.dark:
        _primary = null;
        _secondary = _secondaryDark;
        _background = null;
        _card = null;
        _playerCard = null;
        _playerPage = null;
        _quranBackground = null;
        _quranText = _quranTextDark;
        _quranTrans = _quranTransDark;
        _text = _textDark;
        _control = _controlDark;

        _theme = ThemeData(
          brightness: Brightness.dark,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Color.fromRGBO(0, 31, 62, 1),
            primary: Color.fromRGBO(0, 31, 62, 1),
            secondary: Color.fromRGBO(23, 47, 81, 1),
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
        );
        _themeMode = ThemeMode.dark;

        break;
    }
  }
}
