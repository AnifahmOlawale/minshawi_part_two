import 'package:flutter/material.dart';

Widget themeChangeBox(
    {required VoidCallback onTap,
    required String text,
    required Color color,
    required BoxBorder? border}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      height: 100,
      width: 100,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
        border: border,
      ),
      child: Center(
          child: Text(
        text,
        textAlign: TextAlign.center,
      )),
    ),
  );
}
