import 'package:job_gen_mobile/features/user_profile/domain/entity/user_profile.dart';
import 'package:job_gen_mobile/features/user_profile/domain/repositories/user_profile_repository.dart';

class GetUserProfile {
final UserProfileRepository repo;
GetUserProfile(this.repo);
Future<UserProfile> call() => repo.getProfile();
}