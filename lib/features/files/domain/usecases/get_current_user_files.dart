import 'package:job_gen_mobile/core/error/failures.dart';
import 'package:job_gen_mobile/core/usecases/usecases.dart';
import 'package:job_gen_mobile/core/utils/either.dart';
import 'package:job_gen_mobile/features/files/domain/entities/jg_file.dart';
import 'package:job_gen_mobile/features/files/domain/repositories/file_repository.dart';

class GetCurrentUserFiles implements UseCase<List<JgFile>, String?> {
  final FileRepository repository;

  const GetCurrentUserFiles(this.repository);

  @override
  Future<Either<Failure, List<JgFile>>> call(String? fileType) async {
    try {
      return await repository.getCurrentUserFiles(fileType: fileType);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
