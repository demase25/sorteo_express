import 'package:flutter/material.dart';
import '../services/effects_service.dart';

/// Botón de menú con animaciones de entrada y efectos hover
class AnimatedMenuButton extends StatefulWidget {
  final String text;
  final IconData icon;
  final VoidCallback onPressed;
  final bool isSecondary;
  final int index;
  final Color? gradientStart;
  final Color? gradientEnd;

  const AnimatedMenuButton({
    super.key,
    required this.text,
    required this.icon,
    required this.onPressed,
    this.isSecondary = false,
    this.index = 0,
    this.gradientStart,
    this.gradientEnd,
  });

  @override
  State<AnimatedMenuButton> createState() => _AnimatedMenuButtonState();
}

class _AnimatedMenuButtonState extends State<AnimatedMenuButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));

    _slideAnimation = Tween<double>(
      begin: 50.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));

    // Delay basado en el índice para efecto cascada
    Future.delayed(Duration(milliseconds: 100 + (widget.index * 100)), () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Transform.translate(
            offset: Offset(0, _slideAnimation.value),
            child: Transform.scale(
              scale: _scaleAnimation.value * (_isPressed ? 0.95 : 1.0),
              child: MouseRegion(
                onEnter: (_) => setState(() => _isHovered = true),
                onExit: (_) => setState(() => _isHovered = false),
                child: GestureDetector(
                  onTapDown: _handleTapDown,
                  onTapUp: _handleTapUp,
                  onTapCancel: _handleTapCancel,
                  onTap: () async {
                    await EffectsService.vibrarBoton();
                    widget.onPressed();
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: widget.isSecondary
                          ? null
                          : LinearGradient(
                              colors: [
                                widget.gradientStart ??
                                    Theme.of(context).colorScheme.primary,
                                widget.gradientEnd ??
                                    Theme.of(context).colorScheme.secondary,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                      color: widget.isSecondary
                          ? Theme.of(context).colorScheme.surfaceContainerHighest
                          : null,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: widget.isSecondary
                            ? Theme.of(context).colorScheme.primary.withOpacity(0.5)
                            : const Color(0xFF1A1A1A),
                        width: widget.isSecondary ? 2 : 3,
                      ),
                      boxShadow: [
                        if (!widget.isSecondary) ...[
                          BoxShadow(
                            color: (widget.gradientStart ??
                                    Theme.of(context).colorScheme.primary)
                                .withOpacity(_isHovered ? 0.5 : 0.3),
                            blurRadius: _isHovered ? 20 : 12,
                            spreadRadius: _isHovered ? 2 : 0,
                            offset: const Offset(0, 4),
                          ),
                        ],
                        BoxShadow(
                          color: const Color(0xFF1A1A1A).withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            widget.icon,
                            color: widget.isSecondary
                                ? Theme.of(context).colorScheme.primary
                                : Colors.white,
                            size: 28,
                          ),
                          const SizedBox(width: 12),
                          Flexible(
                            child: Text(
                              widget.text,
                              style: TextStyle(
                                color: widget.isSecondary
                                    ? Theme.of(context).colorScheme.onSurface
                                    : Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                shadows: widget.isSecondary
                                    ? null
                                    : [
                                        const Shadow(
                                          color: Color(0xFF1A1A1A),
                                          blurRadius: 4,
                                          offset: Offset(1, 1),
                                        ),
                                      ],
                              ),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

