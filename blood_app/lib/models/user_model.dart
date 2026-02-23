import 'package:mongo_dart/mongo_dart.dart';

class User {
  final ObjectId id;
  final String fullName;
  final int age;
  final String email;
  final String password; // In a real app this should be hashed
  final List<ScanResult> history;

  User({
    required this.id,
    required this.fullName,
    required this.age,
    required this.email,
    required this.password,
    this.history = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'fullName': fullName,
      'age': age,
      'email': email,
      'password': password,
      'history': history.map((e) => e.toMap()).toList(),
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['_id'] as ObjectId,
      fullName: map['fullName'] as String,
      age: map['age'] as int,
      email: map['email'] as String,
      password: map['password'] as String,
      history: (map['history'] as List<dynamic>?)
              ?.map((e) => ScanResult.fromMap(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class ScanResult {
  final DateTime timestamp;
  final String bloodGroup;

  ScanResult({
    required this.timestamp,
    required this.bloodGroup,
  });

  Map<String, dynamic> toMap() {
    return {
      'timestamp': timestamp.toIso8601String(),
      'bloodGroup': bloodGroup,
    };
  }

  factory ScanResult.fromMap(Map<String, dynamic> map) {
    return ScanResult(
      timestamp: DateTime.parse(map['timestamp'] as String),
      bloodGroup: map['bloodGroup'] as String,
    );
  }
}
