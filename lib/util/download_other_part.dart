import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran_app/provider/theme_color_provider.dart';
import 'package:quran_app/util/app_info.dart';
import 'package:quran_app/util/enums.dart';
import 'package:quran_app/util/launch_url.dart';

class DownloadOtherPart {
  //

  static Future<void> downOthersDialog(
    BuildContext context,
  ) {
    final themeColorProvider = Provider.of<ThemeColor>(context, listen: false);

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "Download Other Parts",
            style: TextStyle(fontSize: 18),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              //Download Part Two Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor:
                      themeColorProvider.currentTheme == SetTheme.dark.name
                          ? Colors.white
                          : themeColorProvider.background,
                  minimumSize:
                      const Size(double.infinity, 48), // Slightly taller button
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () => launchURL(
                  context,
                  url: isAndroid ? playStoreLinkOne : appleStoreLinkOne,
                ),
                child: const Text("Download Part One"),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        );
      },
    );
  }
}
