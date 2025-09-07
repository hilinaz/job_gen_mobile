import 'package:equatable/equatable.dart';
import '../../../domain/entities/job.dart';

abstract class JobManagementEvent extends Equatable {
  const JobManagementEvent();

  @override
  List<Object?> get props => [];
}

class CreateJobEvent extends JobManagementEvent {
  final Job job;

  const CreateJobEvent({required this.job});

  @override
  List<Object> get props => [job];
}

class UpdateJobEvent extends JobManagementEvent {
  final String jobId;
  final Job job;

  const UpdateJobEvent({
    required this.jobId,
    required this.job,
  });

  @override
  List<Object> get props => [jobId, job];
}

class DeleteJobEvent extends JobManagementEvent {
  final String jobId;

  const DeleteJobEvent({required this.jobId});

  @override
  List<Object> get props => [jobId];
}

class ToggleJobStatusEvent extends JobManagementEvent {
  final String jobId;
  final bool isActive;

  const ToggleJobStatusEvent({
    required this.jobId,
    required this.isActive,
  });

  @override
  List<Object> get props => [jobId, isActive];
}

class ResetJobManagementEvent extends JobManagementEvent {}
