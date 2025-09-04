// import 'package:dio/dio.dart';

// import '../../../../core/errors/exceptions.dart';
// import '../models/user_profile_model.dart';

// abstract class UserProfileRemoteDataSource {
//   Future<UserProfileModel> getUserProfile();
//   Future<UserProfileModel> updateUserProfile(UserProfileModel userProfile);
//   Future<void> deleteAccount();
// }

// class UserProfileRemoteDataSourceImpl implements UserProfileRemoteDataSource {
//   final Dio dio;

//   UserProfileRemoteDataSourceImpl({required this.dio});

//   @override
//   Future<UserProfileModel> getUserProfile() async {
//     try {
//       final response = await dio.get('/users/profile');
      
//       if (response.statusCode == 200) {
//         return UserProfileModel.fromJson(response.data['data']);
//       } else {
//         throw ServerException(message: response.data['message'] ?? 'Failed to get user profile');
//       }
//     } on DioException catch (e) {
//       throw ServerException(message: e.response?.data['message'] ?? 'Network error');
//     }
//   }

//   @override
//   Future<UserProfileModel> updateUserProfile(UserProfileModel userProfile) async {
//     try {
//       final response = await dio.put(
//         '/users/profile',
//         data: userProfile.toJson(),
//       );
      
//       if (response.statusCode == 200) {
//         return UserProfileModel.fromJson(response.data['data']);
//       } else {
//         throw ServerException(message: response.data['message'] ?? 'Failed to update profile');
//       }
//     } on DioException catch (e) {
//       throw ServerException(message: e.response?.data['message'] ?? 'Network error');
//     }
//   }

//   @override
//   Future<void> deleteAccount() async {
//     try {
//       final response = await dio.delete('/users/account');
      
//       if (response.statusCode != 200) {
//         throw ServerException(message: response.data['message'] ?? 'Failed to delete account');
//       }
//     } on DioException catch (e) {
//       throw ServerException(message: e.response?.data['message'] ?? 'Network error');
//     }
//   }
// }