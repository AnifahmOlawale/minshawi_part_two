import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran_app/provider/theme_color_provider.dart';
import 'package:quran_app/util/app_info.dart';

Widget appInfo(BuildContext context) {
  precacheImage(AssetImage("assets/images/star.png"), context);
  precacheImage(
      AssetImage("assets/images/Muhammad_Siddiq_Minshawi.jpg"), context);
  precacheImage(AssetImage("assets/images/ios_logo.jpg"), context);
  final themeColorProvider = Provider.of<ThemeColor>(context);

  return Column(
    children: [
      Container(
        height: 250,
        width: 250,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            image: DecorationImage(
                image: AssetImage("assets/images/ios_logo.jpg"))),
      ),
      SizedBox(
        height: 20,
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          "$appName ($part)",
          textAlign: TextAlign.center,
          style: TextStyle(color: themeColorProvider.text, fontSize: 18),
        ),
      ),
    ],
  );
}
