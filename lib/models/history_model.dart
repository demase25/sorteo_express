class HistoryModel {
  final String id;
  final String winner;
  final List<String> participants;
  final DateTime timestamp;
  final String type; // 'nombres', 'numeros' o 'rifas'
  final List<String>? numbers; // Solo para sorteos de números

  HistoryModel({
    required this.id,
    required this.winner,
    required this.participants,
    required this.timestamp,
    required this.type,
    this.numbers,
  });

  // Constructor desde JSON
  factory HistoryModel.fromJson(Map<String, dynamic> json) {
    return HistoryModel(
      id: json['id'] as String,
      winner: json['winner'] as String,
      participants: List<String>.from(json['participants'] as List),
      timestamp: DateTime.parse(json['timestamp'] as String),
      type: json['type'] as String,
      numbers: json['numbers'] != null 
          ? List<String>.from(json['numbers'] as List)
          : null,
    );
  }

  // Convertir a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'winner': winner,
      'participants': participants,
      'timestamp': timestamp.toIso8601String(),
      'type': type,
      'numbers': numbers,
    };
  }

  // Constructor para sorteo de nombres
  factory HistoryModel.fromNamesSorteo({
    required String winner,
    required List<String> participants,
  }) {
    return HistoryModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      winner: winner,
      participants: participants,
      timestamp: DateTime.now(),
      type: 'nombres',
    );
  }

  // Constructor para sorteo de números
  factory HistoryModel.fromNumbersSorteo({
    required String winner,
    required List<String> participants,
    required List<String> numbers,
  }) {
    return HistoryModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      winner: winner,
      participants: participants,
      timestamp: DateTime.now(),
      type: 'numeros',
      numbers: numbers,
    );
  }

  // Constructor para sorteo de rifas
  factory HistoryModel.fromRifasSorteo({
    required String winner,
    required List<String> participants,
  }) {
    return HistoryModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      winner: winner,
      participants: participants,
      timestamp: DateTime.now(),
      type: 'rifas',
    );
  }

  // Método para obtener descripción del sorteo
  String get description {
    if (type == 'nombres') {
      return 'Sorteo de nombres entre ${participants.length} participantes';
    } else if (type == 'rifas') {
      return 'Sorteo de rifas entre ${participants.length} participantes';
    } else {
      return 'Sorteo de números entre ${participants.length} participantes';
    }
  }

  // Método para obtener fecha formateada
  String get formattedDate {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inDays > 0) {
      return 'Hace ${difference.inDays} día${difference.inDays > 1 ? 's' : ''}';
    } else if (difference.inHours > 0) {
      return 'Hace ${difference.inHours} hora${difference.inHours > 1 ? 's' : ''}';
    } else if (difference.inMinutes > 0) {
      return 'Hace ${difference.inMinutes} minuto${difference.inMinutes > 1 ? 's' : ''}';
    } else {
      return 'Hace unos segundos';
    }
  }

  // Método para copiar con cambios
  HistoryModel copyWith({
    String? id,
    String? winner,
    List<String>? participants,
    DateTime? timestamp,
    String? type,
    List<String>? numbers,
  }) {
    return HistoryModel(
      id: id ?? this.id,
      winner: winner ?? this.winner,
      participants: participants ?? this.participants,
      timestamp: timestamp ?? this.timestamp,
      type: type ?? this.type,
      numbers: numbers ?? this.numbers,
    );
  }

  @override
  String toString() {
    return 'HistoryModel(id: $id, winner: $winner, participants: $participants, timestamp: $timestamp, type: $type, numbers: $numbers)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is HistoryModel &&
        other.id == id &&
        other.winner == winner &&
        other.participants == participants &&
        other.timestamp == timestamp &&
        other.type == type &&
        other.numbers == numbers;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        winner.hashCode ^
        participants.hashCode ^
        timestamp.hashCode ^
        type.hashCode ^
        numbers.hashCode;
  }
}
