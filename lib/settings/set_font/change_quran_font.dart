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
              child: Column(
                spacing: 10,
                children: [
                  //
                  Text("Qur'an Font"),
                  RadioGroup(
                      groupValue: quranSettings.quranFont,
                      onChanged: (value) {
                        quranSettings.setQuranFont(value!);
                      },
                      child: Column(
                        children: [
                          Card(
                            child: RadioListTile.adaptive(
                              value: "UthmanicHafs",
                              title: Text("UthmanicHafs"),
                              subtitle: Text(
                                "ٱلۡحَمۡدُ لِلَّهِ رَبِّ ٱلۡعَٰلَمِينَ",
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    fontFamily: 'UthmanicHafs', fontSize: 30),
                              ),
                            ),
                          ),
                          Card(
                            child: RadioListTile.adaptive(
                              value: "me_quran",
                              title: Text("me_quran"),
                              subtitle: Text(
                                "ٱلۡحَمۡدُ لِلَّهِ رَبِّ ٱلۡعَٰلَمِينَ",
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    fontFamily: 'me_quran', fontSize: 30),
                              ),
                            ),
                          ),
                          Card(
                            child: RadioListTile.adaptive(
                              value: "AmiriQuran",
                              title: Text("AmiriQuran"),
                              subtitle: Text(
                                "ٱلۡحَمۡدُ لِلَّهِ رَبِّ ٱلۡعَٰلَمِينَ",
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    fontFamily: 'AmiriQuran', fontSize: 30),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 35,
                          ),
                        ],
                      ))
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
