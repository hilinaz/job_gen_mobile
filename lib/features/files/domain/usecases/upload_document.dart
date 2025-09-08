import 'package:job_gen_mobile/core/error/failures.dart';
import 'package:job_gen_mobile/core/utils/either.dart';
import 'package:job_gen_mobile/features/files/data/models/jg_file_model.dart';
import 'package:job_gen_mobile/features/files/domain/repositories/file_repository.dart';

class UploadDocument {
  final FileRepository repository;

  UploadDocument(this.repository);

  Future<Either<Failure, JgFileModel>> call({
    required String fileName,
    required String contentType,
    required List<int> bytes,
  }) async {
    print('UploadDocument use case called');
    return repository.uploadDocument(
      fileName: fileName,
      contentType: contentType,
      bytes: bytes,
    );
  }
}
