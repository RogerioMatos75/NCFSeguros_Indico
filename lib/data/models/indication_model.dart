import 'package:cloud_firestore/cloud_firestore.dart';

enum IndicationStatus {
  pending,    // Aguardando contato
  contacted,  // Cliente contatado
  converted,  // Convertido em cliente
  rejected    // Não teve interesse
}

class IndicationModel {
  final String id;
  final String userId;      // ID do usuário que fez a indicação
  final String userName;    // Nome do usuário que fez a indicação
  final String friendName;
  final String friendEmail;
  final String friendPhone;
  final IndicationStatus status;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? notes;      // Observações do admin

  IndicationModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.friendName,
    required this.friendEmail,
    required this.friendPhone,
    this.status = IndicationStatus.pending,
    required this.createdAt,
    this.updatedAt,
    this.notes,
  });

  factory IndicationModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return IndicationModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? '',
      friendName: data['friendName'] ?? '',
      friendEmail: data['friendEmail'] ?? '',
      friendPhone: data['friendPhone'] ?? '',
      status: IndicationStatus.values.firstWhere(
        (e) => e.toString() == 'IndicationStatus.${data['status']}',
        orElse: () => IndicationStatus.pending,
      ),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: data['updatedAt'] != null
          ? (data['updatedAt'] as Timestamp).toDate()
          : null,
      notes: data['notes'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'friendName': friendName,
      'friendEmail': friendEmail,
      'friendPhone': friendPhone,
      'status': status.toString().split('.').last,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
      'notes': notes,
    };
  }

  IndicationModel copyWith({
    String? id,
    String? userId,
    String? userName,
    String? friendName,
    String? friendEmail,
    String? friendPhone,
    IndicationStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? notes,
  }) {
    return IndicationModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      friendName: friendName ?? this.friendName,
      friendEmail: friendEmail ?? this.friendEmail,
      friendPhone: friendPhone ?? this.friendPhone,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      notes: notes ?? this.notes,
    );
  }
}