import '../../../../core/error/failures.dart';
import '../../../../core/utils/either.dart';
import '../../domain/entities/jg_file.dart';
import '../../domain/repositories/file_repository.dart';
import '../datasources/file_remote_datasource.dart';

class FileRepositoryImpl implements FileRepository {
  final FileRemoteDataSource remote;

  FileRepositoryImpl(this.remote);

  @override
  Future<Either<Failure, JgFile>> uploadProfile({
    required String fileName,
    required String contentType,
    required List<int> bytes,
  }) async {
    try {
      final file = await remote.uploadProfile(
        fileName: fileName,
        contentType: contentType,
        bytes: bytes,
      );
      return Right(file);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, JgFile>> uploadDocument({
    required String fileName,
    required String contentType,
    required List<int> bytes,
  }) async {
    try {
      final file = await remote.uploadDocument(
        fileName: fileName,
        contentType: contentType,
        bytes: bytes,
      );
      return Right(file);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> downloadUrl({required String fileId}) async {
    try {
      final url = await remote.getDownloadUrl(fileId);
      return Right(url);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> myProfilePictureUrl() async {
    try {
      final url = await remote.getMyProfilePictureUrl();
      return Right(url);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> profilePictureUrlByUserId({
    required String userId,
  }) async {
    try {
      final url = await remote.getProfilePictureUrl(userId);
      return Right(url);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteById({required String fileId}) async {
    try {
      await remote.deleteFile(fileId);
      return Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
