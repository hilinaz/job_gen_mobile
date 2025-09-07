import 'dart:typed_data';

import 'package:job_gen_mobile/core/error/failures.dart';
import 'package:job_gen_mobile/core/utils/either.dart';
import 'package:job_gen_mobile/features/user_profile/domain/repositories/user_profile_repository.dart';

class GetProfilePicture {
  final UserProfileRepository repository;

  GetProfilePicture(this.repository);

  Future<Either<Failure, Uint8List>> call() async {
    return await repository.getProfilePicture();
  }
}
