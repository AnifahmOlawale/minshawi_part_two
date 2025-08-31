import 'package:audio_service/audio_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:quran_app/audio_player/audio_handler.dart';
import 'package:quran_app/firebase_options.dart';
import 'package:quran_app/provider/player_provider.dart';
import 'package:quran_app/provider/quran_csv_provider.dart';
import 'package:quran_app/provider/quran_settings_provider.dart';
import 'package:quran_app/provider/theme_color_provider.dart';
import 'package:quran_app/splash_screen/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:quran_app/util/app_info.dart';
import 'package:quran_app/util/get_app_version.dart';
import 'package:quran_app/util/hive_box.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the Mobile Ads SDK.
  MobileAds.instance.initialize();

  //Initialize supabase

  await Supabase.initialize(
    url: "https://vngfuoocmjpfpugcdoqx.supabase.co",
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZuZ2Z1b29jbWpwZnB1Z2Nkb3F4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTMxOTYxNTIsImV4cCI6MjA2ODc3MjE1Mn0.7QXdCCnN6HParAVpHtbfglkjM4l-4tS07ug1F38_wSQ",
  );

  //INITIALIZE FIREBASE

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  //INITIALIZE ONESIGNAL

  OneSignal.initialize("39790a62-ac88-4e71-a738-ce3a8723a953");

  //INITIALIZE HIVE

  await Hive.initFlutter();

  await Hive.openBox("settings");

  await Hive.openBox("audioPlayer");

  await Hive.openBox("updateRefresh");

  await Hive.openBox("quranLastRead");

  await Hive.openBox("quranBookmarks");

  await Hive.openBox("downloadedTranslations");

  await Hive.openBox("downloadedTranslationsInfo");

  //REFRESH FO NEW UPDATE
  final int? lastVersion = updateRefresh.get("lastVersion");
  final getAppVersionCodeString = await buildVersion();
  final int getAppVersionCode = int.parse(getAppVersionCodeString);

  if (lastVersion == null) {
    updateRefresh.put("lastVersion", getAppVersionCode);
  } else if (lastVersion != getAppVersionCode) {
    updateRefresh.put("lastVersion", getAppVersionCode);
    settings.delete('adsWarnningDialog');
    //TODO for new release refresh
    // settings.clear();
    // audioPlayer.clear();
    // quranLastRead.clear();
    // quranBookmarks.clear();
    // downloadedTranslations.clear();
    // downloadedTranslationsInfo.clear();
  }

  //INITIALIZE JUSE AUDIO BACKGROUND
  await JustAudioBackground.init(
    androidNotificationChannelId: packageName,
    androidNotificationChannelName: appName,
    androidNotificationOngoing: true,
    androidNotificationIcon: 'mipmap/launcher_icon',
  );

  final audioPlayerPackage = AudioPlayer();

  // create PlayerProvider and pass handler later
  final playerProvider = PlayerProvider(audioPlayerPackage);

  //  Create handler
  final handler = AudioPlayerHandlerImpl(audioPlayerPackage, playerProvider);

  //  Assign handler to provider
  playerProvider.setHandler(handler);

  //  Initialize AudioService
  try {
    await AudioService.init(
      builder: () => handler,
      config: AudioServiceConfig(
        androidNotificationChannelId: packageName,
        androidNotificationChannelName: appName,
        androidNotificationOngoing: true,
        androidNotificationIcon: 'mipmap/launcher_icon',
      ),
    );
  } catch (e) {
    //
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeColor()),
        ChangeNotifierProvider(create: (_) => QuranSettings()),
        ChangeNotifierProvider(create: (_) => QuranCsv()),
        ChangeNotifierProvider<PlayerProvider>.value(value: playerProvider),
      ],
      child: const MyApp(),
    ),
  );
}

final SupabaseClient supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    final themeColorProvider = Provider.of<ThemeColor>(context);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "$appName ($part)",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: themeColorProvider.secondary,
          secondary: themeColorProvider.secondary,
          primary: themeColorProvider.primary ??
              Theme.of(context).scaffoldBackgroundColor,
        ),
        appBarTheme: AppBarTheme(
          color: themeColorProvider.secondary,
          foregroundColor: Colors.white,
        ),
        useMaterial3: true,
      ),
      darkTheme: themeColorProvider.theme,
      themeMode: themeColorProvider.themeMode,
      home: const SplashScreen(),
    );
  }
}
