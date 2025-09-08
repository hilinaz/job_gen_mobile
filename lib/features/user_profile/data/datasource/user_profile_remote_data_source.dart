import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:job_gen_mobile/core/constants/endpoints.dart';
import 'package:job_gen_mobile/core/error/exceptions.dart';
import '../models/user_profile_model.dart';

abstract class UserProfileRemoteDataSource {
  Future<UserProfileModel> getUserProfile();
  Future<UserProfileModel> updateUserProfile(UserProfileModel userProfile);
  Future<void> deleteAccount();
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
      // Create a complete request data object with all fields
      // Always include all fields, even if they haven't changed
      final requestData = {
        'full_name': userProfile.fullName,
        'bio': userProfile.bio ?? '', // Send empty string if null
        'skills': userProfile.skills,
        'experience_years': userProfile.experienceYears,
        'location': userProfile.location ?? '',
        'phone_number': userProfile.phoneNumber ?? '',
        'profile_picture': userProfile.profilePicture ?? '',
      };

      print('Sending update profile request to: ${Endpoints.updateProfile}');
      print('Complete request data: $requestData');

      final response = await dio.put(
        Endpoints.updateProfile,
        data: requestData,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          validateStatus: (status) =>
              status! < 500, // Accept all status codes < 500
        ),
      );

      print('Update profile response status: ${response.statusCode}');
      print('Raw response data: ${response.data}');

      if (response.statusCode == 200) {
        // The response might be in data['data'] or directly in the response
        final responseData = response.data is Map ? response.data : {};
        final data = responseData['data'] ?? responseData;

        if (data == null) {
          throw const ServerException('Empty response from server');
        }

        print('Processing response data: $data');

        // Handle case where the user data might be nested under 'user' key
        final userData = data is Map && data['user'] != null
            ? data['user'] as Map<String, dynamic>
            : data as Map<String, dynamic>;

        print('Extracted user data: $userData');

        // Create the updated profile from the response
        final updatedProfile = UserProfileModel.fromJson(userData);
        print('Successfully created updated profile: $updatedProfile');

        return updatedProfile;
      } else {
        // Handle error response
        final errorMessage = response.data is Map
            ? response.data['message']?.toString() ??
                  response.data['error']?.toString() ??
                  'Failed to update profile'
            : 'Failed to update profile (status: ${response.statusCode})';

        throw ServerException(errorMessage);
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
}
