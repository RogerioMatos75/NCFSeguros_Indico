class User {
  final String id;
  final String email;
  final String name;
  String? photoUrl;
  double accumulatedDiscount;

  User({
    required this.id,
    required this.email,
    required this.name,
    this.photoUrl,
    this.accumulatedDiscount = 0.0,
  });

  User copyWith({
    String? id,
    String? email,
    String? name,
    String? photoUrl,
    double? accumulatedDiscount,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
      accumulatedDiscount: accumulatedDiscount ?? this.accumulatedDiscount,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'photoUrl': photoUrl,
      'accumulatedDiscount': accumulatedDiscount,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      photoUrl: map['photoUrl'],
      accumulatedDiscount: (map['accumulatedDiscount'] ?? 0.0).toDouble(),
    );
  }
}
