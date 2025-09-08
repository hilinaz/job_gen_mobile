// Create a base params class
import 'package:job_gen_mobile/features/files/domain/entities/jg_file.dart';
import 'package:job_gen_mobile/core/error/failures.dart';
import 'package:job_gen_mobile/core/utils/either.dart';
import 'package:job_gen_mobile/features/files/domain/repositories/file_repository.dart';

abstract class UseCaseParams {}

class GetUserFilesParams extends UseCaseParams {
  final String userId;
  final String? fileType;

  GetUserFilesParams({required this.userId, this.fileType});
}

// Then update your UseCase base class:
abstract class UseCase<Type, Params extends UseCaseParams> {
  Future<Either<Failure, Type>> call(Params params);
}

// And your use case:
class GetUserFiles implements UseCase<List<JgFile>, GetUserFilesParams> {
  final FileRepository repository;

  GetUserFiles(this.repository);

  @override
  Future<Either<Failure, List<JgFile>>> call(GetUserFilesParams params) {
    return repository.getUserFiles(
      userId: params.userId,
      fileType: params.fileType,
    );
  }
}
