import 'package:job_gen_mobile/core/error/failures.dart';
import 'package:job_gen_mobile/core/utils/either.dart';
import 'package:job_gen_mobile/features/user_profile/domain/entity/user_profile.dart';

abstract class UserProfileRepository {
  Future<Either<Failure, UserProfile>> getUserProfile();
  Future<Either<Failure, UserProfile>> updateUserProfile({
    String? fullName,
    String? bio,
    String? location,
    String? phoneNumber,
    String? profilePicture,
    int? experienceYears,
    List<String>? skills,
  });
  Future<Either<Failure, void>> deleteUserAccount();
}
