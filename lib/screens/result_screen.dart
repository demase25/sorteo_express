import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../core/routes.dart';
import '../core/theme.dart';
import '../widgets/custom_button.dart';
import '../widgets/result_card.dart';
import '../widgets/animated_background.dart';
import '../widgets/animated_menu_button.dart';
import '../models/history_model.dart';
import '../services/sorteo_service.dart';
import '../services/share_service.dart';
import '../services/effects_service.dart';

class ResultScreen extends StatefulWidget {
  final String winner;
  final List<String> participants;
  final DateTime timestamp;
  final String? tipo;

  const ResultScreen({
    super.key,
    required this.winner,
    required this.participants,
    required this.timestamp,
    this.tipo,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  bool _showResult = false;

  @override
  void initState() {
    super.initState();
    
    // Inicializar efectos especiales
    EffectsService.initialize(this);
    
    _animationController = AnimationController(
      duration: AppConstants.sorteoAnimationDuration,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.5, 1.0),
    ));

    _startAnimation();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _startAnimation() async {
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      _showResult = true;
    });
    _animationController.forward();
    
    // Disparar confetti y vibración cuando aparece el resultado
    await Future.delayed(const Duration(milliseconds: 800));
    await EffectsService.celebrarGanador();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.resultTitle),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _compartirResultado,
          ),
        ],
      ),
      body: AnimatedBackground(
        primaryColor: AppTheme.secondaryColor,
        secondaryColor: AppTheme.accentColor,
        child: Stack(
          children: [
            // Confetti de fondo
            EffectsService.crearConfettiWidget(
              size: MediaQuery.of(context).size,
              alignment: Alignment.topCenter,
            ),
            
            // Confetti con estrellas
            EffectsService.crearConfettiEstrella(
              size: MediaQuery.of(context).size,
              alignment: Alignment.topCenter,
            ),
            
            // Contenido principal
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.defaultPadding),
                child: Column(
                  children: [
                    // Animación del resultado con nuevo diseño
                    Expanded(
                      child: Center(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Icono de trofeo animado
                              AnimatedBuilder(
                                animation: _animationController,
                                builder: (context, child) {
                                  return Transform.scale(
                                    scale: _scaleAnimation.value,
                                    child: Opacity(
                                      opacity: _fadeAnimation.value,
                                      child: Container(
                                        padding: const EdgeInsets.all(20),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: AppTheme.secondaryColor,
                                            width: 4,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: AppTheme.secondaryColor.withOpacity(0.5),
                                              blurRadius: 30,
                                              spreadRadius: 5,
                                            ),
                                          ],
                                        ),
                                        child: const Icon(
                                          Icons.emoji_events,
                                          size: 80,
                                          color: AppTheme.secondaryColor,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 30),
                              
                              // Texto "GANADOR"
                              AnimatedBuilder(
                                animation: _animationController,
                                builder: (context, child) {
                                  return Transform.scale(
                                    scale: _scaleAnimation.value,
                                    child: Opacity(
                                      opacity: _fadeAnimation.value,
                                      child: const Text(
                                        '¡GANADOR!',
                                        style: TextStyle(
                                          fontSize: 36,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          letterSpacing: 4,
                                          shadows: [
                                            Shadow(
                                              color: Color(0xFF1A1A1A),
                                              blurRadius: 10,
                                              offset: Offset(3, 3),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 30),
                              
                              // Número o nombre ganador - SIEMPRE VISIBLE
                              AnimatedBuilder(
                                animation: _animationController,
                                builder: (context, child) {
                                  return Transform.scale(
                                    scale: _scaleAnimation.value,
                                    child: Opacity(
                                      opacity: _fadeAnimation.value,
                                      child: Container(
                                        constraints: const BoxConstraints(
                                          minWidth: 250,
                                          maxWidth: 500,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 40,
                                          vertical: 30,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white, // Blanco sólido
                                          borderRadius: BorderRadius.circular(30),
                                          border: Border.all(
                                            color: const Color(0xFF1A1A1A),
                                            width: 5,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: const Color(0xFF1A1A1A).withOpacity(0.6),
                                              blurRadius: 25,
                                              spreadRadius: 5,
                                              offset: const Offset(0, 8),
                                            ),
                                            BoxShadow(
                                              color: AppTheme.secondaryColor.withOpacity(0.8),
                                              blurRadius: 40,
                                              spreadRadius: -5,
                                            ),
                                          ],
                                        ),
                                        child: Text(
                                          widget.winner,
                                          style: const TextStyle(
                                            fontSize: 56, // GRANDE
                                            fontWeight: FontWeight.w900, // MUY BOLD
                                            color: Color(0xFF1A1A1A), // NEGRO
                                            letterSpacing: 3,
                                            height: 1.2,
                                          ),
                                          textAlign: TextAlign.center,
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                
                    const SizedBox(height: AppConstants.defaultPadding),
                    
                    // Botones de acción con estilo mejorado
                    AnimatedMenuButton(
                      text: AppConstants.guardarButton,
                      icon: Icons.save,
                      onPressed: _guardarSorteo,
                      index: 0,
                      gradientStart: AppTheme.primaryColor,
                      gradientEnd: AppTheme.secondaryColor,
                    ),
                    const SizedBox(height: AppConstants.defaultPadding),
                    
                    Row(
                      children: [
                        Expanded(
                          child: AnimatedMenuButton(
                            text: 'Nuevo',
                            icon: Icons.refresh,
                            onPressed: () => AppRoutes.navigateToHome(context),
                            isSecondary: true,
                            index: 1,
                          ),
                        ),
                        const SizedBox(width: AppConstants.defaultPadding),
                        Expanded(
                          child: AnimatedMenuButton(
                            text: 'Historial',
                            icon: Icons.history,
                            onPressed: () => AppRoutes.navigateToHistory(context),
                            isSecondary: true,
                            index: 2,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppConstants.smallPadding),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _guardarSorteo() async {
    await EffectsService.vibrarBoton();
    
    try {
      HistoryModel historyModel;
      
      if (widget.tipo == 'rifas') {
        historyModel = HistoryModel.fromRifasSorteo(
          winner: widget.winner,
          participants: widget.participants,
        );
      } else if (widget.tipo == 'numeros') {
        historyModel = HistoryModel.fromNumbersSorteo(
          winner: widget.winner,
          participants: widget.participants,
          numbers: widget.participants,
        );
      } else {
        historyModel = HistoryModel.fromNamesSorteo(
          winner: widget.winner,
          participants: widget.participants,
        );
      }

      await SorteoService.guardarSorteo(historyModel);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(AppConstants.successSorteoSaved),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
      }
    } catch (e) {
      await EffectsService.vibrarError();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(AppConstants.errorGeneric),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  void _compartirResultado() async {
    await EffectsService.vibrarBoton();
    await ShareService.mostrarOpcionesCompartir(
      context: context,
      winner: widget.winner,
      participants: widget.participants,
      timestamp: widget.timestamp,
      tipo: widget.tipo ?? 'nombres',
    );
  }
}
