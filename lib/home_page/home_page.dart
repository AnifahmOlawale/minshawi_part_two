import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:quran_app/ads/banner_ads_class.dart';
import 'package:quran_app/ads/inter_ads_class.dart';
import 'package:quran_app/firebase_app_update/firebase_get_update.dart';
import 'package:quran_app/firebase_app_update/Update_alert_dialog.dart';
import 'package:quran_app/home_page/home_navigation_list.dart';
import 'package:quran_app/audio_player/player_widget.dart';
import 'package:quran_app/audio_player/player_surah_list.dart';
import 'package:quran_app/provider/player_provider.dart';
import 'package:quran_app/provider/quran_csv_provider.dart';
import 'package:quran_app/settings/download_translation/supabase_get_trans_list.dart';
import 'package:quran_app/util/ads_warnning_dialog.dart';
import 'package:quran_app/util/appbar_system_style.dart';
import 'package:quran_app/util/enums.dart';
import 'package:quran_app/util/hive_box.dart';
import 'package:quran_app/util/notification_permission.dart';
import 'package:quran_app/util/search_text_field.dart';
import 'package:quran_app/widget_tree/listwidget.dart';
import 'package:quran_app/provider/theme_color_provider.dart';
import 'package:quran_app/util/app_info.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:hijri_calendar/hijri_calendar.dart';
import 'package:share_plus/share_plus.dart';
import 'package:quran_app/util/value_notifier.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _offsetAnimation;

  bool _playerPageOpen = false;
  bool _playerListPage = false;

  bool _isSearch = false;

  final TextEditingController _searchController = TextEditingController();

  final FocusNode _searchFocusNode = FocusNode();

  final String _shareText =
      "Assalamu alaikum, I'm using $appName. This new app lets you listen to the recitation of complete Holy Quran by $reciterName. This app works perfectly offline.  Download $appName app for FREE: ${isAndroid ? playStoreLink : appleStoreLink}"; //TODO

  late final HijriCalendarConfig hijriDate;

  final List<String> _homeListTitle = [
    "",
    "",
    "Read Qur'an",
    "Settings",
    "Download the other part",
    "Download More Qur'an Apps",
    "Rate App",
  ];

  final List<Icon> _homeListIcons = [
    Icon(Icons.library_music),
    Icon(Icons.calendar_month),
    Icon(Icons.menu_book),
    Icon(Icons.settings),
    Icon(Icons.download_rounded),
    Icon(Icons.download_rounded),
    Icon(Icons.star),
  ];

  final ItemScrollController _listScrollController = ItemScrollController();

  void preloadImages(BuildContext context) {
    precacheImage(AssetImage("assets/images/star.png"), context);
  }

  final BannerAdsClass _bannerAdsClass = BannerAdsClass();

  @override
  void initState() {
    super.initState();
    _homeListTitle[0] = appName;

    turnOffTrans.value = settings.get("turnOffTrans") ??
        false; //FOR TRANSLATION TOGGEL OFF OR ON

    hijriDate = HijriCalendarConfig.now();

    _homeListTitle[1] =
        hijriDate.toFormat("DDDD - dd - MMMM - yyyy AH").toString();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    _offsetAnimation = Tween<Offset>(
      begin: Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    //ADS
    _admobAds();

    //
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        //Get notification permission for android 13>
        await notificationPermission();

        //Show ads warnning
        final bool getAdsWarnningDialog =
            await settings.get('adsWarnningDialog') ?? false;

        if (!getAdsWarnningDialog && mounted) {
          AdsWarnningDialog.show(context);
        }

        //Call supabase so unavalable trans on device will be deleted
        await getTransList(); //To delete Unavalabile Downloaded Trans

        //Check fo app update in firebase
        final value = await firebaseGetUpdate();

        if (value != null && mounted) {
          // Show update dialog if the app version is different
          // from the version in Firebase
          showDialog(
            context: context,
            builder: (_) => UpdateAlertDialog(
              updateLink: isAndroid
                  ? value.androidUpdateLink.toString()
                  : value.iosUpdateLink.toString(),
            ),
          );
        }

        //
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _animationController.dispose();

    super.dispose();
  }

//ADMOB LOADING
  void _admobAds() {
    //Load ADMOB Banner Ad
    _bannerAdsClass.loadBanner(
      onAdLoaded: () => setState(() {
        // Trigger a rebuild to show the banner ad
      }),
    );
    //Loade Interstitial Ad
    InterstitialAdmob().loadAdInterstitial();
  }

//PLAYER PAGE CONTROLLER
  void _playerController() {
    //
    setState(() {
      _searchController.text = "";
      _isSearch = false;
      _playerPageOpen = !_playerPageOpen;
      if (_playerPageOpen) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
      // _listScrollController.jumpTo(index: PlayerProvider().currentPlayerIndex!);
    });
  }

//LIST PAGE CONTROLLER
  void _listController() {
    //
    setState(() {
      _playerListPage = !_playerListPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    preloadImages(context);
    final themeColorProvider = Provider.of<ThemeColor>(context);
    final quranCsv = Provider.of<QuranCsv>(context);
    final playerProvider = Provider.of<PlayerProvider>(context, listen: true);

    return Scaffold(
      backgroundColor: themeColorProvider.background,
      appBar: AppBar(
        backgroundColor: themeColorProvider.currentTheme == SetTheme.dark.name
            ? Theme.of(context).colorScheme.surfaceContainer
            : themeColorProvider.secondary,
        foregroundColor: Colors.white,
        title: _isSearch
            ? searchtextField(
                context,
                controller: _searchController,
                focusNode: _searchFocusNode,
                isPlayer: true,
              )
            : Text(appName),
        leading: _playerListPage || _playerPageOpen ? BackButton() : null,
        actions: [
          if (!_playerListPage)
            IconButton(
              tooltip: "Share",
              onPressed: () {
                SharePlus.instance
                    .share(ShareParams(text: _shareText, subject: "Share App"));
              },
              icon: Icon(Icons.share),
            ),
          if (_playerListPage && !_playerPageOpen)
            IconButton(
              tooltip: _isSearch ? "Close Search" : "Search",
              onPressed: () {
                setState(() {
                  _searchController.text = "";
                  _isSearch = !_isSearch;
                  _isSearch
                      ? _searchFocusNode.requestFocus()
                      : FocusScope.of(context).unfocus();
                });
              },
              icon: !_isSearch ? Icon(Icons.search) : Icon(Icons.cancel),
            ),
          const SizedBox(
            width: 10,
          )
        ],
        systemOverlayStyle: AppbarSystemStyle().appbarSystemStyle(context),
      ),
      body: SafeArea(
          child: PopScope(
        canPop: !_playerListPage,
        onPopInvokedWithResult: (didPop, result) {
          if (_playerPageOpen) {
            _playerController();
          } else if (_playerListPage && _isSearch) {
            setState(() {
              _searchController.text = "";
              _isSearch = false;
            });
          } else if (_playerListPage && !_isSearch) {
            _listController();
          }
        },
        child: Center(
          child: Stack(
            children: [
              //Home
              HomeNavigationList(
                playerListPage: _playerListPage,
                homeListIcons: _homeListIcons,
                homeListTitle: _homeListTitle,
                listController: _listController,
                admobAds: _admobAds,
                bannerAdsClass: _bannerAdsClass,
              ),

              //Surah List
              if (quranCsv.listOfSurahsPart.isNotEmpty)
                PlayerSurahList(
                  quranCsv: quranCsv,
                  isSearch: _isSearch,
                  playerListPage: _playerListPage,
                  listScrollController: _listScrollController,
                  isSearchControllerEmpty: _searchController.text.isNotEmpty,
                  onCardClick: _playerController,
                ),

              //Player Page
              SlideTransition(
                position: _offsetAnimation,
                child: PlayerPage(
                  themeColorProvider: themeColorProvider,
                  quranCsv: quranCsv,
                ),
              ),

              //Banner Ad And Floating Player Indicator
              Positioned(
                right: 0,
                left: 0,
                bottom: 10,
                child: Column(
                  children: [
                    //Floating Player Indicator
                    if (!_playerPageOpen &&
                        playerProvider.currentPlayerIndex != null)
                      GestureDetector(
                        onTap: () {
                          //
                          if (!_playerListPage) {
                            _listController();
                            _playerController();
                          } else {
                            _playerController();
                          }
                        },
                        child: Center(
                          child: bottomPlayer(context),
                        ),
                      ),
                    //  Show Banner Only If Loaded
                    if (_bannerAdsClass.bannerAd != null && !_playerPageOpen)
                      Container(
                        alignment: Alignment.center,
                        width: _bannerAdsClass.bannerAd!.size.width.toDouble(),
                        height:
                            _bannerAdsClass.bannerAd!.size.height.toDouble(),
                        child: AdWidget(ad: _bannerAdsClass.bannerAd!),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
