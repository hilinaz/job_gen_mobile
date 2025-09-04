import 'package:job_gen_mobile/features/user_profile/domain/entity/user_profile.dart';



abstract class UserProfileRepository {
Future<UserProfile> getProfile();
Future<UserProfile> updateProfile({
String? fullName,
String? bio,
String? location,
String? phoneNumber,
String? profilePicture,
int? experienceYears,
List<String>? skills,
});
Future<void> deleteAccount();
}