
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
    super.profilePicture,
    required super.active,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      fullName: json['full_name'],
      bio: json['bio'],
      skills: List<String>.from(json['skills'] ?? []),
      experienceYears: json['experience_years'],
      location: json['location'],
      profilePicture: json['profile_picture'],
      active: json['active'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'full_name': fullName,
      'bio': bio,
      'skills': skills,
      'experience_years': experienceYears,
      'location': location,
      'profile_picture': profilePicture,
    };
  }
}