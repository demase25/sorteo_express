import 'package:flutter/material.dart';
import '../core/constants.dart';

class AdsService {
  static bool _isInitialized = false;
  static bool _adsEnabled = true;

  /// Inicializa el servicio de anuncios
  static Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      // Aquí inicializarías AdMob
      // await MobileAds.instance.initialize();
      
      _isInitialized = true;
      debugPrint('AdsService inicializado correctamente');
    } catch (e) {
      debugPrint('Error al inicializar AdsService: $e');
      _adsEnabled = false;
    }
  }

  /// Verifica si los anuncios están habilitados
  static bool get adsEnabled => _adsEnabled && _isInitialized;

  /// Habilita o deshabilita los anuncios
  static void setAdsEnabled(bool enabled) {
    _adsEnabled = enabled;
  }

  /// Muestra un anuncio intersticial
  static Future<void> showInterstitialAd() async {
    if (!adsEnabled) return;
    
    try {
      // Aquí cargarías y mostrarías el anuncio intersticial
      // final interstitialAd = await InterstitialAd.load(
      //   adUnitId: AppConstants.admobInterstitialId,
      //   request: const AdRequest(),
      //   adLoadCallback: InterstitialAdLoadCallback(
      //     onAdLoaded: (ad) {
      //       ad.show();
      //     },
      //     onAdFailedToLoad: (error) {
      //       debugPrint('Error al cargar anuncio intersticial: $error');
      //     },
      //   ),
      // );
      
      debugPrint('Anuncio intersticial mostrado');
    } catch (e) {
      debugPrint('Error al mostrar anuncio intersticial: $e');
    }
  }

  /// Carga un anuncio intersticial para mostrar después
  static Future<void> loadInterstitialAd() async {
    if (!adsEnabled) return;
    
    try {
      // Aquí precargarías el anuncio intersticial
      debugPrint('Anuncio intersticial cargado');
    } catch (e) {
      debugPrint('Error al cargar anuncio intersticial: $e');
    }
  }

  /// Muestra un anuncio de recompensa
  static Future<bool> showRewardedAd() async {
    if (!adsEnabled) return false;
    
    try {
      // Aquí cargarías y mostrarías el anuncio de recompensa
      // final rewardedAd = await RewardedAd.load(
      //   adUnitId: AppConstants.admobRewardedId,
      //   request: const AdRequest(),
      //   rewardedAdLoadCallback: RewardedAdLoadCallback(
      //     onAdLoaded: (ad) {
      //       ad.show(onUserEarnedReward: (ad, reward) {
      //         debugPrint('Usuario ganó recompensa: ${reward.amount} ${reward.type}');
      //       });
      //     },
      //     onAdFailedToLoad: (error) {
      //       debugPrint('Error al cargar anuncio de recompensa: $error');
      //     },
      //   ),
      // );
      
      debugPrint('Anuncio de recompensa mostrado');
      return true;
    } catch (e) {
      debugPrint('Error al mostrar anuncio de recompensa: $e');
      return false;
    }
  }

  /// Widget para mostrar banner de anuncios
  static Widget createBannerAd() {
    if (!adsEnabled) {
      return const SizedBox.shrink();
    }
    
    return Container(
      height: 50,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: const Center(
        child: Text(
          'Anuncio',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
      ),
    );
    
    // Código real para AdMob Banner:
    // return BannerAd(
    //   adUnitId: AppConstants.admobBannerId,
    //   size: AdSize.banner,
    //   request: const AdRequest(),
    // );
  }

  /// Widget para mostrar banner de anuncios adaptativo
  static Widget createAdaptiveBannerAd() {
    if (!adsEnabled) {
      return const SizedBox.shrink();
    }
    
    return Container(
      height: 100,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: const Center(
        child: Text(
          'Anuncio Adaptativo',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
      ),
    );
    
    // Código real para AdMob Adaptive Banner:
    // return AdaptiveBannerAd(
    //   adUnitId: AppConstants.admobBannerId,
    //   size: AdSize.adaptiveBanner,
    //   request: const AdRequest(),
    // );
  }

  /// Muestra anuncio después de completar un sorteo
  static Future<void> showAdAfterSorteo() async {
    if (!adsEnabled) return;
    
    // Mostrar anuncio intersticial después de un sorteo
    await Future.delayed(const Duration(milliseconds: 500));
    await showInterstitialAd();
  }

  /// Muestra anuncio al abrir el historial
  static Future<void> showAdOnHistoryOpen() async {
    if (!adsEnabled) return;
    
    // Mostrar anuncio cuando se abre el historial
    await Future.delayed(const Duration(milliseconds: 300));
    await showInterstitialAd();
  }

  /// Configuración de anuncios para diferentes momentos
  static Future<void> configureAdsForUser() async {
    if (!adsEnabled) return;
    
    try {
      // Aquí podrías implementar lógica para mostrar anuncios
      // basados en el comportamiento del usuario
      
      debugPrint('Anuncios configurados para el usuario');
    } catch (e) {
      debugPrint('Error al configurar anuncios: $e');
    }
  }

  /// Obtiene información sobre el estado de los anuncios
  static Map<String, dynamic> getAdsInfo() {
    return {
      'initialized': _isInitialized,
      'enabled': _adsEnabled,
      'bannerId': AppConstants.admobBannerId,
      'interstitialId': AppConstants.admobInterstitialId,
    };
  }
}
