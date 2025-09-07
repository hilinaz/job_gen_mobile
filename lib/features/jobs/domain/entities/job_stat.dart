class JobStats {
  final int totalJobs;
  final List<String> topSkills;
  final Map<String, int> jobsBySource;

  JobStats({
    required this.totalJobs,
    required this.topSkills,
    required this.jobsBySource,
  });
}
