import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:quran_app/ads/banner_ads_class.dart';
import 'package:quran_app/ads/inter_ads_class.dart';
import 'package:quran_app/provider/quran_csv_provider.dart';
import 'package:quran_app/provider/theme_color_provider.dart';
import 'package:quran_app/read_quran_page/quran_bookmark_widget.dart';
import 'package:quran_app/read_quran_page/quran_list_widget.dart';

import 'package:quran_app/util/appbar_system_style.dart';
import 'package:quran_app/util/value_notifier.dart';

class QuranList extends StatefulWidget {
  const QuranList({
    super.key,
  });

  @override
  State<QuranList> createState() => _QuranListState();
}

class _QuranListState extends State<QuranList> {
  void preloadImages(BuildContext context) {
    precacheImage(AssetImage("assets/images/star.png"), context);
  }

  final BannerAdsClass _bannerAdsClass = BannerAdsClass();

  @override
  void initState() {
    super.initState();
    //ADS
    _admobAds();
  }

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

  @override
  Widget build(BuildContext context) {
    final themeColorProvider = Provider.of<ThemeColor>(context);
    final quranCsv = Provider.of<QuranCsv>(context);
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        quranCsv.initTrans();
      },
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: AppbarSystemStyle().appbarSystemStyle(context),
        child: ValueListenableBuilder(
          valueListenable: quranListSwitch,
          builder: (context, navIndexValue, child) => Scaffold(
            backgroundColor: themeColorProvider.secondary,
            body: SafeArea(
              child: Center(
                child: Stack(
                  children: [
                    SizedBox(
                      child: IndexedStack(
                        index: navIndexValue,
                        children: [
                          //Show Quran if index=0
                          if (quranCsv.listOfSurahs.isNotEmpty)
                            QuranListWidget(),
                          //Show Bookmark if index=1
                          QuranBookmarkWidget(),
                        ],
                      ),
                    ),

                    //  Show Banner Only If Loaded
                    if (_bannerAdsClass.bannerAd != null)
                      Positioned(
                        right: 0,
                        left: 0,
                        bottom: 5,
                        child: Container(
                          alignment: Alignment.center,
                          width:
                              _bannerAdsClass.bannerAd!.size.width.toDouble(),
                          height:
                              _bannerAdsClass.bannerAd!.size.height.toDouble(),
                          child: AdWidget(ad: _bannerAdsClass.bannerAd!),
                        ),
                      ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              //backgroundColor: themeColorProvider.background,
              currentIndex: navIndexValue,
              onTap: (value) => quranListSwitch.value = value,
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(Icons.menu_book), label: "Read Qur'an"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.bookmark), label: "Bookmarks"),
              ],
            ),
          ),
        ));
  }
}
