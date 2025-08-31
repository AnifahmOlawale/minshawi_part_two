import 'package:flutter/material.dart';
import 'package:quran_app/csv_loader/csv_loader.dart';
import 'package:quran_app/util/hive_box.dart';
import 'package:quran_app/util/value_notifier.dart';

class QuranCsv extends ChangeNotifier {
  //
  List<List<dynamic>> _listOfSurahsPart = [];
  List<List<dynamic>> _listOfSurahs = [];
  List<List<dynamic>> _quran = [];
  List<List<dynamic>> _filterSurah = [];
  List<List<dynamic>> _currentQuranList = [];
  final List _bookmarks =
      quranBookmarks.get("quranBookmarks") ?? []; //List<Map<int, int>>
  String _currentArabicSurahName = "";
  String _currentTransSurahName = "";
  int? _currentSurahIndex = quranLastRead.get("currentSurahIndex");
  int _currentVerseIndex = quranLastRead.get("currentVerseIndex") ?? 0;
  bool _isTransCSV = quranLastRead.get("isTransCSV") ?? true;
  String _currentQuranTrans =
      quranLastRead.get("currentQuranTrans") ?? "Saheeh International";
  int? _indexOfCurrentTransCSV =
      quranLastRead.get("indexOfCurrentTransCSV") ?? 2;

  List _downlodedTransName = [];

  List<dynamic> _currentTransFromDow = [];

  final List _transName = [];
  //Translation Index From CSV
  final List _transIndex = [
    2,
    3,
    4,
    5,
  ];

  final List _transLang = [];

  QuranCsv() {
    //Load Surah
    loadSurah().then((data) {
      _listOfSurahs = data;
      _listOfSurahs.removeLast();
      _listOfSurahs.removeLast();
      _listOfSurahsPart = _listOfSurahs.sublist(18, 114); //TODO
    });
    //LoadQuran
    loadQuran().then((data) {
      _quran = data;
      _quran.removeAt(0);
    });
    //
    //ADD THE DOWNLOADED TRANS
    initTrans();
  }

