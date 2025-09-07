import 'package:equatable/equatable.dart';
import '../../../domain/entities/job.dart';

abstract class JobListState extends Equatable {
  const JobListState();

  @override
  List<Object?> get props => [];
}

class JobListInitial extends JobListState {}

class JobListLoading extends JobListState {}

class JobListLoaded extends JobListState {
  final PaginatedJobs paginatedJobs;
  final String? searchQuery;
  final String? typeFilter;
  final bool? activeFilter;
  final String? sortBy;
  final String? sortOrder;

  const JobListLoaded({
    required this.paginatedJobs,
    this.searchQuery,
    this.typeFilter,
    this.activeFilter,
    this.sortBy,
    this.sortOrder,
  });

  @override
  List<Object?> get props => [
        paginatedJobs,
        searchQuery,
        typeFilter,
        activeFilter,
        sortBy,
        sortOrder,
      ];

  JobListLoaded copyWith({
    PaginatedJobs? paginatedJobs,
    String? searchQuery,
    String? typeFilter,
    bool? activeFilter,
    String? sortBy,
    String? sortOrder,
  }) {
    return JobListLoaded(
      paginatedJobs: paginatedJobs ?? this.paginatedJobs,
      searchQuery: searchQuery ?? this.searchQuery,
      typeFilter: typeFilter ?? this.typeFilter,
      activeFilter: activeFilter ?? this.activeFilter,
      sortBy: sortBy ?? this.sortBy,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }
}

class JobListError extends JobListState {
  final String message;

  const JobListError({required this.message});

  @override
  List<Object> get props => [message];
}

class JobAggregationLoading extends JobListState {}

class JobAggregationSuccess extends JobListState {}

class JobAggregationError extends JobListState {
  final String message;

  const JobAggregationError({required this.message});

  @override
  List<Object> get props => [message];
}
