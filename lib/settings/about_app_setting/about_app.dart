import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:quran_app/provider/theme_color_provider.dart';
import 'package:quran_app/util/enums.dart';
import 'package:quran_app/widget_tree/app_info_widget.dart';
import 'package:quran_app/util/get_app_version.dart';

class AboutApp extends StatefulWidget {
  const AboutApp({super.key});

  @override
  State<AboutApp> createState() => _AboutAppState();
}

class _AboutAppState extends State<AboutApp> {
  String appVersion = "";
  @override
  void initState() {
    super.initState();

    getAppVersion().then(
      (value) {
        setState(() {
          appVersion = value;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeColorProvider = Provider.of<ThemeColor>(context);

    return Scaffold(
      backgroundColor: themeColorProvider.background,
      appBar: AppBar(
        backgroundColor: themeColorProvider.currentTheme == SetTheme.dark.name
            ? Theme.of(context).colorScheme.surfaceContainer
            : themeColorProvider.secondary,
        foregroundColor: Colors.white,
        title: Text("About Application"),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: themeColorProvider.primary,
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              appInfo(context),
              Text(
                "Version: $appVersion",
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
