import 'dart:ui';

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:quran_app/util/app_info.dart';

class BannerAdsClass {
  //int banner
  BannerAd? _bannerAd;
  //Banner Ads Unit
  final String bannerAdsUnit = isAndroid
      ? "ca-app-pub-4416029850245700/1391636931"
      : "ca-app-pub-4416029850245700/6735995749";

  BannerAd? get bannerAd => _bannerAd;

  void loadBanner({required VoidCallback onAdLoaded}) {
    BannerAd(
      adUnitId: bannerAdsUnit,
      request: AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          _bannerAd = ad as BannerAd; //  Assign only after loading finishes
          onAdLoaded(); //  Trigger UI rebuild
        },
        onAdFailedToLoad: (ad, err) {
          // Called when an ad request failed.
          ad.dispose();
        },
      ),
    ).load();
  }
}
