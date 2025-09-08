import 'package:job_gen_mobile/core/error/failures.dart';
import 'package:job_gen_mobile/core/utils/either.dart';
import 'package:job_gen_mobile/features/files/domain/repositories/file_repository.dart';

class UploadProfilePicture {
  final FileRepository repo;
  const UploadProfilePicture(this.repo);

  Future<Either<Failure, String>> call({
    required String fileName,
    required String contentType,
    required List<int> bytes,
  }) async {
    try {
      final downloadUrl = await repo.uploadProfile(
        fileName: fileName,
        contentType: contentType,
        bytes: bytes,
      );
      return downloadUrl;
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
