import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/admin_repository.dart';

class TriggerJobAggregation implements UseCase<void, NoParams> {
  final AdminRepository repository;

  TriggerJobAggregation(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.triggerJobAggregation();
  }
}
