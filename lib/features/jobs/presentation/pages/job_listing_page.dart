import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_gen_mobile/features/jobs/data/models/job_model.dart';
import 'package:job_gen_mobile/features/jobs/presentation/bloc/jobs_bloc.dart';
import 'package:job_gen_mobile/features/auth/presentaion/bloc/auth_bloc.dart';
import 'package:job_gen_mobile/core/utils/role_manager.dart';
import '../widgets/widget.dart';

enum SearchType { keyword, skill }

class JobListingPage extends StatefulWidget {
  const JobListingPage({super.key});

  @override
  State<JobListingPage> createState() => _JobListingPageState();
}

class _JobListingPageState extends State<JobListingPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _skills = [];
  late TabController _tabController;
  bool _isSearching = false;
  SearchType _searchType = SearchType.keyword;
  List<JobModel> _cachedTrending = [];
  List<JobModel> _cachedMatched = [];
  List<JobModel> _cachedAll = [];
  final ScrollController _allScroll = ScrollController();
  int _allPage = 1;
  bool _isLoadingMoreAll = false;
  bool _isAdmin = false; // Add this line to track admin status

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_onTabChanged);

    // Check if user is admin
    _checkAdminRole();

    // Load Trending on open
    context.read<JobsBloc>().add(GetTrendingJobsEvent());
    _allScroll.addListener(_onAllScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _allScroll.dispose();
    _tabController.dispose();
    super.dispose();
  }

  // Add this method to check admin role
  Future<void> _checkAdminRole() async {
    final isAdmin = await RoleManager.hasAdminAccess();
    if (mounted) {
      setState(() {
        _isAdmin = isAdmin;
      });
    }
  }

  void _onAllScroll() {
    if (_tabController.index != 2) return; // Only on All tab
    if (_isLoadingMoreAll) return;
    if (!_allScroll.hasClients) return;
    final pos = _allScroll.position;
    if (pos.pixels >= pos.maxScrollExtent - 200) {
      _isLoadingMoreAll = true;
      _allPage += 1;
      context.read<JobsBloc>().add(GetJobsEvent(page: _allPage, limit: 10));
      Future.delayed(const Duration(milliseconds: 300), () {
        _isLoadingMoreAll = false;
      });
    }
  }

  Future<void> _handleLogout() async {
    // Show a quick confirmation and then dispatch logout
    context.read<AuthBloc>().add(SignOutEvent());
    // Wait a short moment to avoid visible loading loop on current page
    await Future.delayed(const Duration(milliseconds: 150));
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, '/sign_in', (route) => false);
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) return;
    final bloc = context.read<JobsBloc>();
    switch (_tabController.index) {
      case 0: // Trending
        bloc.add(GetTrendingJobsEvent());
        break;
      case 1: // For You
        bloc.add(GetMatchedJobsEvent());
        break;
      case 2: // All
        bloc.add(GetJobsEvent());
        break;
    }
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) _searchController.clear();
    });
  }

  void _addSkill(String skill) {
    if (skill.isNotEmpty && !_skills.contains(skill)) {
      setState(() {
        _skills.add(skill);
      });
      _searchController.clear();
      context.read<JobsBloc>().add(GetJobsBySkillsEvent(skills: _skills));
    }
  }

  void _removeSkill(String skill) {
    setState(() {
      _skills.remove(skill);
    });
    context.read<JobsBloc>().add(GetJobsBySkillsEvent(skills: _skills));
  }

  void _onSearchSubmitted(String value) {
    if (_searchType == SearchType.skill) {
      _addSkill(value.trim());
    } else if (_searchType == SearchType.keyword && value.isNotEmpty) {
      context.read<JobsBloc>().add(
        GetJobsBySearchEvent(searchParam: value.trim()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF7BBFB3),
        elevation: 0,
        titleSpacing: 0,
        leadingWidth: 120,
        leading: Padding(
          padding: const EdgeInsets.fromLTRB(6, 7, 4, 3),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const Center(
                  child: Text(
                    'O',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'JobGen',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.menu, color: Colors.white),
            color: Colors.white,
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            onSelected: (value) async {
              switch (value) {
                case 'profile':
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Profile coming soon')),
                  );
                  break;
                case 'jobstats':
                  if (!mounted) return;
                  Navigator.pushNamed(context, '/job_stats');
                  break;
                case 'chatbot':
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Chatbot coming soon')),
                  );
                  break;
                case 'admin_dashboard':
                  if (!mounted) return;
                  Navigator.pushNamed(context, '/admin_dashboard');
                  break;
                case 'logout':
                  await _handleLogout();
                  break;
              }
            },
            itemBuilder: (context) {
              final menuItems = <PopupMenuEntry<String>>[
                PopupMenuItem(
                  value: 'profile',
                  child: SizedBox(
                    width: 220,
                    child: Row(
                      children: const [
                        Icon(Icons.person_outline, color: Colors.black87),
                        SizedBox(width: 12),
                        Text('Profile'),
                      ],
                    ),
                  ),
                ),
                PopupMenuItem(
                  value: 'jobstats',
                  child: SizedBox(
                    width: 220,
                    child: Row(
                      children: const [
                        Icon(Icons.bar_chart_outlined, color: Colors.black87),
                        SizedBox(width: 12),
                        Text('Job Stats'),
                      ],
                    ),
                  ),
                ),
                PopupMenuItem(
                  value: 'chatbot',
                  child: SizedBox(
                    width: 220,
                    child: Row(
                      children: const [
                        Icon(Icons.chat_bubble_outline, color: Colors.black87),
                        SizedBox(width: 12),
                        Text('Chatbot'),
                      ],
                    ),
                  ),
                ),
              ];

              // Add admin dashboard option if user is admin
              if (_isAdmin) {
                menuItems.add(
                  PopupMenuItem(
                    value: 'admin_dashboard',
                    child: SizedBox(
                      width: 220,
                      child: Row(
                        children: const [
                          Icon(Icons.admin_panel_settings, color: Colors.blue),
                          SizedBox(width: 12),
                          Text('Admin Dashboard'),
                        ],
                      ),
                    ),
                  ),
                );
              }
              
              // Add divider and logout option
              menuItems.add(const PopupMenuDivider());
              menuItems.add(
                PopupMenuItem(
                  value: 'logout',
                  child: SizedBox(
                    width: 220,
                    child: Row(
                      children: const [
                        Icon(Icons.logout, color: Colors.redAccent),
                        SizedBox(width: 12),
                        Text('Logout'),
                      ],
                    ),
                  ),
                ),
              );

              return menuItems;
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header + Skills
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Find your next job',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'A curated list of job openings for you',
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
                const SizedBox(height: 16),
                if (_skills.isNotEmpty)
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: _skills
                        .map(
                          (skill) => Chip(
                            label: Text(skill),
                            onDeleted: () => _removeSkill(skill),
                            deleteIcon: const Icon(Icons.close),
                            backgroundColor: const Color(0xFFB8E0C8),
                            labelStyle: const TextStyle(color: Colors.black87),
                          ),
                        )
                        .toList(),
                  ),
              ],
            ),
          ),
          // Search bar + icon + search type selector
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    autofocus: _isSearching,
                    decoration: InputDecoration(
                      hintText: _searchType == SearchType.keyword
                          ? 'Search by keyword...'
                          : 'Add a skill...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 0,
                      ),
                    ),
                    onSubmitted: _onSearchSubmitted,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: Icon(_isSearching ? Icons.close : Icons.search),
                  onPressed: () => _onSearchSubmitted(_searchController.text),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: DropdownButton<SearchType>(
                    value: _searchType,
                    underline: const SizedBox(),
                    items: const [
                      DropdownMenuItem(
                        value: SearchType.keyword,
                        child: Text('Keyword'),
                      ),
                      DropdownMenuItem(
                        value: SearchType.skill,
                        child: Text('Skill'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _searchType = value;
                          _searchController.clear();
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Colors.grey),
          // Tabs
          TabBar(
            controller: _tabController,
            labelColor: const Color(0xFF1F4529),
            unselectedLabelColor: Colors.grey,
            indicatorColor: const Color(0xFF1F4529),
            tabs: const [
              Tab(text: 'Trending'),
              Tab(text: 'For You'),
              Tab(text: 'All'),
            ],
          ),

          Expanded(
            child: MultiBlocListener(
              listeners: [
                // Only keep caching for All (pagination). For You handled via bloc fallback
                BlocListener<JobsBloc, JobsState>(
                  listenWhen: (p, c) => c is GotJobsState,
                  listener: (context, state) {
                    final s = state as GotJobsState;
                    final existingIds = _cachedAll.map((e) => e.id).toSet();
                    final merged = [
                      ..._cachedAll,
                      ...s.jobs.where((j) => !existingIds.contains(j.id)),
                    ];
                    _cachedAll = merged;
                  },
                ),
              ],
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildJobsTabFromState(
                    selector: (state) => state is GotTrendingJobsState
                        ? state.jobs
                        : const <JobModel>[],
                  ),
                  _buildJobsTabFromState(
                    selector: (state) {
                      if (state is GotMatchedJobsState) return state.jobs;
                      if (state is GotJobsState)
                        return state.jobs; // fallback to all
                      return const <JobModel>[];
                    },
                  ),
                  _buildJobsTab(
                    dataProvider: () => _cachedAll,
                    controller: _allScroll,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Generic builder for a jobs tab
  Widget _buildJobsTab({
    required List<JobModel> Function() dataProvider,
    ScrollController? controller,
  }) {
    return BlocBuilder<JobsBloc, JobsState>(
      builder: (context, state) {
        final jobs = dataProvider();
        if (jobs.isEmpty) {
          if (state is JobLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is JobFetchingErrorState) {
            return Center(child: Text(state.message));
          }
        }
        final filteredJobs = _filterJobs(jobs);

        if (filteredJobs.isEmpty) {
          return const Center(child: Text('No jobs found.'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: filteredJobs.length,
          controller: controller,
          itemBuilder: (context, index) {
            final job = filteredJobs[index];
            return jobListingCard(
              title: job.title,
              company: job.companyName,
              description: job.description,
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/job_detail',
                  arguments: {'id': job.id},
                );
              },
            );
          },
        );
      },
    );
  }

  /// Builder for tabs that read from bloc (Trending, For You)
  Widget _buildJobsTabFromState({
    required List<JobModel> Function(JobsState state) selector,
  }) {
    return BlocBuilder<JobsBloc, JobsState>(
      builder: (context, state) {
        if (state is JobLoadingState) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is JobFetchingErrorState) {
          return Center(child: Text(state.message));
        }
        final jobs = selector(state);
        final filteredJobs = _filterJobs(jobs);
        if (filteredJobs.isEmpty) {
          return const Center(child: Text('No jobs found.'));
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: filteredJobs.length,
          itemBuilder: (context, index) {
            final job = filteredJobs[index];
            return jobListingCard(
              title: job.title,
              company: job.companyName,
              description: job.description,
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/job_detail',
                  arguments: {'id': job.id},
                );
              },
            );
          },
        );
      },
    );
  }

  /// Filters a list of JobModel based on search type
  List<JobModel> _filterJobs(List<JobModel> jobs) {
    final query = _searchController.text.toLowerCase();

    if (_searchType == SearchType.skill && _skills.isNotEmpty) {
      return jobs.where((job) {
        return _skills.any(
          (skill) =>
              job.title.toLowerCase().contains(skill.toLowerCase()) ||
              job.description.toLowerCase().contains(skill.toLowerCase()),
        );
      }).toList();
    } else if (_searchType == SearchType.keyword && query.isNotEmpty) {
      return jobs.where((job) {
        return job.title.toLowerCase().contains(query) ||
            job.description.toLowerCase().contains(query);
      }).toList();
    }

    return jobs;
  }
}
