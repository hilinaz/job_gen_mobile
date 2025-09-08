import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/endpoints.dart';
import '../../../../core/network/envelope.dart';
import '../../../../core/services/auth_service.dart';
import '../models/jg_file_model.dart';

abstract class FileRemoteDataSource {
  Future<String> uploadProfile({
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

  Future<List<JgFileModel>> getUserFiles({
    required String userId,
    String? fileType,
  });

  Future<List<JgFileModel>> getCurrentUserFiles({String? fileType});
}

class FileRemoteDataSourceImpl implements FileRemoteDataSource {
  final Dio dio;
  FileRemoteDataSourceImpl(this.dio);

  @override
  Future<String> uploadProfile({
    required String fileName,
    required String contentType,
    required List<int> bytes,
  }) async {
    try {
      final formData = FormData.fromMap({
        'file': MultipartFile.fromBytes(
          bytes,
          filename: fileName.split('/').last,
          contentType: MediaType.parse(contentType),
        ),
      });

      final response = await dio.post(
        Endpoints.uploadProfile,
        data: formData,
        options: Options(
          receiveTimeout: const Duration(seconds: 30),
          sendTimeout: const Duration(seconds: 30),
        ),
      );

      if (response.statusCode != 200) {
        String errorMessage =
            'Upload failed with status ${response.statusCode}';
        if (response.data is Map) {
          errorMessage =
              response.data['message'] ??
              response.data['error']?.toString() ??
              errorMessage;
        }
        throw Exception(errorMessage);
      }

      final envelope = ApiEnvelope.fromJson(
        response.data,
        (d) => JgFileModel.fromJson(d as Map<String, dynamic>),
      );

      if (envelope.data == null) {
        throw Exception(
          envelope.error?.message ??
              envelope.message ??
              'Upload failed: No data returned',
        );
      }

      final downloadUrl = await getDownloadUrl(envelope.data!.id);
      return downloadUrl;
    } on DioException catch (e) {
      rethrow;
    }
  }

  @override
  Future<JgFileModel> uploadDocument({
    required String fileName,
    required String contentType,
    required List<int> bytes,
  }) async {
    try {
      final formData = FormData.fromMap({
        'file': MultipartFile.fromBytes(
          bytes,
          filename: fileName,
          contentType: MediaType.parse(contentType),
        ),
      });

      final res = await dio.post(
        Endpoints.uploadDocument,
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
          sendTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
        ),
      );
      if (res.statusCode != 200) {
        String errorMessage = 'Upload failed with status ${res.statusCode}';
        if (res.data is Map) {
          errorMessage =
              res.data['message'] ??
              res.data['error']?.toString() ??
              errorMessage;
        }
        throw Exception(errorMessage);
      }

      if (res.data is Map<String, dynamic>) {
        final responseData = res.data as Map<String, dynamic>;

        if (responseData['success'] == true && responseData['data'] != null) {
          try {
            final fileData = responseData['data'] as Map<String, dynamic>;
            final fileModel = JgFileModel.fromJson(fileData);
            return fileModel;
          } catch (e) {
            throw Exception('Direct parsing failed: $e');
          }
        }
      }

      try {
        final envelope = ApiEnvelope.fromJson(
          res.data,
          (d) => JgFileModel.fromJson(d as Map<String, dynamic>),
        );

        if (envelope.data == null) {
          throw Exception(
            envelope.error?.message ?? envelope.message ?? 'Upload failed',
          );
        }

        return envelope.data!;
      } catch (e) {
        throw Exception('Failed to parse server response');
      }
    } on DioException catch (e) {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> getDownloadUrl(String fileId) async {
    try {
      final res = await dio.get(Endpoints.downloadFile(fileId));

      print('Download URL response: ${res.data}');

      if (res.data is Map<String, dynamic>) {
        final responseData = res.data as Map<String, dynamic>;

        // First try to get URL from 'message' field
        if (responseData['success'] == true &&
            responseData['message'] != null) {
          final url = responseData['message'] as String;
          print('Found download URL in message field: $url');
          return url;
        }

        // Then try 'data' field
        if (responseData['success'] == true && responseData['data'] != null) {
          final url = responseData['data'] as String;
          print('Found download URL in data field: $url');
          return url;
        }

        // Finally try ApiEnvelope parsing as fallback
        try {
          final envelope = ApiEnvelope.fromJson(
            responseData,
            (d) => d?.toString() ?? '',
          );

          if (envelope.data != null) {
            return envelope.data!;
          }
        } catch (e) {
          print('ApiEnvelope parsing failed: $e');
        }
      }

      throw Exception('Download URL not found in response');
    } catch (e) {
      print('Error getting download URL: $e');
      rethrow;
    }
  }

  @override
  Future<String> getMyProfilePictureUrl() async {
    try {
      final res = await dio.get(Endpoints.myProfilePic);
      final envelope = ApiEnvelope.fromJson(
        res.data,
        (d) => d?.toString() ?? '',
      );

      if (envelope.data == null) {
        throw Exception(
          envelope.error?.message ??
              envelope.message ??
              'Profile picture fetch failed',
        );
      }

      return envelope.data!;
    } catch (e) {
      print('Error getting my profile picture URL: $e');
      rethrow;
    }
  }

  @override
  Future<String> getProfilePictureUrl(String userId) async {
    try {
      final res = await dio.get(Endpoints.profilePicByUserId(userId));
      final envelope = ApiEnvelope.fromJson(
        res.data,
        (d) => d?.toString() ?? '',
      );

      if (envelope.data == null) {
        throw Exception(
          envelope.error?.message ??
              envelope.message ??
              'Profile picture fetch failed',
        );
      }

      return envelope.data!;
    } catch (e) {
      print('Error getting profile picture URL for user $userId: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteFile(String fileId) async {
    try {
      final res = await dio.delete(Endpoints.deleteFile(fileId));

      if (res.statusCode != 200) {
        // Try to get error message from response
        String errorMessage = 'Failed to delete file';
        if (res.data is Map) {
          errorMessage =
              res.data['message'] ??
              res.data['error']?.toString() ??
              errorMessage;
        }
        throw Exception(errorMessage);
      }

      // Check if response indicates success
      if (res.data is Map && res.data['success'] == false) {
        throw Exception(res.data['message'] ?? 'Delete operation failed');
      }
    } catch (e) {
      print('Error deleting file: $e');
      rethrow;
    }
  }

  @override
  Future<List<JgFileModel>> getUserFiles({
    required String userId,
    String? fileType,
  }) async {
    try {
      print('Getting files for user: $userId');

      // Get all files and filter by user ID locally
      // This assumes the /api/v1/files endpoint returns all files
      final response = await dio.get(Endpoints.files);

      final envelope = ApiEnvelope.fromJson(
        response.data,
        (json) =>
            (json as List<dynamic>?)
                ?.map(
                  (item) => JgFileModel.fromJson(item as Map<String, dynamic>),
                )
                .toList() ??
            [],
      );

      if (envelope.data == null) {
        throw Exception(
          envelope.error?.message ??
              envelope.message ??
              'Failed to fetch files',
        );
      }

      // Filter files by user ID
      final userFiles = envelope.data!
          .where((file) => file.userId == userId)
          .toList();

      // Additional filtering by file type if specified
      final filteredFiles = fileType != null
          ? userFiles.where((file) => _getFileType(file) == fileType).toList()
          : userFiles;

      print('Found ${filteredFiles.length} files for user $userId');
      return filteredFiles;
    } catch (e) {
      print('Error getting user files: $e');
      rethrow;
    }
  }

  // Helper method to determine file type from file properties
  String _getFileType(JgFileModel file) {
    if (file.contentType?.contains('pdf') == true) {
      return 'document';
    } else if (file.contentType?.contains('image') == true) {
      return 'profile_picture';
    } else if (file.bucketName == 'profile-pictures') {
      return 'profile_picture';
    } else if (file.bucketName == 'documents') {
      return 'document';
    }
    return 'other';
  }

  // Add this method to get the current user's files
  @override
  Future<List<JgFileModel>> getCurrentUserFiles({String? fileType}) async {
    try {
      // Get current user ID from your authentication system
      final currentUserId = await _getCurrentUserId();

      if (currentUserId == null) {
        throw Exception('User not authenticated');
      }

      return await getUserFiles(userId: currentUserId, fileType: fileType);
    } catch (e) {
      print('Error getting current user files: $e');
      rethrow;
    }
  }

  // Helper method to get current user ID from AuthService
  Future<String?> _getCurrentUserId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final authService = AuthService.getInstance(prefs);
      final userId = authService.currentUserId;
      
      if (userId == null) {
        print('No user is currently logged in');
      }
      
      return userId;
    } catch (e) {
      print('Error getting current user ID: $e');
      return null;
    }
  }
}
