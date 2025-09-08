import 'package:equatable/equatable.dart';

class UserProfile extends Equatable {
  final String id;
  final String username;
  final String email;
  final String fullName;
  final String? bio;
  final List<String> skills;
  final int? experienceYears;
  final String? location;
  final String? phoneNumber;
  final String? profilePicture;
  final bool active;

  const UserProfile({
    required this.id,
    required this.username,
    required this.email,
    required this.fullName,
    this.bio,
    this.skills = const [],
    this.experienceYears,
    this.location,
    this.phoneNumber,
    this.profilePicture,
    required this.active,
  });

  // add from json and to json
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

  @override
  List<Object?> get props => [
    id,
    username,
    email,
    fullName,
    bio,
    skills,
    experienceYears,
    location,
    phoneNumber,
    profilePicture,
    active,
  ];
}
