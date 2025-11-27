import 'package:flutter/material.dart';
import 'dart:math';
import '../core/constants.dart';
import '../core/routes.dart';
import '../widgets/input_field.dart';
import '../widgets/animated_background.dart';
import '../widgets/sorteo_drum_animation.dart';
import '../widgets/pulse_animation_button.dart';
import '../widgets/animated_card.dart';
import '../services/sorteo_service.dart';
import '../services/effects_service.dart';

class SorteoScreen extends StatefulWidget {
  final String tipoInicial;
  
  const SorteoScreen({
    super.key,
    this.tipoInicial = 'nombres',
  });

  @override
  State<SorteoScreen> createState() => _SorteoScreenState();
}

class _SorteoScreenState extends State<SorteoScreen> with TickerProviderStateMixin {
  final TextEditingController _participantsController = TextEditingController();
  final TextEditingController _numbersController = TextEditingController();
  final TextEditingController _minNumberController = TextEditingController();
  final TextEditingController _maxNumberController = TextEditingController();
  final TextEditingController _rifasController = TextEditingController();
  late String _sorteoType;
  bool _isLoading = false;
  bool _useRange = true; // Por defecto usar rango
  bool _showDrumAnimation = false;
  List<String> _animationItems = [];
  final GlobalKey<AnimatedBackgroundState> _backgroundKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _sorteoType = widget.tipoInicial;
    // Valores por defecto para el rango
    _minNumberController.text = '1';
    _maxNumberController.text = '100';
    
