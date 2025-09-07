import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:job_gen_mobile/features/user_profile/domain/entity/user_profile.dart';

@immutable
abstract class UserProfileEvent extends Equatable {
  const UserProfileEvent();

  @override
  List<Object> get props => [];
}

class LoadUserProfile extends UserProfileEvent {}

class UpdateUserProfileEvent extends UserProfileEvent {
  final UserProfile userProfile;

  const UpdateUserProfileEvent(this.userProfile);

  @override
  List<Object> get props => [userProfile];
}

class DeleteAccountEvent extends UserProfileEvent {}

class DeleteProfilePictureEvent extends UserProfileEvent {}

class GetProfilePictureEvent extends UserProfileEvent {}

class DownloadProfilePictureEvent extends UserProfileEvent {
  final String? userId;

  const DownloadProfilePictureEvent({this.userId});

  @override
  List<Object> get props => [if (userId != null) userId!];
}
