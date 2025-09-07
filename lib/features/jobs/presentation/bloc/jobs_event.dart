part of 'jobs_bloc.dart';

sealed class JobsEvent extends Equatable {
  const JobsEvent();

  @override
  List<Object> get props => [];
}

class GetJobsEvent extends JobsEvent {
  final int page;
  final int limit;
  const GetJobsEvent({this.page = 1, this.limit = 10});
}

class GetMatchedJobsEvent extends JobsEvent {}

class GetJobsBySearchEvent extends JobsEvent {
  final String searchParam;
  const GetJobsBySearchEvent({required this.searchParam});
}

class GetJobsBySkillsEvent extends JobsEvent {
  final List<String> skills;
  const GetJobsBySkillsEvent({required this.skills});
}

class GetJobSourceEvent extends JobsEvent {}

class GetTrendingJobsEvent extends JobsEvent {}

class GetJobByIdEvent extends JobsEvent {
  final String id;
  const GetJobByIdEvent({required this.id});
}

class GetJobStatsEvent extends JobsEvent {}
