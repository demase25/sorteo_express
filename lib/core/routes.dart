import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/sorteo_screen.dart';
import '../screens/result_screen.dart';
import '../screens/history_screen.dart';

class AppRoutes {
  // Rutas principales
  static const String home = '/';
  static const String sorteo = '/sorteo';
  static const String result = '/result';
  static const String history = '/history';

  // Generador de rutas
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
          settings: settings,
        );
      
      case sorteo:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => SorteoScreen(
            tipoInicial: args?['tipo'] ?? 'nombres',
          ),
          settings: settings,
        );
      
      case result:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => ResultScreen(
            winner: args?['winner'] ?? '',
            participants: args?['participants'] ?? [],
            timestamp: args?['timestamp'] ?? DateTime.now(),
            tipo: args?['tipo'],
          ),
          settings: settings,
        );
      
      case history:
        return MaterialPageRoute(
          builder: (_) => const HistoryScreen(),
          settings: settings,
        );
      
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Text('Ruta no encontrada'),
            ),
          ),
          settings: settings,
        );
    }
  }

  // Métodos de navegación
  static void navigateToHome(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      home,
      (route) => false,
    );
  }

  static void navigateToSorteo(BuildContext context) {
    Navigator.pushNamed(context, sorteo);
  }

  static void navigateToResult(
    BuildContext context, {
    required String winner,
    required List<String> participants,
    required DateTime timestamp,
    String? tipo,
  }) {
    Navigator.pushNamed(
      context,
      result,
      arguments: {
        'winner': winner,
        'participants': participants,
        'timestamp': timestamp,
        'tipo': tipo,
      },
    );
  }

  static void navigateToHistory(BuildContext context) {
    Navigator.pushNamed(context, history);
  }

  static void goBack(BuildContext context) {
    Navigator.pop(context);
  }
}
