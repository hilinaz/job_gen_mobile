import 'package:job_gen_mobile/core/error/exceptions.dart';
import 'package:job_gen_mobile/core/error/failures.dart';
import 'package:job_gen_mobile/core/utils/either.dart';
import 'package:job_gen_mobile/features/user_profile/data/models/user_profile_model.dart';
import 'package:job_gen_mobile/features/user_profile/domain/entity/user_profile.dart';
import 'package:job_gen_mobile/features/user_profile/data/datasource/user_profile_remote_data_source.dart';
import 'package:job_gen_mobile/features/user_profile/domain/repositories/user_profile_repository.dart';
import 'package:job_gen_mobile/core/network/network_info.dart';

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
        final updatedProfileModel = UserProfileModel(
          id: currentProfile.id,
          username: currentProfile.username,
          email: currentProfile.email,
          fullName: fullName ?? currentProfile.fullName,
          bio: bio ?? currentProfile.bio,
          skills: skills ?? currentProfile.skills,
          experienceYears: experienceYears ?? currentProfile.experienceYears,
          location: location ?? currentProfile.location,
          profilePicture: profilePicture ?? currentProfile.profilePicture,
          active: currentProfile.active,
        );

        final updatedProfile = await remoteDataSource.updateUserProfile(
          updatedProfileModel,
        );
        return Right(updatedProfile);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
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
