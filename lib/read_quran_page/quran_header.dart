import 'package:flutter/material.dart';

Widget quranHeader({required String title}) {
  return Stack(
    children: [
      Image.asset(
        "assets/images/surahframe.png",
        height: 50,
        width: double.infinity,
        fit: BoxFit.fill,
      ),
      Positioned(
        right: 0,
        left: 0,
        top: 0,
        bottom: 0,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'ArabicHeader',
                color: const Color.fromARGB(255, 87, 62, 54),
              ),
            ),
          ),
        ),
      ),
    ],
  );
}
