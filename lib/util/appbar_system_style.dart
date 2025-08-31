import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:quran_app/provider/theme_color_provider.dart';
import 'package:quran_app/util/enums.dart';

class AppbarSystemStyle {
  SystemUiOverlayStyle appbarSystemStyle(BuildContext context) {
    final themeColorProvider = Provider.of<ThemeColor>(context);

    return SystemUiOverlayStyle(
      systemNavigationBarColor:
          themeColorProvider.currentTheme == SetTheme.dark.name
              ? Theme.of(context).colorScheme.surfaceContainer
              : themeColorProvider.secondary,
      systemNavigationBarIconBrightness: Brightness.light,
      statusBarColor: themeColorProvider.primary ??
          Theme.of(context).scaffoldBackgroundColor,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    );
  }
}
