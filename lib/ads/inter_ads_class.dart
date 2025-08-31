import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:quran_app/util/app_info.dart';

class InterstitialAdmob {
  static final InterstitialAdmob _instance = InterstitialAdmob._internal();
  factory InterstitialAdmob() => _instance;
  InterstitialAdmob._internal();

  InterstitialAd? _interstitialAd;

  String adUnitIdI = isAndroid
      ? 'ca-app-pub-4416029850245700/7378094549'
      : 'ca-app-pub-4416029850245700/5586565604';

  void loadAdInterstitial() {
    InterstitialAd.load(
        adUnitId: adUnitIdI,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          // Called when an ad is successfully received.
          onAdLoaded: (ad) {
            // debugPrint('$ad loaded.');
            // Keep a reference to the ad so you can show it later.
            _interstitialAd = ad;
          },
          // Called when an ad request failed.
          onAdFailedToLoad: (LoadAdError error) {
            // debugPrint('InterstitialAd failed to load: $error');
            _interstitialAd = null;
          },
        ));
  }

  void showInterstitial() {
    if (_interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          loadAdInterstitial();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
        },
      );
      _interstitialAd!.show();
      _interstitialAd = null;
    }
  }
}
