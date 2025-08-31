import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:csv/csv.dart';
import 'package:quran_app/util/hive_box.dart';
import 'package:quran_app/util/value_notifier.dart';

Future<void> fetchCSVFromGoogleSheet(
    {required Map<String, dynamic> data}) async {
  // final url =
  //     "https://docs.google.com/spreadsheets/d/1QQirRvlxXqmUjlYjbR6jfsqJp6IoX8u-KabezklCMpQ/export?format=csv";
  try {
    final response = await http.get(Uri.parse(data["download_link"]));
    if (response.statusCode == 200) {
      final csvString = utf8.decode(response.bodyBytes); //  Proper UTF-8 decode

      final csv = const CsvToListConverter()
          .convert(csvString); //Convert the CSV toList

      final String transName = data["trans_name"].toString();

      downloadedTranslations.put(
          transName, csv); //Save the downloaded Translation

      downloadedTranslationsInfo.put(
          transName, data); //Save the downloaded Translation Indo Data
      //print(csv[6][0].toString());
      isDownloading.value = false;
    } else {
      //print('Failed to load CSV: ${response.statusCode}');
    }
    isDownloading.value = false;
  } catch (e) {
    isDownloading.value = !isDownloading.value;
  }
}
