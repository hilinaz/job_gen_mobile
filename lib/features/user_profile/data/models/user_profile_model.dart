import 'package:job_gen_mobile/features/user_profile/domain/entity/user_profile.dart';

class UserProfileModel extends UserProfile {
  const UserProfileModel({
    required super.id,
    required super.username,
    required super.email,
    required super.fullName,
    super.bio,
    required super.skills,
    super.experienceYears,
    super.location,
    super.phoneNumber,
    super.profilePicture,
    required super.active,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    String asString(dynamic v, {String fallback = ''}) {
      if (v == null) return fallback;
      if (v is String) return v;
      return v.toString();
    }

    int? asInt(dynamic v) {
      if (v == null) return null;
      if (v is int) return v;
      if (v is double) return v.toInt();
      return int.tryParse(v.toString());
    }

    List<String> asStringList(dynamic v) {
      if (v == null) return <String>[];
      if (v is List) {
        return v.map((e) => e.toString()).toList();
      }
      return <String>[];
    }

    try {
      // Debug log the incoming JSON
      print('Parsing UserProfileModel from JSON: $json');

      // Extract user object if it exists at the root level
      final userData = json['user'] is Map<String, dynamic>
          ? json['user'] as Map<String, dynamic>
          : json;

      final profile = UserProfileModel(
        id: asString(userData['id']),
        username: asString(userData['username']),
        email: asString(userData['email']),
        fullName: asString(userData['full_name']),
        bio: userData['bio']?.toString(),
        skills: asStringList(userData['skills']),
        experienceYears: asInt(userData['experience_years']),
        location: userData['location']?.toString(),
        phoneNumber: userData['phone_number']?.toString(),
        profilePicture: userData['profile_picture']?.toString(),
        active:
            userData['is_active'] == true ||
            userData['active'] == true ||
            userData['is_active'] == 1 ||
            userData['active'] == 1 ||
            userData['is_active'] == 'true' ||
            userData['active'] == 'true',
      );

      print('Successfully parsed UserProfileModel: $profile');
      return profile;
    } catch (e) {
      print('Error parsing UserProfileModel: $e');
      rethrow;
    }
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'user': {
        'full_name': fullName,
        'bio': bio,
        'skills': skills,
        'experience_years': experienceYears,
        'location': location,
        'phone_number': phoneNumber,
        'profile_picture': profilePicture,
      },
    };
  }

  UserProfileModel copyWith({
    String? id,
    String? username,
    String? email,
    String? fullName,
    String? bio,
    List<String>? skills,
    int? experienceYears,
    String? location,
    String? phoneNumber,
    String? profilePicture,
    bool? active,
  }) {
    return UserProfileModel(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      bio: bio ?? this.bio,
      skills: skills ?? this.skills,
      experienceYears: experienceYears ?? this.experienceYears,
      location: location ?? this.location,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profilePicture: profilePicture ?? this.profilePicture,
      active: active ?? this.active,
    );
  }
}
