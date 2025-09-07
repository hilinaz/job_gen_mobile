import 'dart:async';

import 'package:bloc/bloc.dart';

import 'package:equatable/equatable.dart';
import 'package:job_gen_mobile/core/usecases/usecase.dart';
import 'package:job_gen_mobile/features/jobs/data/models/job_model.dart';
import 'package:job_gen_mobile/features/jobs/data/models/job_status_model.dart';
import 'package:job_gen_mobile/features/jobs/domain/usecases/get_job.dart';
import 'package:job_gen_mobile/features/jobs/domain/usecases/get_job_by_id.dart';
import 'package:job_gen_mobile/features/jobs/domain/usecases/get_job_by_search.dart';
import 'package:job_gen_mobile/features/jobs/domain/usecases/get_job_by_skill.dart';
import 'package:job_gen_mobile/features/jobs/domain/usecases/get_job_by_source.dart';
import 'package:job_gen_mobile/features/jobs/domain/usecases/get_job_stat.dart';
import 'package:job_gen_mobile/features/jobs/domain/usecases/get_matched_jobs.dart';
import 'package:job_gen_mobile/features/jobs/domain/usecases/get_trending_jobs.dart';

part 'jobs_event.dart';
part 'jobs_state.dart';

class JobsBloc extends Bloc<JobsEvent, JobsState> {
  final GetJobs getJobs;
  final GetMatchedJobs getMatchedJobs;
  final GetTrendingJobs getTrendingJobs;
  final GetJobStat getJobStat;
  final GetJobBySearch getJobBySearch;
  final GetJobBySkill getJobBySkill;
  final GetJobBySource getJobBySource;
  final GetJobById getJobById;
  JobsBloc({
    required this.getJobs,
    required this.getMatchedJobs,
    required this.getTrendingJobs,
    required this.getJobStat,
    required this.getJobBySearch,
    required this.getJobBySkill,
    required this.getJobBySource,
    required this.getJobById,
  }) : super(JobsInitial()) {
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

    final result = await getJobs(
      GetJobsParams(page: event.page, limit: event.limit),
    );

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
  ) async {
    emit(JobLoadingState());
    final result = await getMatchedJobs(NoParams());
    await result.fold<Future<void>>(
      (failure) async {
        // Fallback to all jobs when matched is empty/fails
        final allResult = await getJobs(const GetJobsParams());
        allResult.fold(
          (_) async => emit(
            JobFetchingErrorState(
              message: 'Failed to fetch jobs for you. Please try again later',
            ),
          ),
          (jobs) async => emit(
            GotJobsState(
              jobs: jobs.map((e) => JobModel.fromEntity(e)).toList(),
            ),
          ),
        );
      },
      (jobs) async {
        final list = jobs.map((job) => JobModel.fromEntity(job)).toList();
        if (list.isEmpty) {
          final allResult = await getJobs(const GetJobsParams());
          allResult.fold(
            (_) async => emit(GotMatchedJobsState(jobs: list)),
            (allJobs) async => emit(
              GotJobsState(
                jobs: allJobs.map((e) => JobModel.fromEntity(e)).toList(),
              ),
            ),
          );
        } else {
          emit(GotMatchedJobsState(jobs: list));
        }
      },
    );
  }

  FutureOr<void> _getJobsBySearch(
    GetJobsBySearchEvent event,
    Emitter<JobsState> emit,
  ) async {
    emit(JobLoadingState());
    final result = await getJobBySearch(
      GetJobBySearchParams(searchKey: event.searchParam),
    );

    result.fold(
      (failure) {
        emit(
          JobFetchingErrorState(
            message:
                'Failed to fetch jobs that match with the search parameter. Please try again later',
          ),
        );
      },
      (jobs) {
        emit(
          GotJobsBySearchState(
            jobs: jobs.map((job) => JobModel.fromEntity(job)).toList(),
          ),
        );
      },
    );
  }

  FutureOr<void> _getJobsBySkill(
    GetJobsBySkillsEvent event,
    Emitter<JobsState> emit,
  ) async {
    emit(JobLoadingState());
    final result = await getJobBySkill(
      GetJobBySkillParams(skills: event.skills),
    );
    result.fold(
      (failure) {
        emit(
          JobFetchingErrorState(
            message:
                'Failed to fetch jobs that align with the specified skills. Please try again later',
          ),
        );
      },
      (jobs) {
        emit(
          GotJobsBySkillState(
            jobs: jobs.map((job) => JobModel.fromEntity(job)).toList(),
          ),
        );
      },
    );
  }

  FutureOr<void> _getJobSource(
    GetJobSourceEvent event,
    Emitter<JobsState> emit,
  ) async {
    emit(JobLoadingState());
    final result = await getJobBySource(NoParams());
    result.fold(
      (failure) {
        emit(
          JobFetchingErrorState(
            message:
                'Failed to load Job sources for you . Please try again later',
          ),
        );
      },
      (sources) {
        emit(GotJobSourcesState(jobSource: sources));
      },
    );
  }

  FutureOr<void> _getTrendingJobs(
    GetTrendingJobsEvent event,
    Emitter<JobsState> emit,
  ) async {
    emit(JobLoadingState());

    final result = await getTrendingJobs(NoParams());

    result.fold(
      (failure) {
        emit(
          JobFetchingErrorState(
            message:
                'Failed to fetch Trending jobs for you. Please try again later',
          ),
        );
      },
      (jobs) {
        emit(
          GotTrendingJobsState(
            jobs: jobs.map((job) => JobModel.fromEntity(job)).toList(),
          ),
        );
      },
    );
  }

  FutureOr<void> _getJobById(
    GetJobByIdEvent event,
    Emitter<JobsState> emit,
  ) async {
    emit(JobLoadingState());

    final result = await getJobById(GetJobByIdParams(id: event.id));

    result.fold(
      (failure) {
        emit(
          JobFetchingErrorState(
            message: 'Failed to Load Job detail. Please try again later',
          ),
        );
      },
      (job) {
        emit(GotJobByIdState(job: JobModel.fromEntity(job)));
      },
    );
  }

  FutureOr<void> _getJobStat(
    GetJobStatsEvent event,
    Emitter<JobsState> emit,
  ) async {
    emit(JobLoadingState());

    final result = await getJobStat(NoParams());

    result.fold(
      (failure) {
        emit(
          JobFetchingErrorState(
            message: 'Failed to load job stats. Please try again later',
          ),
        );
      },
      (jobStat) {
        emit(GotJobStatusState(jobStat: JobStatsModel.fromEntity(jobStat)));
      },
    );
  }
}
