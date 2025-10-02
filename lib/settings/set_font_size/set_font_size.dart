import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran_app/provider/quran_settings_provider.dart';
import 'package:quran_app/provider/theme_color_provider.dart';

Future<void> setFontSize(BuildContext context) {
  return showModalBottomSheet(
    showDragHandle: true,
    isScrollControlled: true,
    useSafeArea: true,
    context: context,
    builder: (context) {
      final quranSettings = Provider.of<QuranSettings>(context);
      final themeColorProvider = Provider.of<ThemeColor>(context);

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
                  Text("Qur'an Font Size"),

                  //Quran Font
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      CircleAvatar(
                        radius: 15,
                        backgroundColor: themeColorProvider.primary,
                        child: Text(
                          quranSettings.quranFontSize.toStringAsFixed(0),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      Expanded(
                        child: Slider.adaptive(
                          value: quranSettings.quranFontSize,
                          min: 14,
                          max: 40,
                          label: "Qur'an Font Size",
                          onChanged: (value) {
                            quranSettings.setQuranFontSize(value);
                          },
                        ),
                      ),
                    ],
                  ),

                  Text(
                    "ٱلۡحَمۡدُ لِلَّهِ رَبِّ ٱلۡعَٰلَمِينَ",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'UthmanicHafs',
                        fontSize: quranSettings.quranFontSize),
                  ),
                  //Translation Font Size
                  Text("Qur'an Translation Size"),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      CircleAvatar(
                        radius: 15,
                        backgroundColor: themeColorProvider.primary,
                        child: Text(
                          quranSettings.translationFontSize.toStringAsFixed(0),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      Expanded(
                        child: Slider.adaptive(
                          value: quranSettings.translationFontSize,
                          min: 14,
                          max: 40,
                          label: "Qur'an Translation Size",
                          onChanged: (value) {
                            quranSettings.setTransFontSize(value);
                          },
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "Praise be to Allah, Lord of the Worlds.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'UthmanicHafs',
                        fontSize: quranSettings.translationFontSize),
                  ),
                  const SizedBox(
                    height: 35,
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
