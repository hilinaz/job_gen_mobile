import 'package:job_gen_mobile/features/user_profile/domain/entity/user_profile.dart';
import 'package:job_gen_mobile/features/user_profile/domain/repositories/user_profile_repository.dart';

class UpdateUserProfile {
  final UserProfileRepository repo;
      UpdateUserProfile(this.repo);
      Future<UserProfile> call({
      String? fullName,
      String? bio,
      String? location,
      String? phoneNumber,
      String? profilePicture,
      int? experienceYears,
      List<String>? skills,
    }) => repo.updateProfile(
            fullName: fullName,
            bio: bio,
            location: location,
            phoneNumber: phoneNumber,
            profilePicture: profilePicture,
            experienceYears: experienceYears,
            skills: skills,
            );
}