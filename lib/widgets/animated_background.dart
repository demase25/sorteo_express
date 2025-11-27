import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';

/// Particula flotante animada
class FloatingParticle extends PositionComponent with HasGameReference<AnimatedBackgroundGame> {
  final Color color;
  final double speed;
  final double amplitude;
  final Random _random = Random();
  double _time = 0;
  final double _offset;

  FloatingParticle({
    required this.color,
    required Vector2 position,
    required this.speed,
    required this.amplitude,
  }) : _offset = Random().nextDouble() * 2 * pi {
    this.position = position;
  }

  @override
  void update(double dt) {
    super.update(dt);
    _time += dt * speed;
    
    // Movimiento sinusoidal horizontal
    position.x += sin(_time + _offset) * amplitude * dt;
    
    // Movimiento ascendente
    position.y -= 20 * dt;
    
    // Reiniciar cuando sale de la pantalla
    if (position.y < -20 && game.size.y > 0) {
      position.y = game.size.y + 20;
      position.x = _random.nextDouble() * game.size.x;
    }
  }

  @override
  void render(Canvas canvas) {
    canvas.drawCircle(
      Offset.zero,
      3 + sin(_time) * 1.5,
      Paint()
        ..color = color.withOpacity(0.3 + sin(_time) * 0.2)
        ..style = PaintingStyle.fill,
    );
  }
}

/// Estrella brillante animada
class SparkleParticle extends PositionComponent {
  final Color color;
  final double rotationSpeed;
  double _rotation = 0;
  double _opacity = 1.0;
  bool _fadingOut = false;
  double _scale = 1.0;

  SparkleParticle({
    required this.color,
    required Vector2 position,
    required this.rotationSpeed,
  }) {
    this.position = position;
  }

  @override
  void update(double dt) {
    super.update(dt);
    _rotation += rotationSpeed * dt;
    
    if (_fadingOut) {
      _opacity -= dt * 2;
      _scale += dt * 2;
      if (_opacity <= 0) {
        removeFromParent();
      }
    } else {
      _opacity = 0.6 + sin(_rotation * 2) * 0.4;
      _scale = 1.0 + sin(_rotation * 3) * 0.2;
    }
  }

  @override
  void render(Canvas canvas) {
    canvas.save();
    canvas.rotate(_rotation);
    canvas.scale(_scale);
    
    final paint = Paint()
      ..color = color.withOpacity(_opacity)
      ..style = PaintingStyle.fill;
    
    // Dibujar estrella de 4 puntas
    final path = Path()
      ..moveTo(0, -6)
      ..lineTo(1, -1)
      ..lineTo(6, 0)
      ..lineTo(1, 1)
      ..lineTo(0, 6)
      ..lineTo(-1, 1)
      ..lineTo(-6, 0)
      ..lineTo(-1, -1)
      ..close();
    
    canvas.drawPath(path, paint);
    canvas.restore();
  }

  void fadeOut() {
    _fadingOut = true;
  }
}

/// Game de fondo animado
class AnimatedBackgroundGame extends FlameGame {
  final Color primaryColor;
  final Color secondaryColor;
  
  AnimatedBackgroundGame({
    required this.primaryColor,
    required this.secondaryColor,
  });

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    // Agregar partículas flotantes
    final random = Random();
    for (int i = 0; i < 20; i++) {
      add(FloatingParticle(
        color: i % 2 == 0 ? primaryColor : secondaryColor,
        position: Vector2(
          random.nextDouble() * size.x,
          random.nextDouble() * size.y,
        ),
        speed: 0.5 + random.nextDouble() * 1.5,
        amplitude: 10 + random.nextDouble() * 20,
      ));
    }
  }

  void addSparkles(Offset position) {
    final random = Random();
    for (int i = 0; i < 5; i++) {
      add(SparkleParticle(
        color: i % 2 == 0 ? primaryColor : secondaryColor,
        position: Vector2(
          position.dx + (random.nextDouble() - 0.5) * 50,
          position.dy + (random.nextDouble() - 0.5) * 50,
        ),
        rotationSpeed: 2 + random.nextDouble() * 4,
      ));
    }
  }
}

/// Widget de fondo animado
class AnimatedBackground extends StatefulWidget {
  final Widget child;
  final Color primaryColor;
  final Color secondaryColor;

  const AnimatedBackground({
    super.key,
    required this.child,
    required this.primaryColor,
    required this.secondaryColor,
  });

  @override
  State<AnimatedBackground> createState() => AnimatedBackgroundState();
}

class AnimatedBackgroundState extends State<AnimatedBackground> {
  late AnimatedBackgroundGame _game;

  @override
  void initState() {
    super.initState();
    _game = AnimatedBackgroundGame(
      primaryColor: widget.primaryColor,
      secondaryColor: widget.secondaryColor,
    );
  }

  void addSparkles(Offset position) {
    _game.addSparkles(position);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: GameWidget(game: _game),
        ),
        widget.child,
      ],
    );
  }
}

