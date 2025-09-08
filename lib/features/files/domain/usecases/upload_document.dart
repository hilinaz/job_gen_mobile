import 'package:job_gen_mobile/core/error/failures.dart';
import 'package:job_gen_mobile/core/utils/either.dart';
import 'package:job_gen_mobile/features/files/data/datasources/file_remote_datasource.dart';
import 'package:job_gen_mobile/features/files/data/models/jg_file_model.dart';

class UploadDocument {
  final FileRemoteDataSource remoteDataSource;

  UploadDocument(this.remoteDataSource);

  Future<Either<Failure, JgFileModel>> call({
    required String fileName,
    required String contentType,
    required List<int> bytes,
  }) async {
    try {
      print('UploadDocument use case called');
      final fileModel = await remoteDataSource.uploadDocument(
        fileName: fileName,
        contentType: contentType,
        bytes: bytes,
      );

      print('UploadDocument success. File ID: ${fileModel.id}');
      return Right(fileModel);
    } catch (e) {
      print('UploadDocument use case error: $e');
      return Left(ServerFailure(e.toString()));
    }
  }
}
