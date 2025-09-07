import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer' as developer;
import '../../../domain/usecases/create_job.dart';
import '../../../domain/usecases/update_job.dart';
import '../../../domain/usecases/delete_job.dart';
import '../../../domain/usecases/toggle_job_status.dart';
import 'job_management_event.dart';
import 'job_management_state.dart';

class JobManagementBloc extends Bloc<JobManagementEvent, JobManagementState> {
  final CreateJob createJob;
  final UpdateJob updateJob;
  final DeleteJob deleteJob;
  final ToggleJobStatus toggleJobStatus;

  JobManagementBloc({
    required this.createJob,
    required this.updateJob,
    required this.deleteJob,
    required this.toggleJobStatus,
  }) : super(JobManagementInitial()) {
    on<CreateJobEvent>(_onCreateJob);
    on<UpdateJobEvent>(_onUpdateJob);
    on<DeleteJobEvent>(_onDeleteJob);
    on<ToggleJobStatusEvent>(_onToggleJobStatus);
    on<ResetJobManagementEvent>(_onResetJobManagement);
  }

  Future<void> _onCreateJob(CreateJobEvent event, Emitter<JobManagementState> emit) async {
    emit(JobManagementLoading());
    developer.log('JobManagementBloc: Creating new job');

    final result = await createJob(event.job);

    result.fold(
      (failure) {
        developer.log('JobManagementBloc: Failed to create job: ${failure.message}');
        emit(JobManagementError(
          message: failure.message,
          operation: JobManagementOperation.create,
        ));
      },
      (job) {
        developer.log('JobManagementBloc: Successfully created job with ID: ${job.id}');
        emit(JobCreationSuccess(job: job));
      },
    );
  }

  Future<void> _onUpdateJob(UpdateJobEvent event, Emitter<JobManagementState> emit) async {
    emit(JobManagementLoading());
    developer.log('JobManagementBloc: Updating job with ID: ${event.jobId}');

    final result = await updateJob(UpdateJobParams(
      jobId: event.jobId,
      job: event.job,
    ));

    result.fold(
      (failure) {
        developer.log('JobManagementBloc: Failed to update job: ${failure.message}');
        emit(JobManagementError(
          message: failure.message,
          operation: JobManagementOperation.update,
        ));
      },
      (job) {
        developer.log('JobManagementBloc: Successfully updated job with ID: ${job.id}');
        emit(JobUpdateSuccess(job: job));
      },
    );
  }

  Future<void> _onDeleteJob(DeleteJobEvent event, Emitter<JobManagementState> emit) async {
    emit(JobManagementLoading());
    developer.log('JobManagementBloc: Deleting job with ID: ${event.jobId}');

    final result = await deleteJob(event.jobId);

    result.fold(
      (failure) {
        developer.log('JobManagementBloc: Failed to delete job: ${failure.message}');
        emit(JobManagementError(
          message: failure.message,
          operation: JobManagementOperation.delete,
        ));
      },
      (_) {
        developer.log('JobManagementBloc: Successfully deleted job with ID: ${event.jobId}');
        emit(JobDeletionSuccess(jobId: event.jobId));
      },
    );
  }

  Future<void> _onToggleJobStatus(ToggleJobStatusEvent event, Emitter<JobManagementState> emit) async {
    emit(JobManagementLoading());
    developer.log('JobManagementBloc: Toggling job status for ID: ${event.jobId}');

    final result = await toggleJobStatus(ToggleJobStatusParams(
      jobId: event.jobId,
      isActive: event.isActive,
    ));

    result.fold(
      (failure) {
        developer.log('JobManagementBloc: Failed to toggle job status: ${failure.message}');
        emit(JobManagementError(
          message: failure.message,
          operation: JobManagementOperation.toggleStatus,
        ));
      },
      (job) {
        developer.log('JobManagementBloc: Successfully toggled job status for ID: ${job.id}');
        emit(JobStatusToggleSuccess(job: job));
      },
    );
  }

  void _onResetJobManagement(ResetJobManagementEvent event, Emitter<JobManagementState> emit) {
    emit(JobManagementInitial());
  }
}
