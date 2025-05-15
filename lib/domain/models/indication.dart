import 'package:cloud_firestore/cloud_firestore.dart';

class Indication {
  final String id;
  final String userId;
  final String name;
  final String email;
  final String phone;
  final String status;
  final DateTime createdAt;
  final String? notes;

  Indication({
    required this.id,
    required this.userId,
    required this.name,
    required this.email,
    required this.phone,
    required this.status,
    required this.createdAt,
    this.notes,
  });

  factory Indication.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Indication(
      id: doc.id,
      userId: data['userId'] as String,
      name: data['name'] as String,
      email: data['email'] as String,
      phone: data['phone'] as String,
      status: data['status'] as String,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      notes: data['notes'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'email': email,
      'phone': phone,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
      'notes': notes,
    };
  }
}