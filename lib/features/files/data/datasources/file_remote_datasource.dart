import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import '../../../../core/network/envelope.dart';
import '../models/jg_file_model.dart';

abstract class FileRemoteDataSource {
  Future<JgFileModel> uploadProfile({
    required String fileName,
    required String contentType,
    required List<int> bytes,
  });

  Future<JgFileModel> uploadDocument({
    required String fileName,
    required String contentType,
    required List<int> bytes,
  });

  Future<String> getDownloadUrl(String fileId);

  Future<String> getMyProfilePictureUrl();

  Future<String> getProfilePictureUrl(String userId);

  Future<void> deleteFile(String fileId);
}

class FileRemoteDataSourceImpl implements FileRemoteDataSource {
  final Dio dio;
  FileRemoteDataSourceImpl(this.dio);

  @override
  Future<JgFileModel> uploadProfile({
    required String fileName,
    required String contentType,
    required List<int> bytes,
  }) async {
    final formData = FormData.fromMap({
      'file': MultipartFile.fromBytes(
        bytes,
        filename: fileName,
        contentType: MediaType.parse(contentType),
      ),
    });

    final res = await dio.post(
      '/files/upload/profile',
      data: formData,
      options: Options(contentType: 'multipart/form-data'),
    );

    final envelope = ApiEnvelope.fromJson(
      res.data,
      (d) => JgFileModel.fromJson(d as Map<String, dynamic>),
    );
    if (envelope.data == null) {
      throw Exception(envelope.error?.message ?? 'Upload failed');
    }
    return envelope.data!;
  }

  @override
  Future<JgFileModel> uploadDocument({
    required String fileName,
    required String contentType,
    required List<int> bytes,
  }) async {
    final formData = FormData.fromMap({
      'file': MultipartFile.fromBytes(
        bytes,
        filename: fileName,
        contentType: MediaType.parse(contentType),
      ),
    });

    final res = await dio.post(
      '/files/upload/document',
      data: formData,
      options: Options(contentType: 'multipart/form-data'),
    );

    final envelope = ApiEnvelope.fromJson(
      res.data,
      (d) => JgFileModel.fromJson(d as Map<String, dynamic>),
    );
    if (envelope.data == null) {
      throw Exception(envelope.error?.message ?? 'Upload failed');
    }
    return envelope.data!;
  }

  @override
  Future<String> getDownloadUrl(String fileId) async {
    final res = await dio.get('/files/$fileId');
    final envelope = ApiEnvelope.fromJson(res.data, (d) => d?.toString() ?? '');
    if (envelope.data == null) {
      throw Exception(envelope.error?.message ?? 'Download URL fetch failed');
    }
    return envelope.data!;
  }

  @override
  Future<String> getMyProfilePictureUrl() async {
    final res = await dio.get('/files/profile-picture/me');
    final envelope = ApiEnvelope.fromJson(res.data, (d) => d?.toString() ?? '');
    if (envelope.data == null) {
      throw Exception(envelope.error?.message ?? 'Profile picture fetch failed');
    }
    return envelope.data!;
  }

  @override
  Future<String> getProfilePictureUrl(String userId) async {
    final res = await dio.get('/files/profile-picture/$userId');
    final envelope = ApiEnvelope.fromJson(res.data, (d) => d?.toString() ?? '');
    if (envelope.data == null) {
      throw Exception(envelope.error?.message ?? 'Profile picture fetch failed');
    }
    return envelope.data!;
  }

  @override
  Future<void> deleteFile(String fileId) async {
    final res = await dio.delete('/files/$fileId');
    if (res.statusCode != 200) {
      throw Exception('Failed to delete file');
    }
  }
}
