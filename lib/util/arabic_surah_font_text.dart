String arabicSurahFont(int index) {
  String surahNameArabic = "surah";

  if (index.toString().length == 1) {
    surahNameArabic = "surah00${index.toString()}";
  } else if (index.toString().length == 2) {
    surahNameArabic = "surah0${index.toString()}";
  } else {
    surahNameArabic = "surah${index.toString()}";
  }

  return surahNameArabic;
}
