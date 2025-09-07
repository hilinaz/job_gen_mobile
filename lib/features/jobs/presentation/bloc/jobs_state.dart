part of 'jobs_bloc.dart';

sealed class JobsState extends Equatable {
  const JobsState();

  @override
  List<Object> get props => [];
}

final class JobsInitial extends JobsState {}

class GotJobsState extends JobsState {
  final List<JobModel> jobs;
  const GotJobsState({required this.jobs});
}

class GotJobsBySearchState extends JobsState {
  final List<JobModel> jobs;
  const GotJobsBySearchState({required this.jobs});
}

class GotMatchedJobsState extends JobsState {
  final List<JobModel> jobs;
  const GotMatchedJobsState({required this.jobs});
}

class GotJobsBySkillState extends JobsState {
  final List<JobModel> jobs;
  const GotJobsBySkillState({required this.jobs});
}

class GotTrendingJobsState extends JobsState {
  final List<JobModel> jobs;
  const GotTrendingJobsState({required this.jobs});
}

class GotJobByIdState extends JobsState {
  final JobModel job;
  const GotJobByIdState({required this.job});
}

class GotJobSourcesState extends JobsState {
  final List<String> jobSource;
  const GotJobSourcesState({required this.jobSource});
}

class GotJobStatusState extends JobsState {
  final JobStatsModel jobStat;
  const GotJobStatusState({required this.jobStat});
}

class JobLoadingState extends JobsState {}

class JobFetchingErrorState extends JobsState {
  final String message;
  const JobFetchingErrorState({required this.message});
}
