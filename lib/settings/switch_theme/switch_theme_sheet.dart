import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran_app/widget_tree/theme_change_box.dart';
import 'package:quran_app/provider/theme_color_provider.dart';
import 'package:quran_app/util/enums.dart';

Future<void> themeSheet(BuildContext context) {
  return showModalBottomSheet(
    showDragHandle: true,
    useSafeArea: true,
    context: context,
    builder: (context) {
      return Builder(builder: (context) {
        final themeColorProvider =
            Provider.of<ThemeColor>(context, listen: true);
        return Container(
          padding: const EdgeInsets.all(15),
          width: double.infinity,
          height: 200,
          child: Column(
            spacing: 10,
            children: [
              Text("Select app theme"),
              Row(
                spacing: 10,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  themeChangeBox(
                    color: Colors.white,
                    text: "Light",
                    border:
                        themeColorProvider.currentTheme == SetTheme.light.name
                            ? Border.all(
                                color: const Color.fromARGB(255, 252, 227, 1),
                                width: 2)
                            : null,
                    onTap: () {
                      themeColorProvider.swichTheme(mode: SetTheme.light);
                      Navigator.pop(context);
                    },
                  ),
                  themeChangeBox(
                    color: Colors.black,
                    text: "Dark",
                    border:
                        themeColorProvider.currentTheme == SetTheme.dark.name
                            ? Border.all(
                                color: const Color.fromARGB(255, 252, 227, 1),
                                width: 2)
                            : null,
                    onTap: () {
                      themeColorProvider.swichTheme(mode: SetTheme.dark);
                      Navigator.pop(context);
                    },
                  ),
                  themeChangeBox(
                    color: themeColorProvider.themeDesign,
                    text: "Coloured",
                    border:
                        themeColorProvider.currentTheme == SetTheme.colured.name
                            ? Border.all(
                                color: const Color.fromARGB(255, 252, 227, 1),
                                width: 2)
                            : null,
                    onTap: () {
                      themeColorProvider.swichTheme(mode: SetTheme.colured);
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      });
    },
  );
}
