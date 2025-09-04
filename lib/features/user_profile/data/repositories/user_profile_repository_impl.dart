
// class UserProfileRepositoryImpl implements UserProfileRepository {
//   final UserProfileRemoteDataSource remoteDataSource;
//   final NetworkInfo networkInfo;

//   UserProfileRepositoryImpl({
//     required this.remoteDataSource,
//     required this.networkInfo,
//   });

//   @override
//   Future<Either<Failure, UserProfile>> getUserProfile() async {
//     if (await networkInfo.isConnected) {
//       try {
//         final remoteUserProfile = await remoteDataSource.getUserProfile();
//         return Right(remoteUserProfile);
//       } on ServerException catch (e) {
//         return Left(ServerFailure(e.message));
//       }
//     } else {
//       return Left(NetworkFailure('No internet connection'));
//     }
//   }

//   @override
//   Future<Either<Failure, UserProfile>> updateUserProfile(UserProfile userProfile) async {
//     if (await networkInfo.isConnected) {
//       try {
//         final userProfileModel = UserProfileModel(
//           id: userProfile.id,
//           username: userProfile.username,
//           email: userProfile.email,
//           fullName: userProfile.fullName,
//           bio: userProfile.bio,
//           skills: userProfile.skills,
//           experienceYears: userProfile.experienceYears,
//           location: userProfile.location,
//           profilePicture: userProfile.profilePicture,
//           active: userProfile.active,
//         );
        
//         final updatedProfile = await remoteDataSource.updateUserProfile(userProfileModel);
//         return Right(updatedProfile);
//       } on ServerException catch (e) {
//         return Left(ServerFailure(e.message));
//       }
//     } else {
//       return Left(NetworkFailure('No internet connection'));
//     }
//   }

//   @override
//   Future<Either<Failure, void>> deleteAccount() async {
//     if (await networkInfo.isConnected) {
//       try {
//         await remoteDataSource.deleteAccount();
//         return const Right(null);
//       } on ServerException catch (e) {
//         return Left(ServerFailure(e.message));
//       }
//     } else {
//       return Left(NetworkFailure('No internet connection'));
//     }
//   }
// }