import 'package:equatable/equatable.dart';
import '../../../domain/entities/job.dart';

abstract class JobManagementState extends Equatable {
  const JobManagementState();

  @override
  List<Object?> get props => [];
}

class JobManagementInitial extends JobManagementState {}

class JobManagementLoading extends JobManagementState {}

class JobCreationSuccess extends JobManagementState {
  final Job job;

  const JobCreationSuccess({required this.job});

  @override
  List<Object> get props => [job];
}

class JobUpdateSuccess extends JobManagementState {
  final Job job;

  const JobUpdateSuccess({required this.job});

  @override
  List<Object> get props => [job];
}

class JobDeletionSuccess extends JobManagementState {
  final String jobId;

  const JobDeletionSuccess({required this.jobId});

  @override
  List<Object> get props => [jobId];
}

class JobStatusToggleSuccess extends JobManagementState {
  final Job job;

  const JobStatusToggleSuccess({required this.job});

  @override
  List<Object> get props => [job];
}

class JobManagementError extends JobManagementState {
  final String message;
  final JobManagementOperation operation;

  const JobManagementError({
    required this.message,
    required this.operation,
  });

  @override
  List<Object> get props => [message, operation];
}

enum JobManagementOperation {
  create,
  update,
  delete,
  toggleStatus,
}
