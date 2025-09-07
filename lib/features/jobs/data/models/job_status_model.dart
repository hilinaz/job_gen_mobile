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
      topSkills:
          (json['top_skills'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [], // default to empty list if null
      jobsBySource: Map<String, int>.from(
        (json['jobs_by_source'] as Map<String, dynamic>).map(
          (key, value) => MapEntry(key, value as int),
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
