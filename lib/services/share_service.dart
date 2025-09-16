import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import '../models/history_model.dart';

class ShareService {
  /// Comparte un resultado usando el sistema nativo de compartir
  static Future<void> compartirResultado({
    required String winner,
    required List<String> participants,
    required DateTime timestamp,
    String? tipo,
  }) async {
    try {
      String message = _generarMensajeSorteo(
        winner: winner,
        participants: participants,
        timestamp: timestamp,
        tipo: tipo,
      );
      
      await Share.share(
        message,
        subject: 'Resultado del Sorteo - Sorteo Express',
      );
    } catch (e) {
      throw Exception('Error al compartir: $e');
    }
  }

  /// Comparte un resultado de sorteo por WhatsApp específicamente
  static Future<void> compartirPorWhatsApp({
    required String winner,
    required List<String> participants,
    required DateTime timestamp,
    String? tipo,
  }) async {
    try {
      String message = _generarMensajeSorteo(
        winner: winner,
        participants: participants,
        timestamp: timestamp,
        tipo: tipo,
      );
      
      String url = _generarUrlWhatsApp(message);
      
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      } else {
        // Si no puede abrir WhatsApp, usar el compartir nativo
        await Share.share(
          message,
          subject: 'Resultado del Sorteo - WhatsApp',
        );
      }
    } catch (e) {
      throw Exception('Error al compartir por WhatsApp: $e');
    }
  }

  /// Comparte un sorteo del historial usando el sistema nativo
  static Future<void> compartirHistorial(HistoryModel sorteo) async {
    try {
      String message = _generarMensajeHistorial(sorteo);
      
      await Share.share(
        message,
        subject: 'Sorteo Guardado - Sorteo Express',
      );
    } catch (e) {
      throw Exception('Error al compartir: $e');
    }
  }

  /// Comparte un sorteo del historial por WhatsApp específicamente
  static Future<void> compartirHistorialPorWhatsApp(HistoryModel sorteo) async {
    try {
      String message = _generarMensajeHistorial(sorteo);
      
      String url = _generarUrlWhatsApp(message);
      
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      } else {
        // Si no puede abrir WhatsApp, usar el compartir nativo
        await Share.share(
          message,
          subject: 'Sorteo Guardado - WhatsApp',
        );
      }
    } catch (e) {
      throw Exception('Error al compartir por WhatsApp: $e');
    }
  }

  /// Genera el mensaje para compartir un sorteo
  static String _generarMensajeSorteo({
    required String winner,
    required List<String> participants,
    required DateTime timestamp,
    String? tipo,
  }) {
    String tipoSorteo = tipo == 'numeros' ? 'números' : 'nombres';
    String fecha = _formatearFecha(timestamp);
    
    String mensaje = '🎉 *¡Resultado del Sorteo!* 🎉\n\n';
    mensaje += '🏆 *Ganador:* $winner\n';
    mensaje += '📅 *Fecha:* $fecha\n';
    mensaje += '🎯 *Tipo:* Sorteo de $tipoSorteo\n\n';
    
    if (participants.length == 1 && participants.first.startsWith('Del ')) {
      // Es un sorteo por rango
      mensaje += '📊 *Rango:* ${participants.first}\n';
    } else {
      // Es un sorteo por lista
      mensaje += '👥 *Participantes:*\n';
      for (String participant in participants) {
        mensaje += '• $participant\n';
      }
    }
    
    mensaje += '\n✨ *Generado con Sorteo Express* ✨';
    
    return mensaje;
  }

  /// Genera el mensaje para compartir un sorteo del historial
  static String _generarMensajeHistorial(HistoryModel sorteo) {
    String tipoSorteo = sorteo.type == 'numeros' ? 'números' : 'nombres';
    String fecha = _formatearFecha(sorteo.timestamp);
    
    String mensaje = '🎉 *¡Sorteo Guardado!* 🎉\n\n';
    mensaje += '🏆 *Ganador:* ${sorteo.winner}\n';
    mensaje += '📅 *Fecha:* $fecha\n';
    mensaje += '🎯 *Tipo:* Sorteo de $tipoSorteo\n\n';
    
    if (sorteo.numbers != null && sorteo.numbers!.isNotEmpty) {
      // Es un sorteo de números con lista específica
      mensaje += '🔢 *Números:*\n';
      for (String number in sorteo.numbers!) {
        mensaje += '• $number\n';
      }
    } else if (sorteo.participants.length == 1 && sorteo.participants.first.startsWith('Del ')) {
      // Es un sorteo por rango
      mensaje += '📊 *Rango:* ${sorteo.participants.first}\n';
    } else {
      // Es un sorteo por lista de nombres
      mensaje += '👥 *Participantes:*\n';
      for (String participant in sorteo.participants) {
        mensaje += '• $participant\n';
      }
    }
    
    mensaje += '\n✨ *Generado con Sorteo Express* ✨';
    
    return mensaje;
  }

  /// Genera la URL de WhatsApp con el mensaje
  static String _generarUrlWhatsApp(String message) {
    String encodedMessage = Uri.encodeComponent(message);
    return 'https://wa.me/?text=$encodedMessage';
  }

  /// Formatea la fecha para el mensaje
  static String _formatearFecha(DateTime fecha) {
    return '${fecha.day}/${fecha.month}/${fecha.year} a las ${fecha.hour.toString().padLeft(2, '0')}:${fecha.minute.toString().padLeft(2, '0')}';
  }

  /// Muestra un diálogo de opciones de compartir con fondo colorido
  static Future<void> mostrarOpcionesCompartir({
    required BuildContext context,
    required String winner,
    required List<String> participants,
    required DateTime timestamp,
    String? tipo,
  }) async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.9),
              Theme.of(context).colorScheme.secondary.withOpacity(0.8),
              Theme.of(context).colorScheme.tertiary.withOpacity(0.7),
            ],
          ),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle del modal con efecto neón
              Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(3),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.5),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              
              // Título con efecto especial
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  '🎉 ¡Compartir Ganador! 🎉',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 5,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 25),
            
              // Opción Compartir General con efecto especial
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withOpacity(0.3),
                          Colors.white.withOpacity(0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.2),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.share,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  title: Text(
                    '📱 Compartir',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    'Elegir aplicación para compartir',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                  onTap: () async {
                    Navigator.pop(context);
                    try {
                      await compartirResultado(
                        winner: winner,
                        participants: participants,
                        timestamp: timestamp,
                        tipo: tipo,
                      );
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error al compartir: $e'),
                            backgroundColor: Theme.of(context).colorScheme.error,
                          ),
                        );
                      }
                    }
                  },
                ),
              ),
              
              // Opción WhatsApp con efecto especial
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: Colors.green.withOpacity(0.4),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.2),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.green.withOpacity(0.4),
                          Colors.green.withOpacity(0.2),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.withOpacity(0.3),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.message,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  title: Text(
                    '💬 WhatsApp',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    'Abrir WhatsApp directamente',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                  onTap: () async {
                    Navigator.pop(context);
                    try {
                      await compartirPorWhatsApp(
                        winner: winner,
                        participants: participants,
                        timestamp: timestamp,
                        tipo: tipo,
                      );
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error al compartir: $e'),
                            backgroundColor: Theme.of(context).colorScheme.error,
                          ),
                        );
                      }
                    }
                  },
                ),
              ),
              
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
