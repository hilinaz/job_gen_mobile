import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer' as developer;
import '../../../../../core/usecases/usecase.dart';
import '../../../domain/usecases/get_jobs.dart';
import '../../../domain/usecases/trigger_job_aggregation.dart';
import 'job_list_event.dart';
import 'job_list_state.dart';

class JobListBloc extends Bloc<JobListEvent, JobListState> {
  final GetJobs getJobs;
  final TriggerJobAggregation triggerJobAggregation;

  // Default pagination and filter values
  static const int _defaultPage = 1;
  static const int _defaultLimit = 10;

  JobListBloc({
    required this.getJobs,
    required this.triggerJobAggregation,
  }) : super(JobListInitial()) {
    on<GetJobsEvent>(_onGetJobs);
    on<RefreshJobsEvent>(_onRefreshJobs);
    on<SearchJobsEvent>(_onSearchJobs);
    on<FilterJobsByTypeEvent>(_onFilterJobsByType);
    on<FilterJobsByStatusEvent>(_onFilterJobsByStatus);
    on<SortJobsEvent>(_onSortJobs);
    on<TriggerJobAggregationEvent>(_onTriggerJobAggregation);
  }

  Future<void> _onGetJobs(GetJobsEvent event, Emitter<JobListState> emit) async {
    emit(JobListLoading());
    developer.log('JobListBloc: Getting jobs with page: ${event.page}, limit: ${event.limit}');

    final result = await getJobs(GetJobsParams(
      page: event.page,
      limit: event.limit,
      search: event.search,
      type: event.type,
      active: event.active,
      sortBy: event.sortBy,
      sortOrder: event.sortOrder,
    ));

    result.fold(
      (failure) {
        developer.log('JobListBloc: Failed to get jobs: ${failure.message}');
        emit(JobListError(message: failure.message));
      },
      (paginatedJobs) {
        developer.log('JobListBloc: Successfully got ${paginatedJobs.jobs.length} jobs');
        developer.log('JobListBloc: Pagination - total: ${paginatedJobs.total}, page: ${paginatedJobs.page}, totalPages: ${paginatedJobs.totalPages}');
        emit(JobListLoaded(
          paginatedJobs: paginatedJobs,
          searchQuery: event.search,
          typeFilter: event.type,
          activeFilter: event.active,
          sortBy: event.sortBy,
          sortOrder: event.sortOrder,
        ));
      },
    );
  }

  Future<void> _onRefreshJobs(RefreshJobsEvent event, Emitter<JobListState> emit) async {
    if (state is JobListLoaded) {
      final currentState = state as JobListLoaded;
      add(GetJobsEvent(
        page: _defaultPage,
        limit: currentState.paginatedJobs.limit,
        search: currentState.searchQuery,
        type: currentState.typeFilter,
        active: currentState.activeFilter,
        sortBy: currentState.sortBy,
        sortOrder: currentState.sortOrder,
      ));
    } else {
      add(const GetJobsEvent(
        page: _defaultPage,
        limit: _defaultLimit,
      ));
    }
  }

  Future<void> _onSearchJobs(SearchJobsEvent event, Emitter<JobListState> emit) async {
    if (state is JobListLoaded) {
      final currentState = state as JobListLoaded;
      add(GetJobsEvent(
        page: _defaultPage,
        limit: currentState.paginatedJobs.limit,
        search: event.query,
        type: currentState.typeFilter,
        active: currentState.activeFilter,
        sortBy: currentState.sortBy,
        sortOrder: currentState.sortOrder,
      ));
    } else {
      add(GetJobsEvent(
        page: _defaultPage,
        limit: _defaultLimit,
        search: event.query,
      ));
    }
  }

  Future<void> _onFilterJobsByType(FilterJobsByTypeEvent event, Emitter<JobListState> emit) async {
    if (state is JobListLoaded) {
      final currentState = state as JobListLoaded;
      add(GetJobsEvent(
        page: _defaultPage,
        limit: currentState.paginatedJobs.limit,
        search: currentState.searchQuery,
        type: event.type,
        active: currentState.activeFilter,
        sortBy: currentState.sortBy,
        sortOrder: currentState.sortOrder,
      ));
    } else {
      add(GetJobsEvent(
        page: _defaultPage,
        limit: _defaultLimit,
        type: event.type,
      ));
    }
  }

  Future<void> _onFilterJobsByStatus(FilterJobsByStatusEvent event, Emitter<JobListState> emit) async {
    if (state is JobListLoaded) {
      final currentState = state as JobListLoaded;
      add(GetJobsEvent(
        page: _defaultPage,
        limit: currentState.paginatedJobs.limit,
        search: currentState.searchQuery,
        type: currentState.typeFilter,
        active: event.active,
        sortBy: currentState.sortBy,
        sortOrder: currentState.sortOrder,
      ));
    } else {
      add(GetJobsEvent(
        page: _defaultPage,
        limit: _defaultLimit,
        active: event.active,
      ));
    }
  }

  Future<void> _onSortJobs(SortJobsEvent event, Emitter<JobListState> emit) async {
    if (state is JobListLoaded) {
      final currentState = state as JobListLoaded;
      add(GetJobsEvent(
        page: currentState.paginatedJobs.page,
        limit: currentState.paginatedJobs.limit,
        search: currentState.searchQuery,
        type: currentState.typeFilter,
        active: currentState.activeFilter,
        sortBy: event.sortBy,
        sortOrder: event.sortOrder,
      ));
    } else {
      add(GetJobsEvent(
        page: _defaultPage,
        limit: _defaultLimit,
        sortBy: event.sortBy,
        sortOrder: event.sortOrder,
      ));
    }
  }

  Future<void> _onTriggerJobAggregation(TriggerJobAggregationEvent event, Emitter<JobListState> emit) async {
    emit(JobAggregationLoading());
    developer.log('JobListBloc: Triggering job aggregation');

    final result = await triggerJobAggregation(NoParams());

    result.fold(
      (failure) {
        developer.log('JobListBloc: Failed to trigger job aggregation: ${failure.message}');
        emit(JobAggregationError(message: failure.message));
        
        // Restore previous state if it was loaded
        if (state is JobListLoaded) {
          emit(state);
        }
      },
      (_) {
        developer.log('JobListBloc: Successfully triggered job aggregation');
        emit(JobAggregationSuccess());
        
        // Refresh jobs to show newly aggregated jobs
        add(RefreshJobsEvent());
      },
    );
  }
}
