import 'dart:math';
import 'package:flutter/material.dart';

/// Widget que muestra una animación tipo "tambor giratorio" durante el sorteo
class SorteoDrumAnimation extends StatefulWidget {
  final List<String> items;
  final bool isAnimating;
  final String? finalResult;

  const SorteoDrumAnimation({
    super.key,
    required this.items,
    required this.isAnimating,
    this.finalResult,
  });

  @override
  State<SorteoDrumAnimation> createState() => _SorteoDrumAnimationState();
}

class _SorteoDrumAnimationState extends State<SorteoDrumAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final Random _random = Random();
  String _currentItem = '';

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    
    _controller.addListener(() {
      if (widget.isAnimating && widget.items.isNotEmpty) {
        setState(() {
          _currentItem = widget.items[_random.nextInt(widget.items.length)];
        });
      }
    });
  }

  @override
  void didUpdateWidget(SorteoDrumAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (widget.isAnimating && !oldWidget.isAnimating) {
      _startAnimation();
    } else if (!widget.isAnimating && oldWidget.isAnimating) {
      _stopAnimation();
    }
  }

  void _startAnimation() {
    _controller.repeat();
  }

  void _stopAnimation() {
    _controller.stop();
    if (widget.finalResult != null) {
      setState(() {
        _currentItem = widget.finalResult!;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isAnimating && widget.finalResult == null) {
      return const SizedBox.shrink();
    }

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 300),
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: child,
        );
      },
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.secondary,
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
              color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
              blurRadius: 30,
              spreadRadius: 5,
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
            // Ícono giratorio grande
            RotationTransition(
              turns: _controller,
              child: const Icon(
                Icons.autorenew,
                color: Colors.white,
                size: 80,
              ),
            ),
            const SizedBox(height: 24),
            
            // Símbolos animados en lugar de números específicos
            if (widget.isAnimating) ...[
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 150),
                transitionBuilder: (child, animation) {
                  return ScaleTransition(
                    scale: animation,
                    child: FadeTransition(
                      opacity: animation,
                      child: child,
                    ),
                  );
                },
                child: Text(
                  '? ? ?',
                  key: ValueKey(_controller.value),
                  style: const TextStyle(
                    fontSize: 56,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 8,
                    shadows: [
                      Shadow(
                        color: Color(0xFF1A1A1A),
                        blurRadius: 10,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'SORTEANDO...',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 3,
                  shadows: [
                    Shadow(
                      color: Color(0xFF1A1A1A),
                      blurRadius: 8,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              const SizedBox(
                width: 200,
                child: LinearProgressIndicator(
                  backgroundColor: Colors.white24,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

