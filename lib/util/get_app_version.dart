import 'package:package_info_plus/package_info_plus.dart';

Future<String> getAppVersion() async {
  final PackageInfo packageInfo = await PackageInfo.fromPlatform();
  String appVersion = packageInfo.version;

  return appVersion;
}

Future<String> buildVersion() async {
  final PackageInfo packageInfo = await PackageInfo.fromPlatform();
  String buildNumber = packageInfo.buildNumber;

  return buildNumber;
}
