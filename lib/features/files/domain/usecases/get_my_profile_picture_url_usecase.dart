import 'package:job_gen_mobile/core/usecases/usecases.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/utils/either.dart';
import '../repositories/file_repository.dart';

class GetMyProfilePictureUrlUsecase implements UseCase<String, NoParams> {
  final FileRepository repo;
  const GetMyProfilePictureUrlUsecase(this.repo);

  @override
  Future<Either<Failure, String>> call(NoParams params) {
    return repo.myProfilePictureUrl();
  }
}
