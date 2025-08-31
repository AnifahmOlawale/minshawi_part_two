import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hijri_calendar/hijri_calendar.dart';
import 'package:quran_app/util/value_notifier.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';

class LocalNotificationService {
  final notificationsPlugin = FlutterLocalNotificationsPlugin();

  bool _isInitialize = false;

  bool get isInitialize => _isInitialize;

  //INITIALIZE
  Future<void> initNotification() async {
    if (isInitialize) return; // Prevent re-initialization

    //INITIALIZE TIMEZONE
    tz.initializeTimeZones();
    final String currentTimeZoneName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(currentTimeZoneName));

    //Prepare Android init settings
    const initSettingsAndroid = AndroidInitializationSettings(
      '@drawable/reminder_icon',
    );

    //Prepare ios init settings
    const initSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    //init settings
    const initSettings = InitializationSettings(
      android: initSettingsAndroid,
      iOS: initSettingsIOS,
    );

    //Finally initialize the PlugeIn!
    await notificationsPlugin.initialize(initSettings);
    _isInitialize = true;
  }

  //NOTIFICATIONS DETAIL SETUP
  NotificationDetails notificationDetails({required String? body}) {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        'daily_channel_id',
        'Daily Notifications',
        channelDescription: 'Daily Notification Channel',
        importance: Importance.max,
        priority: Priority.high,
        styleInformation: BigTextStyleInformation(
          body ?? '', // 👈 ensures full text
          htmlFormatBigText: false,
        ),
      ),
      iOS: const DarwinNotificationDetails(),
    );
  }

  //SHOW NOTIFICATIONS
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    return notificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails(body: body),
    );
  }
  //ON NOTI TAP

  //SCHEDULE A NOTIFICATION
  Future<void> scheduleNotification({
    int hour = 6,
    int minute = 0,
    required bool isHijri,
  }) async {
    //GET THE CURRENT DATE/TIME IN DEVICE'S LOCAL TIME ZONE
    final now = tz.TZDateTime.now(tz.local);

    //  final String title= "Today's Hijri Date";
    final HijriCalendarConfig hijriDate;
    String hijriBody = "";
    const reminderBody =
        "It's been a while since you opened the Qur'an app. 🌙 The Qur'an misses your recitation, take a moment today to read and reflect. 💖";
    const reminderTitle = "Reminder to Read Qur'an";
    const hijriTitle = "Today's Hijri Date";
    //

    //CREATE A DATE/TIEM FOR TODAY AT THE SPECIFIED HOUR/MIN
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    // IF THE SCHEDULED DATE IS BEFORE NOW, ADD A DAY OR TWO

    // ADD 3 DAYS TO REMINDER NOTIFICATION
    if (!isHijri) {
      scheduledDate = scheduledDate.add(Duration(days: 3));
    } else {
      if (scheduledDate.isBefore(now)) {
        scheduledDate = scheduledDate.add(Duration(days: 1));
      }
    }

    //
    hijriDate = HijriCalendarConfig.fromGregorian(scheduledDate);

    hijriBody = hijriDate.toFormat("DDDD - dd - MMMM - yyyy AH").toString();

    //SCHEDULE THE NOTIFICATION
    await notificationsPlugin.zonedSchedule(
      isHijri ? 0 : 1, //ID
      isHijri ? hijriTitle : reminderTitle, //TITLE
      isHijri ? hijriBody : reminderBody, //BODY
      //SCHEDULED DATE
      scheduledDate,

      notificationDetails(
        body: isHijri ? hijriBody : reminderBody,
      ), //  pass body
      //ANDROID SPECIFICATION
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,

      //MAKE NOTIFICATION REPEAT DAILY AT THE SAME TIME
      // matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  //CANCEL ALL NOTIFICATIONS
  Future<void> cancelAllNotifications() async {
    await notificationsPlugin.cancelAll();
  }

  // Call This on Every App Launch
  Future<void> renewDailyHijriNotification() async {
    await cancelAllNotifications(); // remove old one
    if (hijriToggel.value) {
      await scheduleNotification(
        hour: 6,
        minute: 0,
        isHijri: true,
      ); //Schedule Hijri Notification
    }
    await scheduleNotification(
      hour: 6,
      minute: 0,
      isHijri: false,
    ); //Schedule Reminder Notification
  }
}