  //GETTERS
  List<List<dynamic>> get listOfSurahsPart => _listOfSurahsPart;
  List<List<dynamic>> get listOfSurahs => _listOfSurahs;
  List<List<dynamic>> get quran => _quran;
  List<List<dynamic>> get filterSurah => _filterSurah;
  List<List<dynamic>> get currentQuranList => _currentQuranList;
  List get bookmarks => _bookmarks;
  String get currentArabicSurahName => _currentArabicSurahName;
  String get currentTransSurahName => _currentTransSurahName;
  int? get currentSurahIndex => _currentSurahIndex;
  int get currentVerseIndex => _currentVerseIndex;
  List get transName => _transName;
  List get transIndex => _transIndex;
  List get transLang => _transLang;
  bool get isTransCSV => _isTransCSV;
  String get currentQuranTrans => _currentQuranTrans;
  int? get indexOfCurrentTransCSV => _indexOfCurrentTransCSV; //Index from CSV
  List<dynamic> get currentTransFromDow => _currentTransFromDow;

//Set and Save current Surah
  void setCurrentSurahIndex(int getIndex) {
    bool isBookmark = quranListSwitch.value == 0 ? false : true;
    int index = !isBookmark
        ? getIndex
        : _bookmarks[getIndex].keys.first; //if it is bookmark or not
    //Set Current Verse
    if (!isBookmark) {
      setCsurrentVerseIndex(
          index == _currentSurahIndex ? _currentVerseIndex : 0);
    } else {
      setCsurrentVerseIndex(_bookmarks[getIndex].values.first);
    }

    quranLastRead.put("currentSurahIndex", index);
    _currentSurahIndex = index;
    setCurrentList(index);
    setArabicSurahName(index);
    setTransSurahName(index);
    notifyListeners();
  }

//Set Current List Of Open Suran
  void setCurrentList(int index) {
    _currentQuranList = _quran.sublist(_listOfSurahs.elementAt(index)[4] - 1,
        _listOfSurahs.elementAt(index)[5]);

    //SET THE DOWNLOADED TRANS LIST
    setDownTrans();

    notifyListeners();
  }

//Set Last Verse
  void setCsurrentVerseIndex(int index) {
    _currentVerseIndex = index;
    quranLastRead.put("currentVerseIndex", index);
    notifyListeners();
  }

//Change Quran HeaderName SurahName
  void setArabicSurahName(int index) {
    _currentArabicSurahName = _listOfSurahs.elementAt(index)[2];
    notifyListeners();
  }

//SET SURAH TRANSLATION NAME
  void setTransSurahName(int index) {
    _currentTransSurahName = _listOfSurahs.elementAt(index)[1];
    notifyListeners();
  }

//PREVIOUS SURAH
  void previousSurah() {
    setCsurrentVerseIndex(0);
    setCurrentSurahIndex(currentSurahIndex == 0 ? 113 : currentSurahIndex! - 1);
  }

//NEXT SURAH
  void netxSurah() {
    setCsurrentVerseIndex(0);
    setCurrentSurahIndex(currentSurahIndex == 113 ? 0 : currentSurahIndex! + 1);
  }

//Change Translations
  void setChangeTrans(String changeTrans) {
    //CHEACK IF IT IS FROM DOWNLOADED TRANS
    _isTransCSV = !_downlodedTransName.contains(changeTrans);

    quranLastRead.put("isTransCSV", _isTransCSV);

    //SET THE CURRENT TRANSLATION NAME
    _currentQuranTrans = changeTrans;

    quranLastRead.put("currentQuranTrans", changeTrans);

    //SET THE CURRENT TRANS INDEX FROM CSV
    _indexOfCurrentTransCSV = _isTransCSV
        ? _transIndex.elementAt(_transName.indexOf(changeTrans))
        : null;

    quranLastRead.put("indexOfCurrentTransCSV", _indexOfCurrentTransCSV);

    //SET THE DOWNLOADED TRANS LIST
    setDownTrans();

    notifyListeners();
  }

//SET THE DOWNLOADED TRANS LIST
  void setDownTrans() {
    List downList =
        !_isTransCSV ? downloadedTranslations.get(_currentQuranTrans) : [];
    _currentTransFromDow = !_isTransCSV
        ? downList.sublist(_listOfSurahs.elementAt(_currentSurahIndex!)[4] - 1,
            _listOfSurahs.elementAt(_currentSurahIndex!)[5])
        : [];
  }

//SEARCH PLAYER LIST
  void searchPlayerList(String searchWord) {
    _filterSurah = [];
//Filter the surah for search
    _filterSurah = _listOfSurahsPart.where(
      (element) {
        String surahName = element[1].toString().toLowerCase();
        String arabicName = element[2].toString().toLowerCase();
        String engName = element[3].toString().toLowerCase();
        String indexNum = element[0].toString();
        return surahName.contains(searchWord) ||
            arabicName.contains(searchWord) ||
            engName.contains(searchWord) ||
            indexNum.contains(searchWord);
      },
    ).toList();
    notifyListeners();
  }

//SEARCH QURAN LIST
  void search(String searchWord) {
    _filterSurah = [];
//Filter the surah for search
    _filterSurah = _listOfSurahs.where(
      (element) {
        String surahName = element[1].toString().toLowerCase();
        String arabicName = element[2].toString().toLowerCase();
        String engName = element[3].toString().toLowerCase();
        String indexNum = element[0].toString();
        return surahName.contains(searchWord) ||
            arabicName.contains(searchWord) ||
            engName.contains(searchWord) ||
            indexNum.contains(searchWord);
      },
    ).toList();
    notifyListeners();
  }

//ADD BOOKMARK
  void addBookmark(int verseIndex) {
    _bookmarks.add({_currentSurahIndex: verseIndex});
    quranBookmarks.put("quranBookmarks", _bookmarks);
    notifyListeners();
  }

//DELETE A BOOKMARK
  void deleteBookmark(int index) {
    _bookmarks.removeAt(index);
    quranBookmarks.put("quranBookmarks", _bookmarks);
    notifyListeners();
  }

//DELETE All BOOKMARKS
  void deleteALLBookmarks() {
    _bookmarks.clear();
    quranBookmarks.put("quranBookmarks", _bookmarks);
    notifyListeners();
  }

//INITIALIZE TRANSLATIONS
  void initTrans() {
    _transName.clear();
    _transName.addAll([
      "Saheeh International",
      "Muhammad Hamidullah",
      "English Transliteration",
      "Abubakar Mahmoud Gumi",
    ]);
    _transLang.clear();
    _transLang.addAll([
      "English",
      "Franch",
      "English",
      "Hausa",
    ]);

    _downlodedTransName = downloadedTranslations.keys.toList();

    //ADD THE DOWNLOADED TRANS
    _transName.addAll(_downlodedTransName);

    //GET THE TRANSLATION LANGUAGE
    for (var element in _downlodedTransName) {
      final Map info = downloadedTranslationsInfo.get(element);
      _transLang.add(info["trans_lang"]);
    }
    //CHECK IF CURRENT TEANS IS NOR DELETED
    if (!_transName.contains(_currentQuranTrans)) {
      setChangeTrans("Saheeh International");
    }
  }
}
