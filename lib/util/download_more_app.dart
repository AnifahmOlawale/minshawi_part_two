import 'package:flutter/material.dart';
import 'package:quran_app/util/app_info.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> downloadMoreApp(BuildContext context) async {
  //

  final Uri link = Uri.parse(websiteLink);
  if (await canLaunchUrl(link)) {
    await launchUrl(link, mode: LaunchMode.inAppBrowserView);
  } else {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Could not open Browser"),
      ),
    );
  }
}
