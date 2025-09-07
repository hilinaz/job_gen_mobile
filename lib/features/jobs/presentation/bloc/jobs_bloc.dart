import 'dart:async';

import 'package:bloc/bloc.dart';

import 'package:equatable/equatable.dart';
import 'package:job_gen_mobile/features/jobs/data/models/job_model.dart';
import 'package:job_gen_mobile/features/jobs/data/models/job_status_model.dart';
import 'package:job_gen_mobile/features/jobs/domain/usecases/get_job.dart';

part 'jobs_event.dart';
part 'jobs_state.dart';

class JobsBloc extends Bloc<JobsEvent, JobsState> {
  final GetJobs getJobs;
  JobsBloc({required this.getJobs}) : super(JobsInitial()) {
    on<GetJobsEvent>(_getJobs);
    on<GetMatchedJobsEvent>(_getMatchedJobs);
    on<GetJobsBySearchEvent>(_getJobsBySearch);
    on<GetJobsBySkillsEvent>(_getJobsBySkill);
    on<GetJobSourceEvent>(_getJobSource);
    on<GetTrendingJobsEvent>(_getTrendingJobs);
    on<GetJobByIdEvent>(_getJobById);
    on<GetJobStatsEvent>(_getJobStat);
  }

  Future<void> _getJobs(GetJobsEvent event, Emitter<JobsState> emit) async {
    emit(JobLoadingState());

    final result = await getJobs(GetJobsParams());

    result.fold(
      (failure) {
        emit(
          JobFetchingErrorState(
            message: 'Failed to fetch jobs. Please try again later',
          ),
        );
      },
      (jobs) {
        emit(
          GotJobsState(
            jobs: jobs.map((job) => JobModel.fromEntity(job)).toList(),
          ),
        );
      },
    );
  }


  FutureOr<void> _getMatchedJobs(
    GetMatchedJobsEvent event,
    Emitter<JobsState> emit,
  ) {}

  FutureOr<void> _getJobsBySearch(
    GetJobsBySearchEvent event,
    Emitter<JobsState> emit,
  ) {}

  FutureOr<void> _getJobsBySkill(
    GetJobsBySkillsEvent event,
    Emitter<JobsState> emit,
  ) {}

  FutureOr<void> _getJobSource(
    GetJobSourceEvent event,
    Emitter<JobsState> emit,
  ) {}

  FutureOr<void> _getTrendingJobs(
    GetTrendingJobsEvent event,
    Emitter<JobsState> emit,
  ) {}

  FutureOr<void> _getJobById(GetJobByIdEvent event, Emitter<JobsState> emit) {}

  FutureOr<void> _getJobStat(GetJobStatsEvent event, Emitter<JobsState> emit) {}
}
