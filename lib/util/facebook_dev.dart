import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> contactDeveloperFB(BuildContext context) async {
  //

  final Uri link = Uri.parse("https://www.facebook.com/abdulazeem.anifahm");

  if (await canLaunchUrl(link)) {
    await launchUrl(link, mode: LaunchMode.platformDefault);
  } else {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Could not open Facebook app"),
      ),
    );
  }
}
