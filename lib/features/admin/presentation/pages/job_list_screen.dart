import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_gen_mobile/features/admin/presentation/bloc/job_management/job_management_bloc.dart';
import 'package:job_gen_mobile/features/admin/presentation/bloc/job_management/job_management_event.dart';
import '../bloc/job_list/job_list_bloc.dart';
import '../bloc/job_list/job_list_event.dart';
import '../bloc/job_list/job_list_state.dart';
import '../widgets/admin_app_bar.dart';
import '../widgets/custom_notification.dart';
import '../widgets/pagination_controls.dart';
import '../widgets/job_list_item.dart';
import '../../domain/entities/job.dart';

class JobListScreen extends StatefulWidget {
  const JobListScreen({Key? key}) : super(key: key);

  @override
  State<JobListScreen> createState() => _JobListScreenState();
}

class _JobListScreenState extends State<JobListScreen> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  String? _selectedType;
  bool? _selectedStatus;
  String _sortBy = 'postedDate';
  String _sortOrder = 'desc';

  @override
  void initState() {
    super.initState();
    _loadJobs();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _loadJobs() {
    print('DEBUG: _loadJobs called - triggering GetJobsEvent');
    context.read<JobListBloc>().add(const GetJobsEvent(page: 1, limit: 10));
  }

  void _onSearch(String query) {
    if (query.isNotEmpty) {
      context.read<JobListBloc>().add(SearchJobsEvent(query));
    } else {
      context.read<JobListBloc>().add(RefreshJobsEvent());
    }
  }

  void _onFilterByType(String? type) {
    setState(() {
      _selectedType = type;
    });
    context.read<JobListBloc>().add(FilterJobsByTypeEvent(type));
  }

  void _onFilterByStatus(bool? active) {
    setState(() {
      _selectedStatus = active;
    });
    context.read<JobListBloc>().add(FilterJobsByStatusEvent(active));
  }

  void _onSort(String sortBy, String sortOrder) {
    setState(() {
      _sortBy = sortBy;
      _sortOrder = sortOrder;
    });
    context.read<JobListBloc>().add(
      SortJobsEvent(sortBy: sortBy, sortOrder: sortOrder),
    );
  }

  void _onTriggerAggregation() {
    context.read<JobListBloc>().add(TriggerJobAggregationEvent());
  }

  void _editJob(Job job) {
    Navigator.pushNamed(context, '/admin/jobs/edit', arguments: job);
  }

  void _toggleJobStatus(Job job) {
    context.read<JobManagementBloc>().add(
      ToggleJobStatusEvent(jobId: job.id, isActive: !job.isActive),
    );
  }

  void _deleteJob(Job job) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Job'),
        content: Text('Are you sure you want to delete "${job.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // This would be handled by job management bloc
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Deleted ${job.title}')));
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AdminAppBar(title: 'Job Management'),
      body: Column(
        children: [
          _buildSearchAndFilters(),
          Expanded(
            child: BlocConsumer<JobListBloc, JobListState>(
              listener: (context, state) {
                if (state is JobListError) {
                  CustomNotification.show(
                    context: context,
                    message: state.message,
                    type: NotificationType.error,
                  );
                } else if (state is JobAggregationSuccess) {
                  CustomNotification.show(
                    context: context,
                    message: 'Job aggregation triggered successfully',
                    type: NotificationType.success,
                  );
                } else if (state is JobAggregationError) {
                  CustomNotification.show(
                    context: context,
                    message: state.message,
                    type: NotificationType.error,
                  );
                }
              },
              builder: (context, state) {
                if (state is JobListInitial) {
                  return const Center(child: Text('No jobs found'));
                } else if (state is JobListLoading &&
                    state is! JobAggregationLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is JobListLoaded) {
                  final jobs = state.paginatedJobs.jobs;
                  if (jobs.isEmpty) {
                    return const Center(child: Text('No jobs found'));
                  }
                  return _buildJobList(jobs, state);
                } else if (state is JobListError) {
                  return Center(child: Text('Error: ${state.message}'));
                }
                return const Center(child: Text('No jobs found'));
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'aggregateJobs',
            onPressed: _onTriggerAggregation,
            tooltip: 'Aggregate Jobs',
            child: BlocBuilder<JobListBloc, JobListState>(
              builder: (context, state) {
                if (state is JobAggregationLoading) {
                  return const CircularProgressIndicator(color: Colors.white);
                }
                return const Icon(Icons.sync);
              },
            ),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            heroTag: 'addJob',
            onPressed: () {
              Navigator.pushNamed(context, '/admin/jobs/create');
            },
            tooltip: 'Add Job',
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilters() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search jobs...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _searchController.clear();
                  _onSearch('');
                },
              ),
            ),
            onSubmitted: _onSearch,
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                // Type filter
                DropdownButton<String>(
                  hint: const Text('Job Type'),
                  value: _selectedType,
                  items:
                      <String>[
                          'full-time',
                          'part-time',
                          'contract',
                          'internship',
                          'remote',
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value
                                  .split('-')
                                  .map(
                                    (word) =>
                                        word[0].toUpperCase() +
                                        word.substring(1),
                                  )
                                  .join(' '),
                            ),
                          );
                        }).toList()
                        ..add(
                          const DropdownMenuItem<String>(
                            value: null,
                            child: Text('All Types'),
                          ),
                        ),
                  onChanged: _onFilterByType,
                ),
                const SizedBox(width: 16),
                // Status filter
                DropdownButton<bool?>(
                  hint: const Text('Status'),
                  value: _selectedStatus,
                  items: const [
                    DropdownMenuItem<bool?>(
                      value: null,
                      child: Text('All Statuses'),
                    ),
                    DropdownMenuItem<bool?>(value: true, child: Text('Active')),
                    DropdownMenuItem<bool?>(
                      value: false,
                      child: Text('Inactive'),
                    ),
                  ],
                  onChanged: _onFilterByStatus,
                ),
                const SizedBox(width: 16),
                // Sort options
                PopupMenuButton<Map<String, String>>(
                  child: Chip(
                    avatar: const Icon(Icons.sort),
                    label: Text('Sort: ${_getSortLabel()}'),
                  ),
                  onSelected: (Map<String, String> result) {
                    _onSort(result['sortBy']!, result['sortOrder']!);
                  },
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<Map<String, String>>>[
                        const PopupMenuItem<Map<String, String>>(
                          value: {'sortBy': 'postedDate', 'sortOrder': 'desc'},
                          child: Text('Newest First'),
                        ),
                        const PopupMenuItem<Map<String, String>>(
                          value: {'sortBy': 'postedDate', 'sortOrder': 'asc'},
                          child: Text('Oldest First'),
                        ),
                        const PopupMenuItem<Map<String, String>>(
                          value: {'sortBy': 'title', 'sortOrder': 'asc'},
                          child: Text('Title (A-Z)'),
                        ),
                        const PopupMenuItem<Map<String, String>>(
                          value: {'sortBy': 'title', 'sortOrder': 'desc'},
                          child: Text('Title (Z-A)'),
                        ),
                        const PopupMenuItem<Map<String, String>>(
                          value: {'sortBy': 'company', 'sortOrder': 'asc'},
                          child: Text('Company (A-Z)'),
                        ),
                        const PopupMenuItem<Map<String, String>>(
                          value: {'sortBy': 'company', 'sortOrder': 'desc'},
                          child: Text('Company (Z-A)'),
                        ),
                      ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJobList(List<Job> jobs, JobListLoaded state) {
    final totalPages = (state.paginatedJobs.total / state.paginatedJobs.limit)
        .ceil();
    final currentPage = state.paginatedJobs.page;

    // Debug pagination info
    print('DEBUG: Total jobs: ${state.paginatedJobs.total}');
    print('DEBUG: Jobs per page: ${state.paginatedJobs.limit}');
    print('DEBUG: Current page: $currentPage');
    print('DEBUG: Total pages: $totalPages');
    print('DEBUG: Jobs on current page: ${jobs.length}');

    return Column(
      children: [
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              context.read<JobListBloc>().add(RefreshJobsEvent());
            },
            child: ListView.builder(
              controller: _scrollController,
              itemCount: jobs.length,
              itemBuilder: (context, index) {
                final job = jobs[index];
                return JobListItem(
                  job: job,
                  onEdit: () => _editJob(job),
                  onToggleStatus: () => _toggleJobStatus(job),
                  onDelete: () => _deleteJob(job),
                );
              },
            ),
          ),
        ),
        // Always show pagination info for debugging
        Container(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Page $currentPage of $totalPages (${state.paginatedJobs.total} total jobs)',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ),
        if (totalPages > 1)
          PaginationControls(
            currentPage: currentPage,
            totalPages: totalPages,
            onPageChanged: (page) {
              context.read<JobListBloc>().add(
                GetJobsEvent(
                  page: page,
                  limit: state.paginatedJobs.limit,
                  search: state.searchQuery,
                  type: state.typeFilter,
                  active: state.activeFilter,
                  sortBy: state.sortBy,
                  sortOrder: state.sortOrder,
                ),
              );
            },
          ),
      ],
    );
  }

  String _getSortLabel() {
    if (_sortBy == 'postedDate' && _sortOrder == 'desc') return 'Newest';
    if (_sortBy == 'postedDate' && _sortOrder == 'asc') return 'Oldest';
    if (_sortBy == 'title' && _sortOrder == 'asc') return 'Title A-Z';
    if (_sortBy == 'title' && _sortOrder == 'desc') return 'Title Z-A';
    if (_sortBy == 'company' && _sortOrder == 'asc') return 'Company A-Z';
    if (_sortBy == 'company' && _sortOrder == 'desc') return 'Company Z-A';
    return 'Custom';
  }
}
