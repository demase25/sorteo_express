class AppConstants {
  // Información de la app
  static const String appName = 'Sorteo Express';
  static const String appVersion = '1.0.0';
  
  // Strings de la interfaz
  static const String homeTitle = 'Sorteo Express';
  static const String homeSubtitle = 'Tu sorteo, en un toque.';
  static const String sorteoTitle = 'Crear Sorteo';
  static const String resultTitle = 'Resultado';
  static const String historyTitle = 'Historial';
  
  // Mensajes
  static const String enterParticipants = 'Ingresa los participantes';
  static const String enterNumbers = 'Ingresa los números';
  static const String enterRifas = 'Ingresa los números de rifa';
  static const String sortearButton = 'Sortear';
  static const String nuevoSorteoButton = 'Nuevo Sorteo';
  static const String verHistorialButton = 'Ver Historial';
  static const String guardarButton = 'Guardar';
  static const String compartirButton = 'Compartir';
  static const String eliminarButton = 'Eliminar';
  
  // Mensajes de error
  static const String errorEmptyParticipants = 'Debes ingresar al menos un participante';
  static const String errorEmptyNumbers = 'Debes ingresar al menos un número';
  static const String errorEmptyRifas = 'Debes ingresar al menos un número de rifa';
  static const String errorInvalidNumber = 'Número inválido';
  static const String errorInvalidRifaFormat = 'Formato inválido. Usa: Número - Nombre';
  static const String errorGeneric = 'Ha ocurrido un error';
  
  // Mensajes de éxito
  static const String successSorteoSaved = 'Sorteo guardado exitosamente';
  static const String successSorteoDeleted = 'Sorteo eliminado exitosamente';
  
  // Configuración de UI
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double borderRadius = 12.0;
  static const double buttonHeight = 56.0;
  
  // Límites
  static const int maxParticipants = 100;
  static const int maxNumbers = 1000;
  static const int minParticipants = 2;
  static const int minNumbers = 1;
  
  // Configuración de AdMob
  static const String admobAppId = 'ca-app-pub-3940256099942544~3347511713'; // ID de prueba
  static const String admobBannerId = 'ca-app-pub-3940256099942544/6300978111'; // Banner de prueba
  static const String admobInterstitialId = 'ca-app-pub-3940256099942544/1033173712'; // Interstitial de prueba
  
  // Configuración de almacenamiento
  static const String storageKey = 'sorteo_express_data';
  static const String historyKey = 'sorteo_history';
  
  // Configuración de animaciones
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration sorteoAnimationDuration = Duration(milliseconds: 2000);
}
