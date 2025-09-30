import 'package:flutter/material.dart';
import 'package:disable_battery_optimizations_latest/disable_battery_optimizations_latest.dart';
import 'package:provider/provider.dart';
import 'package:quran_app/provider/theme_color_provider.dart';
import 'package:quran_app/util/enums.dart';

class BatteryOptimizationDialog {
  static Future<void> show(BuildContext context) async {
    final themeColorProvider = Provider.of<ThemeColor>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Disable Battery Optimization"),
        content: const Text(
          "To ensure daily reminders work properly, please disable battery optimization for this app.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor:
                  themeColorProvider.currentTheme == SetTheme.dark.name
                      ? Colors.white
                      : themeColorProvider.background,
            ),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await DisableBatteryOptimizationLatest
                  .showDisableBatteryOptimizationSettings();
            },
            style: TextButton.styleFrom(
              foregroundColor:
                  themeColorProvider.currentTheme == SetTheme.dark.name
                      ? Colors.white
                      : themeColorProvider.background,
            ),
            child: const Text("Open Settings"),
          ),
        ],
      ),
    );
  }
}
