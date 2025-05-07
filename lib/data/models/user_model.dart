import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String email;
  final String name;
  final String phone;
  final String? photoUrl;
  final bool isAdmin;
  final double currentDiscount;
  final int totalIndications;
  final int convertedIndications;
  final DateTime createdAt;
  final DateTime? lastLoginAt;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.phone,
    this.photoUrl,
    this.isAdmin = false,
    this.currentDiscount = 0.0,
    this.totalIndications = 0,
    this.convertedIndications = 0,
    required this.createdAt,
    this.lastLoginAt,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      phone: data['phone'] ?? '',
      photoUrl: data['photoUrl'],
      isAdmin: data['isAdmin'] ?? false,
      currentDiscount: (data['currentDiscount'] ?? 0.0).toDouble(),
      totalIndications: data['totalIndications'] ?? 0,
      convertedIndications: data['convertedIndications'] ?? 0,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      lastLoginAt: data['lastLoginAt'] != null
          ? (data['lastLoginAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'phone': phone,
      'photoUrl': photoUrl,
      'isAdmin': isAdmin,
      'currentDiscount': currentDiscount,
      'totalIndications': totalIndications,
      'convertedIndications': convertedIndications,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastLoginAt': lastLoginAt != null ? Timestamp.fromDate(lastLoginAt!) : null,
    };
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? phone,
    String? photoUrl,
    bool? isAdmin,
    double? currentDiscount,
    int? totalIndications,
    int? convertedIndications,
    DateTime? createdAt,
    DateTime? lastLoginAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      photoUrl: photoUrl ?? this.photoUrl,
      isAdmin: isAdmin ?? this.isAdmin,
      currentDiscount: currentDiscount ?? this.currentDiscount,
      totalIndications: totalIndications ?? this.totalIndications,
      convertedIndications: convertedIndications ?? this.convertedIndications,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
    );
  }
}