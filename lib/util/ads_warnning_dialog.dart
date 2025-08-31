import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:quran_app/util/hive_box.dart';

class AdsWarnningDialog {
  static Future<void> show(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          "🌟 Important Notice 🌟",
          style: TextStyle(fontSize: 18),
        ),
        content: Html(
            data:
                "<b>Assalamu Alaikum (Peace be upon you),</b><br>  Our beloved Quran app contains ads to support its development. However, we understand that excessive ads can be distracting.<br> <b>Feel free to use the app offline</b>, as all features work seamlessly without an internet connection.<br>  May your journey with the Quran be blessed and enlightening. 📖🌙<br>  <b>JazakAllah Khair (May Allah reward you)</b>🙏<br>"),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              settings.put('adsWarnningDialog', true);
              //
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}
