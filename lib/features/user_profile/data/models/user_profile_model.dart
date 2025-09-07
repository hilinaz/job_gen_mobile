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
    String _asString(dynamic v, {String fallback = ''}) =>
        v == null ? fallback : v.toString();

    int? _asInt(dynamic v) {
      if (v == null) return null;
      if (v is int) return v;
      return int.tryParse(v.toString());
    }

    List<String> _asStringList(dynamic v) {
      if (v == null) return <String>[];
      if (v is List) {
        return v.map((e) => e.toString()).toList();
      }
      return <String>[];
    }

    return UserProfileModel(
      id: _asString(json['id']),
      username: _asString(json['username']),
      email: _asString(json['email']),
      fullName: _asString(json['full_name']),
      bio: json['bio']?.toString(),
      skills: _asStringList(json['skills']),
      experienceYears: _asInt(json['experience_years']),
      location: json['location']?.toString(),
      phoneNumber: json['phone_number']?.toString(),
      profilePicture: json['profile_picture']?.toString(),
      active: json['active'] == true || json['active'] == 1 || json['active'] == 'true',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'full_name': fullName,
      'bio': bio,
      'skills': skills,
      'experience_years': experienceYears,
      'location': location,
      'phone_number': phoneNumber,
      'profile_picture': profilePicture,
    };
  }
}