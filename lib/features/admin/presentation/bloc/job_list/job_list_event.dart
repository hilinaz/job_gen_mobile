import 'package:equatable/equatable.dart';

abstract class JobListEvent extends Equatable {
  const JobListEvent();

  @override
  List<Object?> get props => [];
}

class GetJobsEvent extends JobListEvent {
  final int page;
  final int limit;
  final String? search;
  final String? type;
  final bool? active;
  final String? sortBy;
  final String? sortOrder;

  const GetJobsEvent({
    required this.page,
    required this.limit,
    this.search,
    this.type,
    this.active,
    this.sortBy,
    this.sortOrder,
  });

  @override
  List<Object?> get props => [page, limit, search, type, active, sortBy, sortOrder];
}

class RefreshJobsEvent extends JobListEvent {}

class SearchJobsEvent extends JobListEvent {
  final String query;

  const SearchJobsEvent(this.query);

  @override
  List<Object> get props => [query];
}

class FilterJobsByTypeEvent extends JobListEvent {
  final String? type;

  const FilterJobsByTypeEvent(this.type);

  @override
  List<Object?> get props => [type];
}

class FilterJobsByStatusEvent extends JobListEvent {
  final bool? active;

  const FilterJobsByStatusEvent(this.active);

  @override
  List<Object?> get props => [active];
}

class SortJobsEvent extends JobListEvent {
  final String sortBy;
  final String sortOrder;

  const SortJobsEvent({
    required this.sortBy,
    required this.sortOrder,
  });

  @override
  List<Object> get props => [sortBy, sortOrder];
}

class TriggerJobAggregationEvent extends JobListEvent {}
