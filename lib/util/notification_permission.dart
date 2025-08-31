import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> notificationPermission() async {
  //

  if (Platform.isAndroid) {
    final deviceInfo = DeviceInfoPlugin();
    final androidInfo = await deviceInfo.androidInfo;
    final androidSDKVersion = androidInfo.version.sdkInt;
    if (androidSDKVersion >= 33) {
      PermissionStatus notiPermissionStatus =
          await Permission.notification.status;

      if (notiPermissionStatus.isDenied) {
        await Permission.notification.request();
      }
    }
  }
}
