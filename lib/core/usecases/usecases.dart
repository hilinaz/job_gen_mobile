import 'package:equatable/equatable.dart';
import 'package:job_gen_mobile/core/error/failures.dart';
import 'package:job_gen_mobile/core/utils/either.dart';

// Base UseCase interface
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

// Base Params class
abstract class Params extends Equatable {
  const Params();
}

// NoParams for use cases that don't need parameters
class NoParams extends Params {
  const NoParams();

  @override
  List<Object?> get props => [];
}
