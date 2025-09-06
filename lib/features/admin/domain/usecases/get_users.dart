import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/admin_repository.dart';

class GetUsers implements UseCase<PaginatedUsers, GetUsersParams> {
  final AdminRepository repository;

  GetUsers(this.repository);

  @override
  Future<Either<Failure, PaginatedUsers>> call(GetUsersParams params) {
    return repository.getUsers(
      page: params.page,
      limit: params.limit,
      search: params.search,
      role: params.role,
      active: params.active,
      sortBy: params.sortBy,
      sortOrder: params.sortOrder,
    );
  }
}

class GetUsersParams {
  final int page;
  final int limit;
  final String? search;
  final String? role;
  final bool? active;
  final String? sortBy;
  final String? sortOrder;

  GetUsersParams({
    required this.page,
    required this.limit,
    this.search,
    this.role,
    this.active,
    this.sortBy,
    this.sortOrder,
  });
}
