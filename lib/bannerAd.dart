import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';

final BannerAd mainBanner = BannerAd(
  adUnitId: Platform.isAndroid == true
      ? "ca-app-pub-1296851216795797/8865426952"
      : "ca-app-pub-1296851216795797/7439545086",
  size: AdSize.banner,
  request: AdRequest(),
  listener: AdListener(
    onAdOpened: (Ad ad) => print('Ad opened.'),
  ),
);

final BannerAd addCalendarBanner = BannerAd(
  adUnitId: Platform.isAndroid == true
      ? "ca-app-pub-1296851216795797/8865426952"
      : "ca-app-pub-1296851216795797/7439545086",
  size: AdSize.banner,
  request: AdRequest(),
  listener: AdListener(
    onAdOpened: (Ad ad) => print('Ad opened.'),
  ),
);

final BannerAd editCalendarBanner = BannerAd(
  adUnitId: Platform.isAndroid == true
      ? "ca-app-pub-1296851216795797/8865426952"
      : "ca-app-pub-1296851216795797/7439545086",
  size: AdSize.banner,
  request: AdRequest(),
  listener: AdListener(
    onAdOpened: (Ad ad) => print('Ad opened.'),
  ),
);

final BannerAd cubeCheckBanner = BannerAd(
  adUnitId: Platform.isAndroid == true
      ? "ca-app-pub-1296851216795797/8865426952"
      : "ca-app-pub-1296851216795797/7439545086",
  size: AdSize.banner,
  request: AdRequest(),
  listener: AdListener(
    onAdOpened: (Ad ad) => print('Ad opened.'),
  ),
);

final BannerAd addCubeBanner = BannerAd(
  adUnitId: Platform.isAndroid == true
      ? "ca-app-pub-1296851216795797/8865426952"
      : "ca-app-pub-1296851216795797/7439545086",
  size: AdSize.banner,
  request: AdRequest(),
  listener: AdListener(
    onAdOpened: (Ad ad) => print('Ad opened.'),
  ),
);

final BannerAd editCubeBanner = BannerAd(
  adUnitId: Platform.isAndroid == true
      ? "ca-app-pub-1296851216795797/8865426952"
      : "ca-app-pub-1296851216795797/7439545086",
  size: AdSize.banner,
  request: AdRequest(),
  listener: AdListener(
    onAdOpened: (Ad ad) => print('Ad opened.'),
  ),
);
