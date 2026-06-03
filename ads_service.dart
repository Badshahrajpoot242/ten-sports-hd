// lib/services/ads_service.dart
/// Ads Service - AdMob Ready Structure
/// 
/// HOW TO ACTIVATE ADS:
/// 1. Uncomment google_mobile_ads in pubspec.yaml
/// 2. Add your AdMob App ID in AndroidManifest.xml
/// 3. Uncomment the imports and implementations below
/// 4. Replace TEST IDs with your real AdMob unit IDs

// import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdsService {
  static final AdsService _instance = AdsService._internal();
  factory AdsService() => _instance;
  AdsService._internal();

  // ── AdMob Unit IDs (Replace with real IDs) ────────────────
  static const String _bannerAdUnitId =
      'ca-app-pub-3940256099942544/6300978111'; // Test ID
  static const String _interstitialAdUnitId =
      'ca-app-pub-3940256099942544/1033173712'; // Test ID
  static const String _rewardedAdUnitId =
      'ca-app-pub-3940256099942544/5224354917'; // Test ID

  // BannerAd? _bannerAd;
  // InterstitialAd? _interstitialAd;
  // RewardedAd? _rewardedAd;

  bool _isInitialized = false;

  // ── Initialize ────────────────────────────────────────────
  Future<void> initialize() async {
    if (_isInitialized) return;
    // await MobileAds.instance.initialize();
    _isInitialized = true;
  }

  // ── Banner Ad ─────────────────────────────────────────────
  Future<void> loadBannerAd({Function? onLoaded}) async {
    // _bannerAd = BannerAd(
    //   adUnitId: _bannerAdUnitId,
    //   size: AdSize.banner,
    //   request: const AdRequest(),
    //   listener: BannerAdListener(
    //     onAdLoaded: (ad) => onLoaded?.call(),
    //     onAdFailedToLoad: (ad, error) => ad.dispose(),
    //   ),
    // );
    // await _bannerAd!.load();
  }

  // BannerAd? get bannerAd => _bannerAd;

  // ── Interstitial Ad ───────────────────────────────────────
  Future<void> loadInterstitialAd() async {
    // await InterstitialAd.load(
    //   adUnitId: _interstitialAdUnitId,
    //   request: const AdRequest(),
    //   adLoadCallback: InterstitialAdLoadCallback(
    //     onAdLoaded: (ad) => _interstitialAd = ad,
    //     onAdFailedToLoad: (error) => _interstitialAd = null,
    //   ),
    // );
  }

  void showInterstitialAd() {
    // _interstitialAd?.show();
    // _interstitialAd = null;
    // loadInterstitialAd(); // Preload next
  }

  // ── Rewarded Ad ───────────────────────────────────────────
  Future<void> loadRewardedAd() async {
    // await RewardedAd.load(
    //   adUnitId: _rewardedAdUnitId,
    //   request: const AdRequest(),
    //   rewardedAdLoadCallback: RewardedAdLoadCallback(
    //     onAdLoaded: (ad) => _rewardedAd = ad,
    //     onAdFailedToLoad: (error) => _rewardedAd = null,
    //   ),
    // );
  }

  void showRewardedAd({Function(int amount)? onReward}) {
    // _rewardedAd?.show(
    //   onUserEarnedReward: (ad, reward) => onReward?.call(reward.amount.toInt()),
    // );
    // _rewardedAd = null;
    // loadRewardedAd();
  }

  void dispose() {
    // _bannerAd?.dispose();
    // _interstitialAd?.dispose();
    // _rewardedAd?.dispose();
  }
}
