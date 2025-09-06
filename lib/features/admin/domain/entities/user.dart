import 'package:equatable/equatable.dart';

/// User entity representing a user in the system
class User extends Equatable {
  final String id;
  final String name;
  final String email;
  final String role;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.isActive,
    required this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        role,
        isActive,
        createdAt,
        updatedAt,
      ];
}
