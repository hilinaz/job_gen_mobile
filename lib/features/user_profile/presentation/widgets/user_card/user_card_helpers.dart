import 'package:flutter/material.dart';
import 'package:job_gen_mobile/core/error/failures.dart';
import 'package:job_gen_mobile/features/user_profile/domain/entity/user_profile.dart';

String mapFailureToMessage(Failure failure) {
  switch (failure.runtimeType) {
    case ServerFailure:
      return 'Server error: ${failure.message}';
    case NetworkFailure:
      return 'Network error: ${failure.message}';
    default:
      return 'An error occurred: ${failure.message}';
  }
}

UserProfile createUpdatedProfileFromControllers(
  UserProfile? existingProfile,
  TextEditingController nameController,
  TextEditingController emailController,
  TextEditingController bioController,
  TextEditingController locationController,
  TextEditingController phoneController,
  TextEditingController experienceController,
  TextEditingController skillsController,
  TextEditingController profilePictureController,
) {
  int? experienceYears;
  if (experienceController.text.trim().isNotEmpty) {
    experienceYears = int.tryParse(experienceController.text.trim());
  }

  final skills = skillsController.text
      .split(',')
      .map((e) => e.trim())
      .where((e) => e.isNotEmpty)
      .toList();

  return UserProfile(
    id: existingProfile?.id ?? '',
    username:
        existingProfile?.username ?? emailController.text.split('@').first,
    email: emailController.text,
    fullName: nameController.text,
    bio: bioController.text,
    skills: skills.isNotEmpty ? skills : (existingProfile?.skills ?? []),
    experienceYears: experienceYears ?? existingProfile?.experienceYears,
    location: locationController.text.isNotEmpty
        ? locationController.text
        : existingProfile?.location,
    phoneNumber: phoneController.text.isNotEmpty
        ? phoneController.text
        : existingProfile?.phoneNumber,
    profilePicture: profilePictureController.text.isNotEmpty
        ? profilePictureController.text
        : existingProfile?.profilePicture,
    active: existingProfile?.active ?? true,
  );
}
