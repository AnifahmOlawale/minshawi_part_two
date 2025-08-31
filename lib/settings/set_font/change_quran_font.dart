import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran_app/provider/quran_settings_provider.dart';

Future<void> setFont(BuildContext context) {
  return showModalBottomSheet(
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    context: context,
    builder: (context) {
      final quranSettings = Provider.of<QuranSettings>(context);

      return Builder(
        builder: (context) {
          return SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(15),
              width: double.infinity,
              //height: 190,
              child: Column(
                spacing: 10,
                children: [
                  //
                  Text("Qur'an Font"),
                  Card(
                    child: RadioListTile.adaptive(
                      value: "UthmanicHafs",
                      groupValue: quranSettings.quranFont,
                      title: Text("UthmanicHafs"),
                      subtitle: Text(
                        "ٱلۡحَمۡدُ لِلَّهِ رَبِّ ٱلۡعَٰلَمِينَ",
                        textAlign: TextAlign.right,
                        style:
                            TextStyle(fontFamily: 'UthmanicHafs', fontSize: 30),
                      ),
                      onChanged: (value) {
                        quranSettings.setQuranFont(value!);
                      },
                    ),
                  ),
                  Card(
                    child: RadioListTile.adaptive(
                      value: "me_quran",
                      groupValue: quranSettings.quranFont,
                      title: Text("me_quran"),
                      subtitle: Text(
                        "ٱلۡحَمۡدُ لِلَّهِ رَبِّ ٱلۡعَٰلَمِينَ",
                        textAlign: TextAlign.right,
                        style: TextStyle(fontFamily: 'me_quran', fontSize: 30),
                      ),
                      onChanged: (value) {
                        quranSettings.setQuranFont(value!);
                      },
                    ),
                  ),
                  Card(
                    child: RadioListTile.adaptive(
                      value: "AmiriQuran",
                      groupValue: quranSettings.quranFont,
                      title: Text("AmiriQuran"),
                      subtitle: Text(
                        "ٱلۡحَمۡدُ لِلَّهِ رَبِّ ٱلۡعَٰلَمِينَ",
                        textAlign: TextAlign.right,
                        style:
                            TextStyle(fontFamily: 'AmiriQuran', fontSize: 30),
                      ),
                      onChanged: (value) {
                        quranSettings.setQuranFont(value!);
                      },
                    ),
                  )
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
