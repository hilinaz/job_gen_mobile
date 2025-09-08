import 'dart:typed_data';

import 'package:job_gen_mobile/features/files/data/models/jg_file_model.dart';
import 'package:job_gen_mobile/features/files/domain/entities/jg_file.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/utils/either.dart';

abstract class FileRepository {
  Future<Either<Failure, String>> uploadProfile({
    required String fileName,
    required String contentType,
    required List<int> bytes,
  });

  Future<Either<Failure, JgFileModel>> uploadDocument({
    required String fileName,
    required String contentType,
    required List<int> bytes,
  });

  Future<Either<Failure, String>> downloadUrl({required String fileId});

  Future<Either<Failure, Uint8List>> downloadFile({required String fileId});

  Future<Either<Failure, String>> myProfilePictureUrl();

  Future<Either<Failure, String>> profilePictureUrlByUserId({
    required String userId,
  });

  Future<Either<Failure, Unit>> deleteById({required String fileId});
  
  Future<Either<Failure, List<JgFile>>> getUserFiles({
    required String userId,
    String? fileType,
  });

  Future<Either<Failure, List<JgFile>>> getCurrentUserFiles({String? fileType});
}
