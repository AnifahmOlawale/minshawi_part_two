import 'package:flutter/material.dart';
import 'package:quran_app/provider/theme_color_provider.dart';

Widget basmala({required ThemeColor themeColorProvider}) {
  return Padding(
    padding: EdgeInsets.all(8),
    child: Image.asset(
      "assets/images/basmala.png",
      color: themeColorProvider.quranText,
      scale: 3,
      fit: BoxFit.fill,
      // color: Colors.black,
    ),
  );
}
