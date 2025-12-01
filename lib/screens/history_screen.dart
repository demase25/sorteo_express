import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../core/routes.dart';
import '../core/theme.dart';
import '../models/history_model.dart';
import '../services/sorteo_service.dart';
import '../services/share_service.dart';
import '../widgets/custom_button.dart';
import '../widgets/animated_background.dart';
import '../widgets/history_card.dart';
import '../widgets/animated_menu_button.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<HistoryModel> _sorteos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _cargarHistorial();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.historyTitle),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          if (_sorteos.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              onPressed: _mostrarDialogoEliminarTodo,
            ),
        ],
      ),
      body: AnimatedBackground(
        primaryColor: AppTheme.primaryColor,
        secondaryColor: AppTheme.secondaryColor,
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : _sorteos.isEmpty
                ? _buildEmptyState()
                : _buildHistorialList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _mostrarOpcionesSorteo,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.largePadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icono animado
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 1000),
              curve: Curves.elasticOut,
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: Transform.rotate(
                    angle: (1 - value) * 3.14,
                    child: child,
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary,
                    width: 4,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.3),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.history,
                  size: 80,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(height: AppConstants.largePadding),
            
            // Título animado
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOut,
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(0, 20 * (1 - value)),
                    child: child,
                  ),
                );
              },
              child: Text(
                'No hay sorteos guardados',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          color: const Color(0xFF1A1A1A).withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(2, 2),
                        ),
                      ],
                    ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: AppConstants.smallPadding),
            
            // Subtítulo animado
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 1000),
              curve: Curves.easeOut,
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(0, 20 * (1 - value)),
                    child: child,
                  ),
                );
              },
              child: Text(
                'Crea tu primer sorteo para verlo aquí',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white.withOpacity(0.9),
                      fontWeight: FontWeight.w500,
                    ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: AppConstants.largePadding),
            
            // Botón animado
            AnimatedMenuButton(
              text: 'Crear Sorteo',
              icon: Icons.add,
              onPressed: _mostrarOpcionesSorteo,
              index: 0,
              gradientStart: AppTheme.primaryColor,
              gradientEnd: AppTheme.secondaryColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistorialList() {
    return RefreshIndicator(
      onRefresh: _cargarHistorial,
      color: AppTheme.primaryColor,
      child: ListView.builder(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        itemCount: _sorteos.length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          final sorteo = _sorteos[index];
          return HistoryCard(
            sorteo: sorteo,
            index: index,
            onTap: () => _mostrarDetallesSorteo(sorteo),
            onMenuSelected: (value) {
              if (value == 'eliminar') {
                _eliminarSorteo(sorteo);
              } else if (value == 'compartir') {
                _compartirSorteo(sorteo);
              }
            },
          );
        },
      ),
    );
  }

  Future<void> _cargarHistorial() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final sorteos = await SorteoService.obtenerHistorial();
      setState(() {
        _sorteos = sorteos;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
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

  void _eliminarSorteo(HistoryModel sorteo) async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Sorteo'),
        content: const Text('¿Estás seguro de que quieres eliminar este sorteo?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmado == true) {
      try {
        await SorteoService.eliminarSorteo(sorteo.id);
        await _cargarHistorial();
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(AppConstants.successSorteoDeleted),
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
          );
        }
      } catch (e) {
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
  }

  void _compartirSorteo(HistoryModel sorteo) async {
    try {
      await ShareService.compartirHistorial(sorteo);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al compartir: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  void _mostrarDetallesSorteo(HistoryModel sorteo) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Detalles del Sorteo'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Ganador: ${sorteo.winner}'),
            const SizedBox(height: 8),
            Text('Participantes:'),
            ...sorteo.participants.map((p) => Text('• $p')),
            const SizedBox(height: 8),
            Text('Fecha: ${sorteo.formattedDate}'),
            if (sorteo.numbers != null) ...[
              const SizedBox(height: 8),
              Text('Números: ${sorteo.numbers!.join(', ')}'),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  void _mostrarDialogoEliminarTodo() async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Todo'),
        content: const Text('¿Estás seguro de que quieres eliminar todos los sorteos? Esta acción no se puede deshacer.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Eliminar Todo', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmado == true) {
      try {
        await SorteoService.eliminarTodoHistorial();
        await _cargarHistorial();
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Todos los sorteos han sido eliminados'),
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
          );
        }
      } catch (e) {
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
  }

  void _mostrarOpcionesSorteo() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle del modal
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: AppConstants.defaultPadding),
            
            Text(
              'Crear Nuevo Sorteo',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppConstants.largePadding),
            
            // Opción Sorteo de Nombres
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.person,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              title: const Text('Sorteo de Nombres'),
              subtitle: const Text('Sortear entre una lista de personas'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(
                  context,
                  AppRoutes.sorteo,
                  arguments: {'tipo': 'nombres'},
                );
              },
            ),
            
            const SizedBox(height: AppConstants.smallPadding),
            
            // Opción Sorteo de Números
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.numbers,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              title: const Text('Sorteo de Números'),
              subtitle: const Text('Sortear números por rango o lista'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(
                  context,
                  AppRoutes.sorteo,
                  arguments: {'tipo': 'numeros'},
                );
              },
            ),
            
            const SizedBox(height: AppConstants.smallPadding),
            
            // Opción Sorteo de Rifas
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.confirmation_number,
                  color: Colors.orange,
                ),
              ),
              title: const Text('Sorteo de Rifas'),
              subtitle: const Text('Sortear números con nombres asignados'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(
                  context,
                  AppRoutes.sorteo,
                  arguments: {'tipo': 'rifas'},
                );
              },
            ),
            
            const SizedBox(height: AppConstants.largePadding),
          ],
        ),
      ),
    );
  }
}
