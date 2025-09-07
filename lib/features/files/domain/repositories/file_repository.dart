import '../../../../core/error/failures.dart';
import '../../../../core/utils/either.dart';
import '../entities/jg_file.dart';

abstract class FileRepository {
  Future<Either<Failure, JgFile>> uploadProfile({
    required String fileName,
    required String contentType,
    required List<int> bytes,
  });

  Future<Either<Failure, JgFile>> uploadDocument({
    required String fileName,
    required String contentType,
    required List<int> bytes,
  });

  Future<Either<Failure, String>> downloadUrl({required String fileId});

  Future<Either<Failure, String>> myProfilePictureUrl();

  Future<Either<Failure, String>> profilePictureUrlByUserId({required String userId});

  Future<Either<Failure, Unit>> deleteById({required String fileId});
}
