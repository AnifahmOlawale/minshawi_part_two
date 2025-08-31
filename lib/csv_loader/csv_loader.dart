import 'package:csv/csv.dart';
import 'package:flutter/services.dart';

Future<List<List<dynamic>>> loadSurah() async {
  final rawData = await rootBundle.loadString("assets/csv/Surah.csv");
  List<List<dynamic>> listOfSurahs = CsvToListConverter().convert(rawData);
  return listOfSurahs;
}

Future<List<List<dynamic>>> loadQuran() async {
  final rawData = await rootBundle.loadString("assets/csv/Quran.csv");
  List<List<dynamic>> listOfSurah = CsvToListConverter().convert(rawData);
  return listOfSurah;
}
