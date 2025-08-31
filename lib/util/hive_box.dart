import 'package:hive_ce_flutter/hive_flutter.dart';

final Box updateRefresh = Hive.box("updateRefresh");

final Box settings = Hive.box("settings");

final Box quranLastRead = Hive.box("quranLastRead");

final Box audioPlayer = Hive.box("audioPlayer");

final Box quranBookmarks = Hive.box("quranBookmarks");

final Box downloadedTranslations = Hive.box("downloadedTranslations");

final Box downloadedTranslationsInfo = Hive.box("downloadedTranslationsInfo");
