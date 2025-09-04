import 'package:job_gen_mobile/features/user_profile/domain/repositories/user_profile_repository.dart';

class DeleteAccount {
final UserProfileRepository repo;
DeleteAccount(this.repo);
Future<void> call() => repo.deleteAccount();
}