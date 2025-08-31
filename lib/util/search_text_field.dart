import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran_app/provider/quran_csv_provider.dart';

Widget searchtextField(
  BuildContext context, {
  required TextEditingController? controller,
  required FocusNode? focusNode,
  required bool isPlayer,
}) {
  final quranCsv = Provider.of<QuranCsv>(context);

  return TextField(
    controller: controller,
    focusNode: focusNode,
    style: TextStyle(color: Colors.white),
    decoration: InputDecoration(
        hintText: "Search surah",
        hintStyle: TextStyle(color: Colors.white),
        border: InputBorder.none),
    onChanged: (value) {
      if (value.isNotEmpty) {
        isPlayer
            ? quranCsv.searchPlayerList(value.toLowerCase().trim())
            : quranCsv.search(value.toLowerCase().trim());
      }
    },
  );
}
