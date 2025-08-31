import 'dart:async';
import 'package:disable_battery_optimizations_latest/disable_battery_optimizations_latest.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:quran_app/home_page/home_page.dart';
import 'package:quran_app/provider/theme_color_provider.dart';
import 'package:quran_app/util/app_info.dart';
import 'package:quran_app/util/appbar_system_style.dart';
import 'package:quran_app/util/hive_box.dart';
import 'package:quran_app/util/local_notification_service.dart';
import 'package:quran_app/util/value_notifier.dart';
import 'package:quran_app/widget_tree/app_info_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    /* Timer(
      Duration(seconds: 3),
      () {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => HomePage(),
            transitionDuration: Duration(seconds: 1),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              const curve = Curves.ease;
              var tween =
                  Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              return SlideTransition(
                position: animation.drive(tween),
                child: child,
              );
            },
          ),
        );
      },
    );*/
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      //Initialize LocalNotification

      bool? isBatteryDisabled = true;
      if (isAndroid) {
        isBatteryDisabled = await DisableBatteryOptimizationLatest
                .isBatteryOptimizationDisabled ??
            true;
        //
      } else {
        isBatteryDisabled = true; // iOS does not have battery optimization
      }

      final bool hijriToggelValue = settings.get("hijriToggelValue") ??
          isBatteryDisabled; //FOR NOTIFICATION TOGGEL
      hijriToggel.value = hijriToggelValue; //FOR NOTIFICATION TOGGEL
      // 1 Create service instance
      final notificationService = LocalNotificationService();
      // 2 Initialize notifications
      await notificationService.initNotification();
      // 3 Reschedule Hijri + Reminder notifications
      await notificationService.renewDailyHijriNotification();

      Timer(
        Duration(seconds: 3),
        () {
          Navigator.of(context).pushReplacement(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  const HomePage(),
              transitionDuration: Duration(seconds: 1),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
            ),
          );
        },
      );
    });

    /* Timer(
      Duration(seconds: 3),
      () {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => HomePage(
              title: "",
            ),
            transitionDuration: Duration(seconds: 2),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              const curve = Curves.easeInOut;
              var tween =
                  Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              return SlideTransition(
                position: animation.drive(tween),
                child: child,
              );
            },
          ),
        );
      },
    );*/
  }

  @override
  Widget build(BuildContext context) {
    final themeColorProvider = Provider.of<ThemeColor>(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppbarSystemStyle().appbarSystemStyle(context),
      child: Scaffold(
        backgroundColor: themeColorProvider.background,
        appBar: null,
        body: SafeArea(
            child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [appInfo(context)],
          ),
        )),
      ),
    );
  }
}
