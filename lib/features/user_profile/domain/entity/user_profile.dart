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


@override
List<Object?> get props => [id, username, email, fullName, bio, skills, experienceYears, location, phoneNumber, profilePicture, active];
}