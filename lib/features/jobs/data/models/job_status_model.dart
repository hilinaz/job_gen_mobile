import 'package:job_gen_mobile/features/jobs/domain/entities/job_stat.dart';

class JobStatsModel extends JobStats {
  JobStatsModel({
    required super.totalJobs,
    required super.topSkills,
    required super.jobsBySource,
  });

  // Create from JSON
  factory JobStatsModel.fromJson(Map<String, dynamic> json) {
    return JobStatsModel(
      totalJobs: json['total_jobs'] as int,
      topSkills: List<String>.from(json['top_skills'] as List),
      jobsBySource: Map<String, int>.from(
        (json['jobs_by_source'] as Map).map(
          (key, value) => MapEntry(key as String, value as int),
        ),
      ),
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'total_jobs': totalJobs,
      'top_skills': topSkills,
      'jobs_by_source': jobsBySource,
    };
  }

  // Create from Entity
  factory JobStatsModel.fromEntity(JobStats entity) {
    return JobStatsModel(
      totalJobs: entity.totalJobs,
      topSkills: entity.topSkills,
      jobsBySource: entity.jobsBySource,
    );
  }
}
