import 'package:cloud_firestore/cloud_firestore.dart';

class PolicyModel {
  final String id;
  final String userId;
  final String policyNumber;
  final DateTime startDate;
  final DateTime endDate;
  final double baseValue;
  final double discountPercentage;
  final double finalValue;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? updatedAt;

  PolicyModel({
    required this.id,
    required this.userId,
    required this.policyNumber,
    required this.startDate,
    required this.endDate,
    required this.baseValue,
    required this.discountPercentage,
    required this.finalValue,
    this.isActive = true,
    required this.createdAt,
    this.updatedAt,
  });

  factory PolicyModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PolicyModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      policyNumber: data['policyNumber'] ?? '',
      startDate: (data['startDate'] as Timestamp).toDate(),
      endDate: (data['endDate'] as Timestamp).toDate(),
      baseValue: (data['baseValue'] ?? 0.0).toDouble(),
      discountPercentage: (data['discountPercentage'] ?? 0.0).toDouble(),
      finalValue: (data['finalValue'] ?? 0.0).toDouble(),
      isActive: data['isActive'] ?? true,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: data['updatedAt'] != null
          ? (data['updatedAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'policyNumber': policyNumber,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'baseValue': baseValue,
      'discountPercentage': discountPercentage,
      'finalValue': finalValue,
      'isActive': isActive,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }

  PolicyModel copyWith({
    String? id,
    String? userId,
    String? policyNumber,
    DateTime? startDate,
    DateTime? endDate,
    double? baseValue,
    double? discountPercentage,
    double? finalValue,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PolicyModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      policyNumber: policyNumber ?? this.policyNumber,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      baseValue: baseValue ?? this.baseValue,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      finalValue: finalValue ?? this.finalValue,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}