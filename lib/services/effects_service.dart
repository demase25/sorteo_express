import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:confetti/confetti.dart';

class EffectsService {
  /// Controlador de confetti
  static late ConfettiController _confettiController;

  /// Inicializa el servicio de efectos
  static void initialize(TickerProvider vsync) {
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
  }

  /// Dispara confetti y vibración cuando hay un ganador
  static Future<void> celebrarGanador() async {
    // Vibración de celebración
    await _vibrarCelebracion();
    
    // Disparar confetti
    _confettiController.play();
  }

  /// Vibración de celebración
  static Future<void> _vibrarCelebracion() async {
    try {
      // Patrón de vibración: corto-largo-corto (como aplausos)
      HapticFeedback.mediumImpact();
      await Future.delayed(const Duration(milliseconds: 200));
      HapticFeedback.heavyImpact();
      await Future.delayed(const Duration(milliseconds: 100));
      HapticFeedback.mediumImpact();
    } catch (e) {
      // Si falla la vibración, no es crítico
      debugPrint('Error en vibración: $e');
    }
  }

  /// Vibración suave para botones
  static Future<void> vibrarBoton() async {
    try {
      HapticFeedback.lightImpact();
    } catch (e) {
      debugPrint('Error en vibración de botón: $e');
    }
  }

  /// Vibración de error
  static Future<void> vibrarError() async {
    try {
      HapticFeedback.heavyImpact();
    } catch (e) {
      debugPrint('Error en vibración de error: $e');
    }
  }

  /// Obtiene el controlador de confetti
  static ConfettiController get confettiController => _confettiController;

  /// Libera recursos
  static void dispose() {
    _confettiController.dispose();
  }

  /// Widget de confetti con colores vibrantes
  static Widget crearConfettiWidget({
    required Size size,
    Alignment alignment = Alignment.topCenter,
  }) {
    return Align(
      alignment: alignment,
      child: ConfettiWidget(
        confettiController: _confettiController,
        blastDirection: 3.14159 / 2, // Hacia abajo
        maxBlastForce: 20,
        minBlastForce: 5,
        emissionFrequency: 0.05,
        numberOfParticles: 50,
        gravity: 0.3,
        colors: const [
          Colors.red,
          Colors.blue,
          Colors.green,
          Colors.yellow,
          Colors.pink,
          Colors.orange,
          Colors.purple,
          Colors.cyan,
          Colors.lime,
          Colors.indigo,
        ],
      ),
    );
  }

  /// Widget de confetti con forma de estrella
  static Widget crearConfettiEstrella({
    required Size size,
    Alignment alignment = Alignment.topCenter,
  }) {
    return Align(
      alignment: alignment,
      child: ConfettiWidget(
        confettiController: _confettiController,
        blastDirection: 3.14159 / 2,
        maxBlastForce: 25,
        minBlastForce: 8,
        emissionFrequency: 0.03,
        numberOfParticles: 30,
        gravity: 0.2,
        colors: const [
          Colors.amber,
          Colors.deepOrange,
          Colors.deepPurple,
          Colors.teal,
          Colors.redAccent,
          Colors.blueAccent,
          Colors.greenAccent,
          Colors.purpleAccent,
        ],
        createParticlePath: (size) {
          return _createStarPath(size);
        },
      ),
    );
  }

  /// Crea el path de una estrella para el confetti
  static Path _createStarPath(Size size) {
    final path = Path();
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    
    // Crear estrella de 5 puntas
    for (int i = 0; i < 5; i++) {
      final angle = (i * 2 * 3.14159 / 5) - (3.14159 / 2);
      final x = center.dx + radius * cos(angle);
      final y = center.dy + radius * sin(angle);
      
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    
    path.close();
    return path;
  }
}

