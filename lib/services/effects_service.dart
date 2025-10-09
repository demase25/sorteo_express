import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:confetti/confetti.dart';

class EffectsService {
  static ConfettiController? _confettiController;

  static void initialize(TickerProvider vsync) {
    // Inicializar solo si no existe
    if (_confettiController == null || _confettiController!.state == null) {
      _confettiController = ConfettiController(duration: const Duration(seconds: 3));
    }
  }

  static Future<void> celebrarGanador() async {
    await _vibrarCelebracion();
    _confettiController?.play();
  }

  static Future<void> _vibrarCelebracion() async {
    try {
      HapticFeedback.mediumImpact();
      await Future.delayed(const Duration(milliseconds: 200));
      HapticFeedback.heavyImpact();
      await Future.delayed(const Duration(milliseconds: 100));
      HapticFeedback.mediumImpact();
    } catch (e) {
      debugPrint('Error en vibración: $e');
    }
  }

  static Future<void> vibrarBoton() async {
    try {
      HapticFeedback.lightImpact();
    } catch (e) {
      debugPrint('Error en vibración de botón: $e');
    }
  }

  static Future<void> vibrarError() async {
    try {
      HapticFeedback.heavyImpact();
    } catch (e) {
      debugPrint('Error en vibración de error: $e');
    }
  }

  static ConfettiController? get confettiController => _confettiController;

  static void dispose() {
    // No hacer dispose aquí, dejar que Flutter lo maneje
  }

  static Widget crearConfettiWidget({
    required Size size,
    Alignment alignment = Alignment.topCenter,
  }) {
    if (_confettiController == null) {
      return const SizedBox.shrink();
    }
    
    return Align(
      alignment: alignment,
      child: ConfettiWidget(
        confettiController: _confettiController!,
        blastDirection: 3.14159 / 2,
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

  static Widget crearConfettiEstrella({
    required Size size,
    Alignment alignment = Alignment.topCenter,
  }) {
    if (_confettiController == null) {
      return const SizedBox.shrink();
    }
    
    return Align(
      alignment: alignment,
      child: ConfettiWidget(
        confettiController: _confettiController!,
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
      ),
    );
  }
}
