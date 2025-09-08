import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:job_gen_mobile/core/error/exceptions.dart';
import 'package:job_gen_mobile/core/error/failures.dart';
import 'package:job_gen_mobile/core/network/network_info.dart';
import 'package:job_gen_mobile/core/utils/either.dart';
import 'package:job_gen_mobile/features/user_profile/data/datasource/user_profile_remote_data_source.dart';
import 'package:job_gen_mobile/features/user_profile/data/models/user_profile_model.dart';
import 'package:job_gen_mobile/features/user_profile/domain/entity/user_profile.dart';
import 'package:job_gen_mobile/features/user_profile/domain/repositories/user_profile_repository.dart';

class UserProfileRepositoryImpl implements UserProfileRepository {
  final UserProfileRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  UserProfileRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, UserProfile>> getUserProfile() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteUserProfile = await remoteDataSource.getUserProfile();
        return Right(remoteUserProfile);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, UserProfile>> updateUserProfile({
    String? fullName,
    String? bio,
    String? location,
    String? phoneNumber,
    String? profilePicture,
    int? experienceYears,
    List<String>? skills,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        // First get the current profile to merge with updates
        final currentProfile = await remoteDataSource.getUserProfile();
        
        // Create a new UserProfileModel with the updated fields
        final updatedProfileModel = UserProfileModel(
          id: currentProfile.id,
          username: currentProfile.username,
          email: currentProfile.email,
          fullName: fullName ?? currentProfile.fullName,
          bio: bio ?? currentProfile.bio,
          skills: skills ?? currentProfile.skills,
          experienceYears: experienceYears ?? currentProfile.experienceYears,
          location: location ?? currentProfile.location,
          phoneNumber: phoneNumber ?? currentProfile.phoneNumber,
          // Ensure we use the new profile picture if provided, otherwise keep the current one
          profilePicture: profilePicture ?? currentProfile.profilePicture,
          active: currentProfile.active,
        );

        print('Updating profile with data: ${updatedProfileModel.toJson()}');
        
        final updatedProfile = await remoteDataSource.updateUserProfile(
          updatedProfileModel,
        );
        
        print('Successfully updated profile. New profile: $updatedProfile');
        return Right(updatedProfile);
      } on ServerException catch (e) {
        print('Error updating profile: ${e.message}');
        return Left(ServerFailure(e.message));
      } catch (e) {
        print('Unexpected error updating profile: $e');
        return Left(ServerFailure('An unexpected error occurred'));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteUserAccount() async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.deleteAccount();
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }
}
