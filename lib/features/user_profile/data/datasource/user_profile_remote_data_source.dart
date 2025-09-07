import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:job_gen_mobile/core/constants/endpoints.dart';
import 'package:job_gen_mobile/core/error/exceptions.dart';
import '../models/user_profile_model.dart';

abstract class UserProfileRemoteDataSource {
  Future<UserProfileModel> getUserProfile();
  Future<UserProfileModel> updateUserProfile(UserProfileModel userProfile);
  Future<void> deleteAccount();

  // Profile picture methods
  Future<void> uploadProfilePicture(FormData formData);
  Future<void> updateProfilePicture(FormData formData);
  Future<void> deleteProfilePicture();
  Future<Uint8List> getProfilePicture();
}

class UserProfileRemoteDataSourceImpl implements UserProfileRemoteDataSource {
  final Dio dio;

  UserProfileRemoteDataSourceImpl({required this.dio});

  @override
  Future<UserProfileModel> getUserProfile() async {
    try {
      final response = await dio.get(Endpoints.getProfile);

      if (response.statusCode == 200) {
        final data = response.data['data'];
        final payload = (data is Map<String, dynamic> && data['user'] != null)
            ? data['user'] as Map<String, dynamic>
            : (data as Map<String, dynamic>);
        return UserProfileModel.fromJson(payload);
      } else {
        throw ServerException(
          response.data['message'] ?? 'Failed to get user profile',
        );
      }
    } on DioException catch (e) {
      throw ServerException(e.response?.data['message'] ?? 'Network error');
    }
  }

  @override
  Future<UserProfileModel> updateUserProfile(
    UserProfileModel userProfile,
  ) async {
    try {
      final response = await dio.put(
        Endpoints.updateProfile,
        data: userProfile.toJson(),
      );

      if (response.statusCode == 200) {
        final data = response.data['data'];
        final payload = (data is Map<String, dynamic> && data['user'] != null)
            ? data['user'] as Map<String, dynamic>
            : (data as Map<String, dynamic>);
        return UserProfileModel.fromJson(payload);
      } else {
        throw ServerException(
          response.data['message'] ?? 'Failed to update profile',
        );
      }
    } on DioException catch (e) {
      throw ServerException(e.response?.data['message'] ?? 'Network error');
    }
  }

  @override
  Future<void> deleteAccount() async {
    try {
      final response = await dio.delete(Endpoints.deleteProfile);

      if (response.statusCode != 200) {
        throw ServerException(
          response.data['message'] ?? 'Failed to delete account',
        );
      }
    } on DioException catch (e) {
      throw ServerException(e.response?.data['message'] ?? 'Network error');
    }
  }

  @override
  Future<void> uploadProfilePicture(FormData formData) async {
    try {
      final response = await dio.post(
        Endpoints.uploadProfilePicture,
        data: formData,
        options: Options(headers: {'Content-Type': 'multipart/form-data'}),
      );

      if (response.statusCode != 200) {
        throw ServerException(
          response.data['message'] ?? 'Failed to upload profile picture',
        );
      }
    } on DioException catch (e) {
      throw ServerException(e.response?.data['message'] ?? 'Network error');
    }
  }

  @override
  Future<void> updateProfilePicture(FormData formData) async {
    try {
      final response = await dio.post(
        Endpoints.updateProfilePicture,
        data: formData,
        options: Options(headers: {'Content-Type': 'multipart/form-data'}),
      );

      if (response.statusCode != 200) {
        throw ServerException(
          response.data['message'] ?? 'Failed to update profile picture',
        );
      }
    } on DioException catch (e) {
      throw ServerException(e.response?.data['message'] ?? 'Network error');
    }
  }

  @override
  Future<void> deleteProfilePicture() async {
    try {
      final response = await dio.delete(Endpoints.deleteProfilePicture);

      if (response.statusCode != 200) {
        throw ServerException(
          response.data['message'] ?? 'Failed to delete profile picture',
        );
      }
    } on DioException catch (e) {
      throw ServerException(e.response?.data['message'] ?? 'Network error');
    }
  }

  @override
  Future<Uint8List> getProfilePicture() async {
    try {
      final response = await dio.get(
        '${Endpoints.baseUrl}${Endpoints.basePath}/files/profile-picture/me',
        options: Options(
          responseType: ResponseType.bytes,
          headers: {'Accept': 'image/*'},
        ),
      );

      if (response.statusCode == 200) {
        return Uint8List.fromList(response.data);
      } else {
        throw ServerException(
          response.data?['message']?.toString() ??
              'Failed to get profile picture',
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        e.response?.data?['message']?.toString() ?? 'Network error',
      );
    }
  }
}
