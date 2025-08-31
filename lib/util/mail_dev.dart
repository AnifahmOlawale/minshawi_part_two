import 'package:flutter/material.dart';
import 'package:quran_app/util/app_info.dart';
import 'package:quran_app/util/get_app_version.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> contactDeveloperEmail(BuildContext context) async {
  //

  final String appVersion = await getAppVersion();

  final String appBuildNumber = await buildVersion();

  final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'anifahmolawale@gmail.com',
      query: Uri.encodeFull(
          "subject=$appName ($part) &body=${isAndroid ? "Android" : "iOS"}\n Version Name: $appVersion\n Version Code: $appBuildNumber\n"));

  if (await canLaunchUrl(emailUri)) {
    await launchUrl(emailUri);
  } else {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Could not open email app"),
      ),
    );
  }
}
