import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:quran_app/util/enums.dart';
import 'package:quran_app/util/launch_url.dart';
import 'package:provider/provider.dart';
import 'package:quran_app/provider/theme_color_provider.dart';

class UpdateAlertDialog extends StatelessWidget {
  final String updateLink;
  const UpdateAlertDialog({super.key, required this.updateLink});

  @override
  Widget build(BuildContext context) {
    final themeColorProvider = Provider.of<ThemeColor>(context, listen: false);

    return AlertDialog.adaptive(
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 150, // Fixed height for Lottie animation
              child: Lottie.asset("assets/lottie/rocket.json"),
            ),
            const SizedBox(height: 16), // Increased spacing
            const Text(
              "New update available",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
      actions: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ElevatedButton(
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
                  url: updateLink,
                ),
                child: const Text("Update Now"),
              ),
            ),
            const SizedBox(height: 12), // Added space below the button
          ],
        ),
      ],
    );
  }
}
