import 'package:flutter/material.dart';
import 'package:job_gen_mobile/core/error/failures.dart';
import 'package:job_gen_mobile/features/files/domain/usecases/delete_file.dart';
import 'package:job_gen_mobile/features/files/domain/usecases/upload_profile_picture.dart';
import 'package:job_gen_mobile/features/user_profile/domain/entity/user_profile.dart';
import 'package:job_gen_mobile/features/user_profile/presentation/widgets/user_card/user_card.controllers.dart';

class UserCard extends StatefulWidget {
  final UserProfile? userProfile;
  final Future<void> Function(UserProfile) onSave;
  final UploadProfilePicture updateProfilePicture;
  final DeleteFileById deleteProfilePictureById;
  final String? getMyProfilePicture;

  const UserCard({
    super.key,
    this.userProfile,
    required this.onSave,
    required this.updateProfilePicture,
    required this.deleteProfilePictureById,
    required this.getMyProfilePicture,
  });

  @override
  UserCardController createState() => UserCardController();
}
