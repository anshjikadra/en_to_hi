// import 'package:flutter/material.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
//
//
// AdsController adsController = AdsController(
//   bannerId: "ca-app-pub-3940256099942544/6300978111",
//   interstitialId: "ca-app-pub-3940256099942544/1033173712",
//   appOpenId: "ca-app-pub-3940256099942544/3419835294",
// );
//
// AppOpenAd? appOpenAd;
// bool isAppOpenShow = false;
//
// class AdsController {
//   String bannerId;
//   String interstitialId;
//   String appOpenId;
//   AdsController({
//     required this.bannerId,
//     required this.interstitialId,
//     required this.appOpenId,
//   }) {
//     _loadInterstitialAd();
//   }
//   InterstitialAd? _interstitialAd;
//   AppOpenAd? _appOpenAd;
//
//   loadBannerAd({required BannerAdListener listener}) {
//     BannerAd(
//       size: AdSize.banner,
//       adUnitId: bannerId,
//       listener: listener,
//       request: const AdRequest(),
//     ).load();
//   }
//
//   _loadInterstitialAd() {
//     InterstitialAd.load(
//       adUnitId: interstitialId,
//       request: const AdRequest(),
//       adLoadCallback: InterstitialAdLoadCallback(
//         onAdLoaded: (ad) {
//           _interstitialAd = ad;
//         },
//         onAdFailedToLoad: (error) {
//           _interstitialAd = null;
//         },
//       ),
//     );
//   }
//
//   showInterstititalAd(BuildContext context, {Widget? route,bool pop=false}) {
//     if (_interstitialAd != null) {
//       _interstitialAd!.show();
//       _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
//         onAdShowedFullScreenContent: (ad) {
//           _loadInterstitialAd();
//           if (pop) {
//             Navigator.pop(context);
//           }
//           if(route!=null)
//           {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => route,
//               ),
//             );
//           }
//         },
//         onAdFailedToShowFullScreenContent: (ad, error) {
//           _loadInterstitialAd();
//           if (pop) {
//             Navigator.pop(context);
//           } if(route!=null) {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => route,
//               ),
//             );
//           }
//         },
//       );
//     } else {
//       if (route != null) {
//         Navigator.pop(context);
//       } else {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => route!,
//           ),
//         );
//       }
//       _loadInterstitialAd();
//     }
//   }
//
//   loadAppOpenAd() async {
//     await AppOpenAd.load(
//       adUnitId: appOpenId,
//       request: const AdRequest(),
//       adLoadCallback: AppOpenAdLoadCallback(
//         onAdLoaded: (ad) {
//           _appOpenAd = ad;
//           showOpenAd();
//         },
//         onAdFailedToLoad: (ad) {
//           _appOpenAd = null;
//         },
//       ),
//       orientation: 1,
//     );
//   }
//
//   showOpenAd() {
//     if (_appOpenAd != null) {
//       _appOpenAd!.show();
//     }
//   }
// }
//
// class BannerAdWidget extends StatefulWidget {
//   /// This Widget is For display BannerAd Without any mathods
//   const BannerAdWidget({Key? key}) : super(key: key);
//
//   @override
//   State<BannerAdWidget> createState() => _BannerAdWidgetState();
// }
//
// class _BannerAdWidgetState extends State<BannerAdWidget> {
//   BannerAd? _bannerAd;
//
//   @override
//   void initState() {
//     super.initState();
//     adsController.loadBannerAd(
//       listener: _bannerAdlistner(),
//     );
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     if (_bannerAd != null) {
//       _bannerAd!.dispose();
//     }
//   }
//
//   BannerAdListener _bannerAdlistner() {
//     return BannerAdListener(
//       onAdLoaded: (ad) {
//         setState(() {
//           _bannerAd = ad as BannerAd;
//         });
//       },
//       onAdFailedToLoad: (ad, error) {
//         setState(() {
//           _bannerAd = null;
//         });
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (_bannerAd != null) {
//       return SizedBox(
//         height: _bannerAd!.size.height.toDouble(),
//         width: _bannerAd!.size.width.toDouble(),
//         child: AdWidget(ad: _bannerAd!),
//       );
//     } else {
//       return const SizedBox();
//     }
//   }
// }