    // Inicializar efectos especiales
    EffectsService.initialize(this);
  }

  @override
  void dispose() {
    _participantsController.dispose();
    _numbersController.dispose();
    _minNumberController.dispose();
    _maxNumberController.dispose();
    _rifasController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.sorteoTitle),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: AnimatedBackground(
        key: _backgroundKey,
        primaryColor: Theme.of(context).colorScheme.primary,
        secondaryColor: Theme.of(context).colorScheme.secondary,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
            // Indicador del tipo de sorteo seleccionado con animación
            AnimatedCard(
              delay: 0,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppConstants.defaultPadding),
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _sorteoType == 'nombres' 
                            ? Icons.person 
                            : _sorteoType == 'numeros'
                              ? Icons.numbers
                              : Icons.confirmation_number,
                          color: Theme.of(context).colorScheme.primary,
                          size: 28,
                        ),
                        const SizedBox(width: AppConstants.smallPadding),
                        Text(
                          _sorteoType == 'nombres' 
                            ? 'Sorteo de Nombres' 
                            : _sorteoType == 'numeros'
                              ? 'Sorteo de Números'
                              : 'Sorteo de Rifas',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppConstants.defaultPadding),
            
            // Campos según el tipo de sorteo
            if (_sorteoType == 'nombres') ...[
              // Campo de participantes (solo para sorteo de nombres)
              AnimatedCard(
                delay: 100,
                child: InputField(
                  controller: _participantsController,
                  label: AppConstants.enterParticipants,
                  hint: 'Ej: Juan, María, Pedro (uno por línea)',
                  maxLines: 5,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return AppConstants.errorEmptyParticipants;
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: AppConstants.defaultPadding),
            ] else if (_sorteoType == 'rifas') ...[
              // Campo de rifas (número - nombre)
              AnimatedCard(
                delay: 100,
                child: InputField(
                  controller: _rifasController,
                  label: AppConstants.enterRifas,
                  hint: 'Ej:\n1 - Juan\n2 - María\n3 - Pedro',
                  maxLines: 8,
                  keyboardType: TextInputType.multiline,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return AppConstants.errorEmptyRifas;
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: AppConstants.smallPadding),
              AnimatedCard(
                delay: 200,
                child: Card(
                  color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
                  child: Padding(
                    padding: const EdgeInsets.all(AppConstants.defaultPadding),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Theme.of(context).colorScheme.primary,
                          size: 20,
                        ),
                        const SizedBox(width: AppConstants.smallPadding),
                        Expanded(
                          child: Text(
                            'Formato: Número - Nombre\nEj: 1 - Juan, 25 - María',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppConstants.defaultPadding),
            ] else ...[
              // Opciones para sorteo de números
              AnimatedCard(
                delay: 100,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppConstants.defaultPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tipo de Sorteo de Números',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: AppConstants.smallPadding),
                        Row(
                          children: [
                            Expanded(
                              child: RadioListTile<bool>(
                                title: const Text('Rango'),
                                subtitle: const Text('Ej: del 1 al 100'),
                                value: true,
                                groupValue: _useRange,
                                onChanged: (value) {
                                  setState(() {
                                    _useRange = value!;
                                  });
                                },
                              ),
                            ),
                            Expanded(
                              child: RadioListTile<bool>(
                                title: const Text('Lista'),
                                subtitle: const Text('Ej: 5, 10, 15, 20'),
                                value: false,
                                groupValue: _useRange,
                                onChanged: (value) {
                                  setState(() {
                                    _useRange = value!;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppConstants.defaultPadding),
              
              // Campos según el tipo seleccionado
              if (_useRange) ...[
                // Campos de rango
                AnimatedCard(
                  delay: 200,
                  child: Row(
                    children: [
                      Expanded(
                        child: InputField(
                          controller: _minNumberController,
                          label: 'Desde',
                          hint: 'Ej: 1',
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Ingresa el número mínimo';
                            }
                            final num = int.tryParse(value);
                            if (num == null) {
                              return 'Número inválido';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: AppConstants.smallPadding),
                      Expanded(
                        child: InputField(
                          controller: _maxNumberController,
                          label: 'Hasta',
                          hint: 'Ej: 100',
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Ingresa el número máximo';
                            }
                            final num = int.tryParse(value);
                            if (num == null) {
                              return 'Número inválido';
                            }
                            final minNum = int.tryParse(_minNumberController.text);
                            if (minNum != null && num <= minNum) {
                              return 'Debe ser mayor al mínimo';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                // Campo de lista de números
                AnimatedCard(
                  delay: 200,
                  child: InputField(
                    controller: _numbersController,
                    label: AppConstants.enterNumbers,
                    hint: 'Ej: 1\n2\n3\n4\n5 (uno por línea)',
                    maxLines: 5,
                    keyboardType: TextInputType.multiline,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return AppConstants.errorEmptyNumbers;
                      }
                      return null;
                    },
                  ),
                ),
              ],
              const SizedBox(height: AppConstants.defaultPadding),
            ],
            
            const SizedBox(height: AppConstants.largePadding),
            
            // Botón de sortear con animación de pulso
            Center(
              child: PulseAnimationButton(
                text: AppConstants.sortearButton,
                icon: Icons.shuffle,
                onPressed: _realizarSorteo,
                isLoading: _isLoading,
              ),
            ),
            const SizedBox(height: AppConstants.largePadding),
                  ],
                ),
              ),
            ),
            
            // Animación del tambor giratorio
            if (_showDrumAnimation)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.7),
                  child: Center(
                    child: SorteoDrumAnimation(
                      items: _animationItems,
                      isAnimating: _isLoading,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _realizarSorteo() async {
    if (!_validateInputs()) return;

    await EffectsService.vibrarBoton();
    
    // Agregar chispas en la posición del botón
    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      final size = renderBox.size;
      _backgroundKey.currentState?.addSparkles(
        Offset(size.width / 2, size.height - 100),
      );
    }
    
    // Preparar los items para la animación
    List<String> animationItems = [];
    if (_sorteoType == 'nombres') {
      animationItems = _participantsController.text
          .split('\n')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
    } else if (_sorteoType == 'rifas') {
      animationItems = _rifasController.text
          .split('\n')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
    } else {
      if (_useRange) {
        final minNum = int.parse(_minNumberController.text);
        final maxNum = int.parse(_maxNumberController.text);
        // Generar algunos números de muestra para la animación
        final sampleSize = min(20, maxNum - minNum + 1);
        for (int i = 0; i < sampleSize; i++) {
          animationItems.add((minNum + Random().nextInt(maxNum - minNum + 1)).toString());
        }
      } else {
        animationItems = _numbersController.text
            .split('\n')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList();
      }
    }
    
    setState(() {
      _isLoading = true;
      _showDrumAnimation = true;
      _animationItems = animationItems;
    });

    try {
      // Animación de sorteo más larga para mayor suspenso
      await Future.delayed(const Duration(milliseconds: 2500));

      String winner;
      List<String> participants = [];

      if (_sorteoType == 'nombres') {
        // Sorteo de nombres
        participants = _participantsController.text
            .split('\n')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList();
        winner = SorteoService.sortearNombre(participants);
      } else if (_sorteoType == 'rifas') {
        // Sorteo de rifas
        final rifas = _rifasController.text
            .split('\n')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList();
        winner = SorteoService.sortearRifa(rifas);
        participants = rifas;
      } else {
        // Sorteo de números
        if (_useRange) {
          // Sorteo por rango
          final minNum = int.parse(_minNumberController.text);
          final maxNum = int.parse(_maxNumberController.text);
          final randomNumber = minNum + Random().nextInt(maxNum - minNum + 1);
          winner = randomNumber.toString();
          // Para el sorteo de números, los "participants" son el rango
          participants = ['Del $minNum al $maxNum'];
        } else {
          // Sorteo por lista
          final numbers = _numbersController.text
              .split('\n')
              .map((e) => e.trim())
              .where((e) => e.isNotEmpty)
              .toList();
          winner = SorteoService.sortearNumero(numbers);
          // Para el sorteo de números, los "participants" son los números
          participants = numbers;
        }
      }

      if (mounted) {
        AppRoutes.navigateToResult(
          context,
          winner: winner,
          participants: participants,
          timestamp: DateTime.now(),
          tipo: _sorteoType,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppConstants.errorGeneric),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _showDrumAnimation = false;
        });
      }
    }
  }

  bool _validateInputs() {
    if (_sorteoType == 'nombres') {
      // Validar participantes para sorteo de nombres
      if (_participantsController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(AppConstants.errorEmptyParticipants),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
        return false;
      }
    } else if (_sorteoType == 'rifas') {
      // Validar rifas
      if (_rifasController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(AppConstants.errorEmptyRifas),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
        return false;
      }
      
      // Validar formato de rifas
      final rifas = _rifasController.text
          .split('\n')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
      
      for (final rifa in rifas) {
        if (!rifa.contains('-')) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(AppConstants.errorInvalidRifaFormat),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
          return false;
        }
      }
    } else {
      // Validar números para sorteo de números
      if (_useRange) {
        // Validar rango
        if (_minNumberController.text.trim().isEmpty || 
            _maxNumberController.text.trim().isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Debes ingresar el rango de números'),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
          return false;
        }
        
        final minNum = int.tryParse(_minNumberController.text);
        final maxNum = int.tryParse(_maxNumberController.text);
        
        if (minNum == null || maxNum == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Los números deben ser válidos'),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
          return false;
        }
        
        if (maxNum <= minNum) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('El número máximo debe ser mayor al mínimo'),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
          return false;
        }
      } else {
        // Validar lista de números
        if (_numbersController.text.trim().isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(AppConstants.errorEmptyNumbers),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
          return false;
        }
      }
    }

    return true;
  }
}
