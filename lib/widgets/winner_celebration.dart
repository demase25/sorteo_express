import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';

/// Widget de celebración del ganador con partículas y efectos
class WinnerCelebration extends StatefulWidget {
  final String winner;
  final bool isAnimating;

  const WinnerCelebration({
    super.key,
    required this.winner,
    this.isAnimating = true,
  });

  @override
  State<WinnerCelebration> createState() => _WinnerCelebrationState();
}

class _WinnerCelebrationState extends State<WinnerCelebration>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));

    _rotateAnimation = Tween<double>(
      begin: -0.2,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    ));

    _glowAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));

    if (widget.isAnimating) {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Transform.rotate(
            angle: _rotateAnimation.value,
            child: Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.secondary,
                    Theme.of(context).colorScheme.tertiary,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: const Color(0xFF1A1A1A),
                  width: 4,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context)
                        .colorScheme
                        .secondary
                        .withOpacity(0.3 + _glowAnimation.value * 0.4),
                    blurRadius: 20 + _glowAnimation.value * 30,
                    spreadRadius: 5 + _glowAnimation.value * 10,
                  ),
                  const BoxShadow(
                    color: Color(0xFF1A1A1A),
                    blurRadius: 15,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Icono de trofeo
                  Icon(
                    Icons.emoji_events,
                    size: 60,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: const Color(0xFF1A1A1A).withOpacity(0.5),
                        blurRadius: 10,
                        offset: const Offset(2, 2),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  
                  // Texto "GANADOR"
                  Text(
                    '¡GANADOR!',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 2,
                      shadows: [
                        Shadow(
                          color: const Color(0xFF1A1A1A).withOpacity(0.5),
                          blurRadius: 8,
                          offset: const Offset(2, 2),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Nombre del ganador
                  Container(
                    constraints: const BoxConstraints(
                      minWidth: 200,
                      maxWidth: 400,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 24,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white, // Blanco sólido 100%
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: const Color(0xFF1A1A1A),
                        width: 4, // Borde más grueso
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF1A1A1A).withOpacity(0.5),
                          blurRadius: 20,
                          spreadRadius: 3,
                          offset: const Offset(0, 6),
                        ),
                        const BoxShadow(
                          color: Color(0xFFFFD700), // Sombra dorada
                          blurRadius: 30,
                          spreadRadius: -5,
                        ),
                      ],
                    ),
                    child: Text(
                      widget.winner,
                      style: const TextStyle(
                        fontSize: 48, // Aumentado para mayor visibilidad
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1A1A), // Negro oscuro para máximo contraste
                        letterSpacing: 2,
                        height: 1.2,
                        shadows: [
                          Shadow(
                            color: Color(0xFFFFD700), // Sombra dorada para efecto
                            blurRadius: 12,
                            offset: Offset(0, 0),
                          ),
                          Shadow(
                            color: Color(0xFF1A1A1A),
                            blurRadius: 4,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Sistema de partículas flotantes para celebración
class CelebrationParticle {
  double x;
  double y;
  double vx;
  double vy;
  double size;
  Color color;
  double alpha;
  double rotation;
  double rotationSpeed;

  CelebrationParticle({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.size,
    required this.color,
    this.alpha = 1.0,
    this.rotation = 0.0,
    this.rotationSpeed = 0.0,
  });
}

/// Widget que renderiza partículas de celebración
class CelebrationParticlesWidget extends StatefulWidget {
  const CelebrationParticlesWidget({super.key});

  @override
  State<CelebrationParticlesWidget> createState() =>
      _CelebrationParticlesWidgetState();
}

class _CelebrationParticlesWidgetState
    extends State<CelebrationParticlesWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<CelebrationParticle> _particles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 60),
      vsync: this,
    );

    _initializeParticles();
    _controller.addListener(_updateParticles);
    _controller.repeat();
  }

  void _initializeParticles() {
    for (int i = 0; i < 30; i++) {
      _particles.add(_createParticle());
    }
  }

  CelebrationParticle _createParticle() {
    final colors = [
      const Color(0xFF00CED1),
      const Color(0xFFFFD700),
      const Color(0xFFFF4444),
    ];

    return CelebrationParticle(
      x: _random.nextDouble(),
      y: _random.nextDouble(),
      vx: (_random.nextDouble() - 0.5) * 0.0005,
      vy: -0.001 - _random.nextDouble() * 0.001,
      size: 4 + _random.nextDouble() * 8,
      color: colors[_random.nextInt(colors.length)],
      rotation: _random.nextDouble() * 3.14 * 2,
      rotationSpeed: (_random.nextDouble() - 0.5) * 0.1,
    );
  }

  void _updateParticles() {
    setState(() {
      for (var particle in _particles) {
        particle.x += particle.vx;
        particle.y += particle.vy;
        particle.rotation += particle.rotationSpeed;

        // Si la partícula sale de la pantalla, reposicionar
        if (particle.y < -0.1) {
          particle.y = 1.1;
          particle.x = _random.nextDouble();
        }
        if (particle.x < -0.1 || particle.x > 1.1) {
          particle.x = _random.nextDouble();
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _CelebrationParticlesPainter(_particles),
      child: Container(),
    );
  }
}

class _CelebrationParticlesPainter extends CustomPainter {
  final List<CelebrationParticle> particles;

  _CelebrationParticlesPainter(this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      final paint = Paint()
        ..color = particle.color.withOpacity(particle.alpha)
        ..style = PaintingStyle.fill;

      final x = particle.x * size.width;
      final y = particle.y * size.height;

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(particle.rotation);

      // Dibujar estrella
      final path = Path();
      for (int i = 0; i < 5; i++) {
        final angle = (i * 4 * pi / 5) - pi / 2;
        final radius = particle.size;
        final px = cos(angle) * radius;
        final py = sin(angle) * radius;

        if (i == 0) {
          path.moveTo(px, py);
        } else {
          path.lineTo(px, py);
        }
      }
      path.close();

      canvas.drawPath(path, paint);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_CelebrationParticlesPainter oldDelegate) => true;
}

