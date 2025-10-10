import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../core/routes.dart';
import '../widgets/custom_button.dart';
import '../widgets/result_card.dart';
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
      body: Stack(
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
          Padding(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: Column(
              children: [
                // Animación del resultado
                Expanded(
                  child: Center(
                    child: AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _scaleAnimation.value,
                          child: Opacity(
                            opacity: _fadeAnimation.value,
                            child: ResultCard(
                              winner: widget.winner,
                              participants: widget.participants,
                              timestamp: widget.timestamp,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
            
                // Botones de acción
                Column(
                  children: [
                    CustomButton(
                      text: AppConstants.guardarButton,
                      icon: Icons.save,
                      onPressed: _guardarSorteo,
                    ),
                    const SizedBox(height: AppConstants.smallPadding),
                    
                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            text: 'Nuevo',
                            icon: Icons.refresh,
                            onPressed: () => AppRoutes.navigateToHome(context),
                            isSecondary: true,
                          ),
                        ),
                        const SizedBox(width: AppConstants.smallPadding),
                        Expanded(
                          child: CustomButton(
                            text: 'Historial',
                            icon: Icons.history,
                            onPressed: () => AppRoutes.navigateToHistory(context),
                            isSecondary: true,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
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
