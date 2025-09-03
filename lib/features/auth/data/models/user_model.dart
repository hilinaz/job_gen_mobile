import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    required super.username,
    required super.fullName,
    required super.role,
    required super.active,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id']?.toString() ?? '',
      email: json['email'] ?? '',
      username: json['username'] ?? '',
      fullName: json['full_name'] ?? '',
      role: json['role'] ?? 'user',
      active: json['active'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'email': email,
        'username': username,
        'full_name': fullName,
        'role': role,
        'active': active,
      };
}
