import 'package:quran_app/util/app_info.dart';

class UpdateModel {
  final String? androidUpdateLink;
  final String? iosUpdateLink;
  final int? androidVersion;
  final int? iosVersion;

  UpdateModel({
    required this.androidUpdateLink,
    required this.androidVersion,
    required this.iosVersion,
    required this.iosUpdateLink,
  });

  factory UpdateModel.fromMap(Map<dynamic, dynamic> map) {
    return UpdateModel(
      androidUpdateLink: map['two_android_update_link'] ?? websiteLink,
      iosUpdateLink: map['two_ios_update_link'] ?? websiteLink,
      androidVersion: map['two_android_version'] ?? 0,
      iosVersion: map['two_ios_version'] ?? 0,
    );
  }
}
