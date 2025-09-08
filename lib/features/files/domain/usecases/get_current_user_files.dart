import 'package:job_gen_mobile/core/error/failures.dart';
import 'package:job_gen_mobile/core/usecases/usecases.dart';
import 'package:job_gen_mobile/core/utils/either.dart';
import 'package:job_gen_mobile/features/files/domain/entities/jg_file.dart';
import 'package:job_gen_mobile/features/files/domain/repositories/file_repository.dart';

class GetCurrentUserFiles implements UseCase<List<JgFile>, NoParams> {
  final FileRepository repository;

  const GetCurrentUserFiles(this.repository);

  @override
  Future<Either<Failure, List<JgFile>>> call(NoParams params) async {
    try {
      return await repository.getCurrentUserFiles();
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
