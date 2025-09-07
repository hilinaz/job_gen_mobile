import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_gen_mobile/features/jobs/data/models/job_status_model.dart';
import 'package:job_gen_mobile/features/jobs/presentation/bloc/jobs_bloc.dart';
import 'package:job_gen_mobile/features/auth/presentaion/bloc/auth_bloc.dart';

class JobStatsPage extends StatefulWidget {
  const JobStatsPage({super.key});

  @override
  State<JobStatsPage> createState() => _JobStatsPageState();
}

class _JobStatsPageState extends State<JobStatsPage> {
  @override
  void initState() {
    super.initState();
    context.read<JobsBloc>().add(GetJobStatsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF7BBFB3),
        elevation: 0,
        title: const Text(
          'Job Stats',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
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
                case 'jobs':
                  if (!mounted) return;
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/job_listing',
                    (route) => false,
                  );
                  break;
                case 'profile':
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Profile coming soon')),
                  );
                  break;
                case 'chatbot':
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Chatbot coming soon')),
                  );
                  break;
                case 'logout':
                  await _handleLogout();
                  break;
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'jobs',
                child: SizedBox(
                  width: 220,
                  child: Row(
                    children: const [
                      Icon(Icons.work_outline, color: Colors.black87),
                      SizedBox(width: 12),
                      Text('Jobs'),
                    ],
                  ),
                ),
              ),
              const PopupMenuDivider(),
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
              const PopupMenuDivider(),
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
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: BlocBuilder<JobsBloc, JobsState>(
        builder: (context, state) {
          if (state is JobLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is JobFetchingErrorState) {
            return Center(child: Text(state.message));
          } else if (state is GotJobStatusState) {
            final stats = state.jobStat;
            final sources = stats.jobsBySource.entries.toList()
              ..sort((a, b) => b.value.compareTo(a.value));

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _statCard(
                    title: 'Total Jobs',
                    value: stats.totalJobs.toString(),
                    icon: Icons.work_outline,
                  ),
                  const SizedBox(height: 16),
                  _sectionTitle('Top Skills'),
                  const SizedBox(height: 8),
                  _skillsWrap(stats.topSkills),
                  const SizedBox(height: 16),
                  _sectionTitle('Jobs by Source'),
                  const SizedBox(height: 8),
                  _barList(sources),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Future<void> _handleLogout() async {
    context.read<AuthBloc>().add(SignOutEvent());
    await Future.delayed(const Duration(milliseconds: 150));
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, '/sign_in', (route) => false);
  }

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget _statCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFF7BBFB3),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _skillsWrap(List<String> skills) {
    if (skills.isEmpty) return const Text('No skills data');
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: skills
          .map(
            (s) => Chip(
              label: Text(s),
              backgroundColor: const Color(0xFFB8E0C8),
              labelStyle: const TextStyle(color: Colors.black87),
            ),
          )
          .toList(),
    );
  }

  Widget _barList(List<MapEntry<String, int>> items) {
    if (items.isEmpty) return const Text('No source data');
    final maxVal = items
        .map((e) => e.value)
        .fold<int>(0, (p, v) => v > p ? v : p);
    return Column(
      children: items
          .map(
            (e) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  SizedBox(
                    width: 80,
                    child: Text(
                      e.key,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black87,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Stack(
                      children: [
                        Container(
                          height: 14,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        FractionallySizedBox(
                          widthFactor: maxVal == 0 ? 0 : (e.value / maxVal),
                          child: Container(
                            height: 14,
                            decoration: BoxDecoration(
                              color: const Color(0xFF6BBAA5),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 36,
                    child: Text(
                      e.value.toString(),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}
