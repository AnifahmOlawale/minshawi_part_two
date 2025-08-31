import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> launchURL(BuildContext context, {required String url}) async {
  //

  final Uri link = Uri.parse(url);
  if (await canLaunchUrl(link)) {
    await launchUrl(link, mode: LaunchMode.platformDefault);
  } else {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Could not open Store"),
      ),
    );
  }
}
