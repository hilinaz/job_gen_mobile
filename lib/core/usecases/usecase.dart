import 'package:dartz/dartz.dart';
import '../error/failures.dart';

/// Base use case interface for all use cases
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

/// No parameters class for use cases that don't require parameters
class NoParams {}
