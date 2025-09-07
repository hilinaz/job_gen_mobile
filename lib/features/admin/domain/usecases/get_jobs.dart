import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/job.dart';
import '../repositories/admin_repository.dart';

class GetJobsParams {
  final int page;
  final int limit;
  final String? search;
  final String? type;
  final bool? active;
  final String? sortBy;
  final String? sortOrder;

  GetJobsParams({
    required this.page,
    required this.limit,
    this.search,
    this.type,
    this.active,
    this.sortBy,
    this.sortOrder,
  });
}

class GetJobs implements UseCase<PaginatedJobs, GetJobsParams> {
  final AdminRepository repository;

  GetJobs(this.repository);

  @override
  Future<Either<Failure, PaginatedJobs>> call(GetJobsParams params) async {
    return await repository.getJobs(
      page: params.page,
      limit: params.limit,
      search: params.search,
      type: params.type,
      active: params.active,
      sortBy: params.sortBy,
      sortOrder: params.sortOrder,
    );
  }
}
