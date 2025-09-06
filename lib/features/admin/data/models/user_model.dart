import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required String id,
    required String name,
    required String email,
    required String role,
    required bool isActive,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) : super(
          id: id,
          name: name,
          email: email,
          role: role,
          isActive: isActive,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Add defensive programming with null checks
    try {
      // Debug the available fields
      print('DEBUG: User JSON fields: ${json.keys.toList()}');
      
      // Handle different ID field names and formats
      String userId = '';
      if (json['_id'] != null) {
        // MongoDB might return _id directly
        if (json['_id'] is Map && json['_id']['\$oid'] != null) {
          // Handle ObjectId format: {"$oid": "123456789"}
          userId = json['_id']['\$oid'].toString();
        } else {
          // Handle string ID format
          userId = json['_id'].toString();
        }
      } else if (json['id'] != null) {
        userId = json['id'].toString();
      }
      print('DEBUG: User ID parsed as: $userId');
      
      // Get name from full_name, username, or name fields, with fallbacks
      String userName = json['full_name'] ?? 
                       json['fullName'] ?? 
                       json['username'] ?? 
                       json['name'] ?? 
                       'Unknown';
                       
      // Check if isActive is using a different field name
      bool active = false;
      if (json['is_active'] != null) {
        active = json['is_active'] as bool;
      } else if (json['isActive'] != null) {
        active = json['isActive'] as bool;
      } else if (json['active'] != null) {
        active = json['active'] as bool;
      }
      
      // Check for different date field names
      DateTime createdAt;
      if (json['created_at'] != null) {
        createdAt = DateTime.parse(json['created_at'].toString());
      } else if (json['createdAt'] != null) {
        createdAt = DateTime.parse(json['createdAt'].toString());
      } else {
        createdAt = DateTime.now();
      }
      
      DateTime? updatedAt;
      if (json['updated_at'] != null) {
        updatedAt = DateTime.parse(json['updated_at'].toString());
      } else if (json['updatedAt'] != null) {
        updatedAt = DateTime.parse(json['updatedAt'].toString());
      }
      
      return UserModel(
        id: userId,
        name: userName,
        email: json['email'] ?? 'no-email@example.com',
        role: json['role'] ?? 'user',
        isActive: active,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
    } catch (e) {
      // If parsing fails, return a default user model
      print('Error parsing user JSON: $e');
      print('Problematic JSON: $json');
      // Can't use const with DateTime.now()
      return UserModel(
        id: 'error',
        name: 'Error parsing user',
        email: 'error@parsing.com',
        role: 'unknown',
        isActive: false,
        createdAt: DateTime.now(), // Use current time instead of null
        updatedAt: null,
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
