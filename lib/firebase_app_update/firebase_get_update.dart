import 'package:firebase_database/firebase_database.dart';
import 'package:quran_app/firebase_app_update/firebase_update_model.dart';
import 'package:quran_app/util/app_info.dart';
import 'package:quran_app/util/get_app_version.dart';

Future<UpdateModel?> firebaseGetUpdate() async {
  //

  try {
    final DatabaseReference getUpdateRef =
        FirebaseDatabase.instance.ref("Update");

    final snapshot = await getUpdateRef.get();
    final getAppVersionCodeString = await buildVersion();
    final int getAppVersionCode = int.parse(getAppVersionCodeString);

    if (snapshot.exists) {
      final data = snapshot.value as Map<dynamic, dynamic>;

      // Check if the version in the database is different from the app's current version

      if (isAndroid) {
        if (data["two_android_version"] > getAppVersionCode) {
          return UpdateModel.fromMap(data);
        }
      } else {
        if (data["two_ios_version"] > getAppVersionCode) {
          return UpdateModel.fromMap(data);
        }
      }
    }
    return null;
  } catch (e) {
    // Handle any errors that occur during the database operation
  }
  return null;
}
