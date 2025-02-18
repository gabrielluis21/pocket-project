import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdsMobServices {
  static String? get bannerAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544/3419835294";
    } else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544/3419835294";
    } else {
      return null;
    }
  }

  static String? get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544/3419835294";
    } else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544/3419835294";
    } else {
      return null;
    }
  }

  static String? get rewardAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544/3419835294";
    } else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544/3419835294";
    } else {
      return null;
    }
  }

  static final BannerAdListener bannerAdListener = BannerAdListener(
    onAdLoaded: (ad) => debugPrint("Ad loaded!"),
    onAdFailedToLoad: (ad, err) {
      ad.dispose();
      debugPrint("Ad failed to loaded, because: $err");
    },
    onAdOpened: (ad) => debugPrint("Ad loaded!"),
    onAdClosed: (ad) => debugPrint("Ad loaded!"),
  );
}
