import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:job_gen_mobile/features/files/data/models/jg_file_model.dart';
import 'package:job_gen_mobile/features/files/domain/entities/jg_file.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/utils/either.dart';
import '../../domain/repositories/file_repository.dart';
import '../datasources/file_remote_datasource.dart';

class FileRepositoryImpl implements FileRepository {
  final FileRemoteDataSource remote;

  FileRepositoryImpl(this.remote);

  @override
  Future<Either<Failure, String>> uploadProfile({
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
  Future<Either<Failure, JgFileModel>> uploadDocument({
    required String fileName,
    required String contentType,
    required List<int> bytes,
  }) async {
    print('FileRepositoryImpl.uploadDocument: Starting document upload');
    print('FileRepositoryImpl.uploadDocument: File name: $fileName');
    print('FileRepositoryImpl.uploadDocument: Content type: $contentType');
    print('FileRepositoryImpl.uploadDocument: File size: ${bytes.length} bytes');
    
    try {
      print('FileRepositoryImpl.uploadDocument: Calling remote.uploadDocument');
      final file = await remote.uploadDocument(
        fileName: fileName,
        contentType: contentType,
        bytes: bytes,
      );
      print('FileRepositoryImpl.uploadDocument: Upload successful');
      print('FileRepositoryImpl.uploadDocument: File ID: ${file.id}');
      return Right(file);
    } catch (e, stackTrace) {
      print('FileRepositoryImpl.uploadDocument: Error during upload:');
      print('Error: $e');
      print('Stack trace: $stackTrace');
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
  Future<Either<Failure, Uint8List>> downloadFile({
    required String fileId,
  }) async {
    try {
      final url = await remote.getDownloadUrl(fileId);
      final response = await Dio().get<Uint8List>(
        url,
        options: Options(responseType: ResponseType.bytes),
      );

      if (response.statusCode == 200 && response.data != null) {
        return Right(Uint8List.fromList(response.data!));
      } else {
        return Left(ServerFailure('Failed to download file'));
      }
    } catch (e) {
      return Left(ServerFailure('Failed to download file: $e'));
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
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<JgFile>>> getUserFiles({
    required String userId,
    String? fileType,
  }) async {
    try {
      final files = await remote.getUserFiles(
        userId: userId,
        fileType: fileType,
      );
      return Right(files.map((model) => model.toEntity()).toList());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<JgFile>>> getCurrentUserFiles({
    String? fileType,
  }) async {
    try {
      final files = await remote.getCurrentUserFiles(fileType: fileType);
      return Right(files.map((model) => model.toEntity()).toList());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
