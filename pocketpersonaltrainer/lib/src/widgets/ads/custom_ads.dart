import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:universal_io/io.dart';
import 'dart:io';
import 'package:pocketpersonaltrainer/src/widgets/ads/consent_manager.dart';

class CustomAds extends StatefulWidget {
  const CustomAds({super.key, required this.isSmall});

  final bool isSmall;

  @override
  State<CustomAds> createState() => _CustomAdsState();
}

class _CustomAdsState extends State<CustomAds> {
  final double _adAspectRatioSmall = (91 / 355);
  final double _adAspectRatioMedium = (370 / 355);
  final _consentManager = ConsentManager();
  var _isMobileAdsInitializeCalled = false;
  NativeAd? _nativeAd;
  bool _nativeAdIsLoaded = false;

  final String _adUnitId = Platform.isAndroid ? 'ca-app-pub-3940256099942544/2247696110' : 'ca-app-pub-3940256099942544/3986624511';

  @override
  void initState() {
    super.initState();

    _consentManager.gatherConsent((consentGatheringError) {
      if (consentGatheringError != null) {
        // Consent not obtained in current session.
        debugPrint("${consentGatheringError.errorCode}: ${consentGatheringError.message}");
      }
      // Attempt to initialize the Mobile Ads SDK.
      _initializeMobileAdsSDK();
    });

    // This sample attempts to load ads using consent obtained in the previous session.
    _initializeMobileAdsSDK();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isSmall == false) {
      return SizedBox(
        height: MediaQuery.of(context).size.width * _adAspectRatioMedium,
        width: MediaQuery.of(context).size.width,
        child: _nativeAdIsLoaded && _nativeAd != null
            ? SizedBox(
                height: MediaQuery.of(context).size.width * _adAspectRatioMedium,
                width: MediaQuery.of(context).size.width,
                child: AdWidget(
                  ad: _nativeAd!,
                ),
              )
            : const Center(
                child: CircularProgressIndicator(),
              ),
      );
    }
    return SizedBox(
      height: MediaQuery.of(context).size.width * _adAspectRatioSmall,
      width: MediaQuery.of(context).size.width,
      child: _nativeAdIsLoaded && _nativeAd != null
          ? SizedBox(
              height: MediaQuery.of(context).size.width * _adAspectRatioSmall,
              width: MediaQuery.of(context).size.width,
              child: AdWidget(
                ad: _nativeAd!,
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  void _loadAd() async {
    // Only load an ad if the Mobile Ads SDK has gathered consent aligned with
    // the app's configured messages.
    var canRequestAds = await _consentManager.canRequestAds();
    if (!canRequestAds) {
      return;
    }

    setState(() {
      _nativeAdIsLoaded = false;
    });

    _nativeAd = NativeAd(
        adUnitId: _adUnitId,
        listener: NativeAdListener(
          onAdLoaded: (ad) {
            // ignore: avoid_print
            print('$NativeAd loaded.');
            setState(() {
              _nativeAdIsLoaded = true;
            });
          },
          onAdFailedToLoad: (ad, error) {
            // ignore: avoid_print
            print('$NativeAd failedToLoad: $error');
            ad.dispose();
          },
          onAdClicked: (ad) {},
          onAdImpression: (ad) {},
          onAdClosed: (ad) {},
          onAdOpened: (ad) {},
          onAdWillDismissScreen: (ad) {},
          onPaidEvent: (ad, valueMicros, precision, currencyCode) {},
        ),
        request: const AdRequest(),
        nativeTemplateStyle: NativeTemplateStyle(
            templateType: widget.isSmall ? TemplateType.small : TemplateType.medium,
            mainBackgroundColor: const Color(0xfffffbed),
            callToActionTextStyle: NativeTemplateTextStyle(textColor: Colors.white, style: NativeTemplateFontStyle.monospace, size: 16.0),
            primaryTextStyle: NativeTemplateTextStyle(textColor: Colors.black, style: NativeTemplateFontStyle.bold, size: 16.0),
            secondaryTextStyle: NativeTemplateTextStyle(textColor: Colors.black, style: NativeTemplateFontStyle.italic, size: 16.0),
            tertiaryTextStyle: NativeTemplateTextStyle(textColor: Colors.black, style: NativeTemplateFontStyle.normal, size: 16.0)))
      ..load();
  }

  void _initializeMobileAdsSDK() async {
    if (_isMobileAdsInitializeCalled) {
      return;
    }

    if (await _consentManager.canRequestAds()) {
      _isMobileAdsInitializeCalled = true;

      // Initialize the Mobile Ads SDK.
      MobileAds.instance.initialize();

      // Load an ad.
      _loadAd();
    }
  }

  @override
  void dispose() {
    _nativeAd?.dispose();
    super.dispose();
  }
}
