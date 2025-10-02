import 'package:flutter/material.dart';
import 'package:quran_app/settings/download_translation/supabase_get_trans_list.dart';

ValueNotifier<bool> hijriToggel =
    ValueNotifier<bool>(true); //FOR HIJRI NOTIFICATION

ValueNotifier<bool> turnOffTrans =
    ValueNotifier<bool>(false); //FOR TARNSLATION TOGGEL ON OR OFF

ValueNotifier<int> quranListSwitch =
    ValueNotifier<int>(0); // FOR QURAN BOTTOM NAVIGATION

final downlaodTransNotifier =
    ValueNotifier<Future<List<Map<String, dynamic>>?> Function()>(
  () => getTransList(),
); // TO REFRESH THE DOWNLOAD PAGE

ValueNotifier<bool> isDownloading =
    ValueNotifier<bool>(false); //FOR TARNSLATION DOWNLOAD STATUES

ValueNotifier<DateTime?> audioSleepTimer =
    ValueNotifier(null); //FOR AUDIO SLEEP TIME
