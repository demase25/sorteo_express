import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../core/routes.dart';
import '../models/history_model.dart';
import '../services/sorteo_service.dart';
import '../services/share_service.dart';
import '../widgets/custom_button.dart';

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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _sorteos.isEmpty
              ? _buildEmptyState()
              : _buildHistorialList(),
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
            Icon(
              Icons.history,
              size: 120,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
            ),
            const SizedBox(height: AppConstants.largePadding),
            Text(
              'No hay sorteos guardados',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: AppConstants.smallPadding),
            Text(
              'Crea tu primer sorteo para verlo aquí',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppConstants.largePadding),
            CustomButton(
              text: 'Crear Sorteo',
              icon: Icons.add,
              onPressed: _mostrarOpcionesSorteo,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistorialList() {
    return RefreshIndicator(
      onRefresh: _cargarHistorial,
      child: ListView.builder(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        itemCount: _sorteos.length,
        itemBuilder: (context, index) {
          final sorteo = _sorteos[index];
          return Card(
            margin: const EdgeInsets.only(bottom: AppConstants.smallPadding),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: Icon(
                  sorteo.type == 'nombres' 
                    ? Icons.person 
                    : sorteo.type == 'numeros'
                      ? Icons.numbers
                      : Icons.confirmation_number,
                  color: Colors.white,
                ),
              ),
              title: Text(
                sorteo.winner,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(sorteo.description),
                  Text(
                    sorteo.formattedDate,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              trailing: PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'eliminar') {
                    _eliminarSorteo(sorteo);
                  } else if (value == 'compartir') {
                    _compartirSorteo(sorteo);
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'compartir',
                    child: Row(
                      children: [
                        Icon(Icons.share),
                        SizedBox(width: 8),
                        Text('Compartir'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'eliminar',
                    child: Row(
                      children: [
                        Icon(Icons.delete, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Eliminar', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
              ),
              onTap: () => _mostrarDetallesSorteo(sorteo),
            ),
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
