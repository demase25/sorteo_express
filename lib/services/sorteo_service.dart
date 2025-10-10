import 'dart:math';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/history_model.dart';
import '../core/constants.dart';

class SorteoService {
  static final Random _random = Random();

  /// Realiza un sorteo de nombres
  static String sortearNombre(List<String> participantes) {
    if (participantes.isEmpty) {
      throw Exception('No hay participantes para sortear');
    }
    
    // Filtrar participantes vacíos
    final participantesValidos = participantes
        .where((p) => p.trim().isNotEmpty)
        .toList();
    
    if (participantesValidos.isEmpty) {
      throw Exception('No hay participantes válidos para sortear');
    }
    
    final indiceGanador = _random.nextInt(participantesValidos.length);
    return participantesValidos[indiceGanador].trim();
  }

  /// Realiza un sorteo de números
  static String sortearNumero(List<String> numeros) {
    if (numeros.isEmpty) {
      throw Exception('No hay números para sortear');
    }
    
    // Filtrar números válidos
    final numerosValidos = numeros
        .where((n) => n.trim().isNotEmpty && _esNumeroValido(n.trim()))
        .toList();
    
    if (numerosValidos.isEmpty) {
      throw Exception('No hay números válidos para sortear');
    }
    
    final indiceGanador = _random.nextInt(numerosValidos.length);
    return numerosValidos[indiceGanador].trim();
  }

  /// Realiza un sorteo de rifas (número - nombre)
  static String sortearRifa(List<String> rifas) {
    if (rifas.isEmpty) {
      throw Exception('No hay rifas para sortear');
    }
    
    // Filtrar rifas válidas (deben tener el formato número - nombre)
    final rifasValidas = rifas
        .where((r) => r.trim().isNotEmpty && r.contains('-'))
        .toList();
    
    if (rifasValidas.isEmpty) {
      throw Exception('No hay rifas válidas para sortear');
    }
    
    final indiceGanador = _random.nextInt(rifasValidas.length);
    return rifasValidas[indiceGanador].trim();
  }

  /// Valida si un string es un número válido
  static bool _esNumeroValido(String numero) {
    try {
      int.parse(numero);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Genera números aleatorios en un rango
  static List<String> generarNumerosAleatorios(int cantidad, int min, int max) {
    if (cantidad <= 0 || min >= max) {
      throw Exception('Parámetros inválidos para generar números');
    }
    
    final numerosGenerados = <int>{};
    
    while (numerosGenerados.length < cantidad && numerosGenerados.length < (max - min + 1)) {
      final numero = min + _random.nextInt(max - min + 1);
      numerosGenerados.add(numero);
    }
    
    return numerosGenerados.map((n) => n.toString()).toList();
  }

  /// Guarda un sorteo en el historial
  static Future<void> guardarSorteo(HistoryModel sorteo) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historialJson = prefs.getString(AppConstants.historyKey) ?? '[]';
      final historial = (jsonDecode(historialJson) as List)
          .map((item) => HistoryModel.fromJson(item))
          .toList();
      
      historial.insert(0, sorteo); // Insertar al inicio
      
      // Limitar a 100 sorteos para evitar que crezca demasiado
      if (historial.length > 100) {
        historial.removeRange(100, historial.length);
      }
      
      final historialActualizado = historial.map((s) => s.toJson()).toList();
      await prefs.setString(AppConstants.historyKey, jsonEncode(historialActualizado));
    } catch (e) {
      throw Exception('Error al guardar el sorteo: $e');
    }
  }

  /// Obtiene el historial de sorteos
  static Future<List<HistoryModel>> obtenerHistorial() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historialJson = prefs.getString(AppConstants.historyKey) ?? '[]';
      final historial = (jsonDecode(historialJson) as List)
          .map((item) => HistoryModel.fromJson(item))
          .toList();
      
      // Ordenar por fecha (más recientes primero)
      historial.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      
      return historial;
    } catch (e) {
      throw Exception('Error al obtener el historial: $e');
    }
  }

  /// Elimina un sorteo del historial
  static Future<void> eliminarSorteo(String id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historialJson = prefs.getString(AppConstants.historyKey) ?? '[]';
      final historial = (jsonDecode(historialJson) as List)
          .map((item) => HistoryModel.fromJson(item))
          .toList();
      
      historial.removeWhere((sorteo) => sorteo.id == id);
      
      final historialActualizado = historial.map((s) => s.toJson()).toList();
      await prefs.setString(AppConstants.historyKey, jsonEncode(historialActualizado));
    } catch (e) {
      throw Exception('Error al eliminar el sorteo: $e');
    }
  }

  /// Elimina todo el historial
  static Future<void> eliminarTodoHistorial() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(AppConstants.historyKey);
    } catch (e) {
      throw Exception('Error al eliminar el historial: $e');
    }
  }

  /// Obtiene estadísticas del historial
  static Future<Map<String, dynamic>> obtenerEstadisticas() async {
    try {
      final historial = await obtenerHistorial();
      
      int totalSorteos = historial.length;
      int sorteosNombres = historial.where((s) => s.type == 'nombres').length;
      int sorteosNumeros = historial.where((s) => s.type == 'numeros').length;
      
      // Participante más frecuente
      final participanteCount = <String, int>{};
      for (final sorteo in historial) {
        for (final participante in sorteo.participants) {
          participanteCount[participante] = (participanteCount[participante] ?? 0) + 1;
        }
      }
      
      String participanteMasFrecuente = '';
      int maxCount = 0;
      participanteCount.forEach((participante, count) {
        if (count > maxCount) {
          maxCount = count;
          participanteMasFrecuente = participante;
        }
      });
      
      return {
        'totalSorteos': totalSorteos,
        'sorteosNombres': sorteosNombres,
        'sorteosNumeros': sorteosNumeros,
        'participanteMasFrecuente': participanteMasFrecuente,
        'vecesGanador': maxCount,
      };
    } catch (e) {
      throw Exception('Error al obtener estadísticas: $e');
    }
  }

  /// Valida los datos de entrada para un sorteo
  static Map<String, String> validarDatosSorteo({
    required List<String> participantes,
    List<String>? numeros,
    required String tipo,
  }) {
    final errores = <String, String>{};
    
    // Validar participantes
    if (participantes.isEmpty) {
      errores['participantes'] = 'Debes ingresar al menos un participante';
    } else if (participantes.length < AppConstants.minParticipants) {
      errores['participantes'] = 'Debes ingresar al menos ${AppConstants.minParticipants} participantes';
    } else if (participantes.length > AppConstants.maxParticipants) {
      errores['participantes'] = 'No puedes tener más de ${AppConstants.maxParticipants} participantes';
    }
    
    // Validar números si es sorteo de números
    if (tipo == 'numeros') {
      if (numeros == null || numeros.isEmpty) {
        errores['numeros'] = 'Debes ingresar al menos un número';
      } else if (numeros.length > AppConstants.maxNumbers) {
        errores['numeros'] = 'No puedes tener más de ${AppConstants.maxNumbers} números';
      }
    }
    
    return errores;
  }
}
