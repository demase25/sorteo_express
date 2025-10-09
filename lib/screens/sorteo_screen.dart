import 'package:flutter/material.dart';
import 'dart:math';
import '../core/constants.dart';
import '../core/routes.dart';
import '../widgets/custom_button.dart';
import '../widgets/input_field.dart';
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
  late String _sorteoType;
  bool _isLoading = false;
  bool _useRange = true; // Por defecto usar rango

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
      body: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
            // Indicador del tipo de sorteo seleccionado
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.defaultPadding),
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _sorteoType == 'nombres' ? Icons.person : Icons.numbers,
                        color: Theme.of(context).colorScheme.primary,
                        size: 28,
                      ),
                      const SizedBox(width: AppConstants.smallPadding),
                      Text(
                        _sorteoType == 'nombres' ? 'Sorteo de Nombres' : 'Sorteo de Números',
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
            const SizedBox(height: AppConstants.defaultPadding),
            
            // Campos según el tipo de sorteo
            if (_sorteoType == 'nombres') ...[
              // Campo de participantes (solo para sorteo de nombres)
              InputField(
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
              const SizedBox(height: AppConstants.defaultPadding),
            ] else ...[
              // Opciones para sorteo de números
              Card(
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
              const SizedBox(height: AppConstants.defaultPadding),
              
              // Campos según el tipo seleccionado
              if (_useRange) ...[
                // Campos de rango
                Row(
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
              ] else ...[
                // Campo de lista de números
                InputField(
                  controller: _numbersController,
                  label: AppConstants.enterNumbers,
                  hint: 'Ej: 1, 2, 3, 4, 5 (uno por línea)',
                  maxLines: 5,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return AppConstants.errorEmptyNumbers;
                    }
                    return null;
                  },
                ),
              ],
              const SizedBox(height: AppConstants.defaultPadding),
            ],
            
            const SizedBox(height: AppConstants.largePadding),
            
            // Botón de sortear
            CustomButton(
              text: AppConstants.sortearButton,
              icon: Icons.shuffle,
              onPressed: _isLoading ? null : _realizarSorteo,
              isLoading: _isLoading,
            ),
            const SizedBox(height: AppConstants.largePadding),
            ],
          ),
        ),
      ),
    );
  }

  void _realizarSorteo() async {
    if (!_validateInputs()) return;

    await EffectsService.vibrarBoton();
    
    setState(() {
      _isLoading = true;
    });

    try {
      // Simular delay para la animación
      await Future.delayed(const Duration(milliseconds: 1500));

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
