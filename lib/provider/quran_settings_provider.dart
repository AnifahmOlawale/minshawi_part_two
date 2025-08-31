import 'package:flutter/material.dart';
import 'package:quran_app/util/hive_box.dart';

class QuranSettings extends ChangeNotifier {
  String _quranFont = "UthmanicHafs";
  double _quranFontSize = 30;
  double _translationFontSize = 20;

  String get quranFont => _quranFont;
  double get quranFontSize => _quranFontSize;
  double get translationFontSize => _translationFontSize;

  QuranSettings() {
    final String getQuranFont = settings.get("quranFont") ?? "UthmanicHafs";

    final double getQuranFontSize = settings.get("quranFontSize") ?? 20.0;

    final double getTransFontSize = settings.get("transFontSize") ?? 20.0;

    //set Quran Font

    _quranFont = getQuranFont;

    //set Quran Font size

    _quranFontSize = getQuranFontSize;

    //set Translation Font size
    _translationFontSize = getTransFontSize;
  }

  void setQuranFont(String font) {
    _quranFont = font;
    settings.put("quranFont", font);
    notifyListeners();
  }

  void setQuranFontSize(double quranFontSize) {
    _quranFontSize = quranFontSize;
    settings.put("quranFontSize", quranFontSize);

    notifyListeners();
  }

  void setTransFontSize(double transFontSize) {
    _translationFontSize = transFontSize;
    settings.put("transFontSize", transFontSize);

    notifyListeners();
  }
}
