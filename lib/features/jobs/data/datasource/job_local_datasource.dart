import 'dart:convert';
import 'package:job_gen_mobile/features/jobs/data/models/job_status_model.dart';
import 'package:job_gen_mobile/features/jobs/domain/entities/job.dart';
import 'package:job_gen_mobile/features/jobs/domain/entities/job_stat.dart';
import 'package:job_gen_mobile/features/jobs/data/models/job_model.dart';

import 'package:shared_preferences/shared_preferences.dart';

abstract class JobLocalDatasource {
  // getting cached
  Future<List<Job>> getCachedJobs();
  Future<List<Job>> getCachedMatchedJobs();
  Future<List<Job>> getCachedTrendingJobs();
  Future<JobStats?> getCachedJobStats();
  Future<Job?> getCachedJobById(String id);

  // Cache jobs
  Future<void> cacheJobs(List<Job> jobs);
  Future<void> cacheMatchedJobs(List<Job> jobs);
  Future<void> cacheTrendingJobs(List<Job> jobs);
  Future<void> cacheJob(Job job);
  Future<void> cacheJobStats(JobStats stats);

  // clear
  Future<void> clearCachedJobById(String id);
  Future<void> clearJobsCache();
  Future<void> clearMatchedJobsCache();
  Future<void> clearTrendingJobsCache();
  Future<void> clearJobStatsCache();
}

class JobLocalDatasourceImpl implements JobLocalDatasource {
  final SharedPreferences sharedPreferences;
  JobLocalDatasourceImpl({required this.sharedPreferences});

  static const _kJobsList = 'JOB_LIST';
  static const _kMatchedJobs = 'MATCHED_JOBS';
  static const _kTrendingJobs = 'TRENDING_JOBS';
  static const _kJob = 'SINGLE_JOB';
  static const _kJobStat = 'JOB_STATS';

  @override
  Future<void> cacheJobs(List<Job> jobs) async {
    final jobListJson = jobs.map((job) => (job as JobModel).toJson()).toList();
    await sharedPreferences.setString(_kJobsList, jsonEncode(jobListJson));
  }

  @override
  Future<void> cacheMatchedJobs(List<Job> jobs) async {
    final jobListJson = jobs.map((job) => (job as JobModel).toJson()).toList();
    await sharedPreferences.setString(_kMatchedJobs, jsonEncode(jobListJson));
  }

  @override
  Future<void> cacheTrendingJobs(List<Job> jobs) async {
    final jobListJson = jobs.map((job) => (job as JobModel).toJson()).toList();
    await sharedPreferences.setString(_kTrendingJobs, jsonEncode(jobListJson));
  }

  @override
  Future<void> cacheJob(Job job) async {
    await sharedPreferences.setString(
      '$_kJob-${job.id}',
      jsonEncode((job as JobModel).toJson()),
    );
  }

  @override
  Future<void> cacheJobStats(JobStats stats) async {
    await sharedPreferences.setString(
      _kJobStat,
      jsonEncode((stats as JobStatsModel).toJson()),
    );
  }

  @override
  Future<List<Job>> getCachedJobs() async {
    final jsonString = sharedPreferences.getString(_kJobsList);
    if (jsonString != null) {
      final decoded = jsonDecode(jsonString) as List;
      return decoded.map((e) => JobModel.fromJson(e)).toList();
    }
    return [];
  }

  @override
  Future<List<Job>> getCachedMatchedJobs() async {
    final jsonString = sharedPreferences.getString(_kMatchedJobs);
    if (jsonString != null) {
      final decoded = jsonDecode(jsonString) as List;
      return decoded.map((e) => JobModel.fromJson(e)).toList();
    }
    return [];
  }

  @override
  Future<List<Job>> getCachedTrendingJobs() async {
    final jsonString = sharedPreferences.getString(_kTrendingJobs);
    if (jsonString != null) {
      final decoded = jsonDecode(jsonString) as List;
      return decoded.map((e) => JobModel.fromJson(e)).toList();
    }
    return [];
  }

  @override
  Future<Job?> getCachedJobById(String id) async {
    final jsonString = sharedPreferences.getString('$_kJob-$id');
    if (jsonString != null) {
      final decoded = jsonDecode(jsonString);
      return JobModel.fromJson(decoded);
    }
    return null;
  }

  @override
  Future<JobStats?> getCachedJobStats() async {
    final jsonString = sharedPreferences.getString(_kJobStat);
    if (jsonString != null) {
      final decoded = jsonDecode(jsonString);
      return JobStatsModel.fromJson(decoded);
    }
    return null;
  }

  @override
  Future<void> clearJobsCache() async {
    await sharedPreferences.remove(_kJobsList);
  }

  @override
  Future<void> clearMatchedJobsCache() async {
    await sharedPreferences.remove(_kMatchedJobs);
  }

  @override
  Future<void> clearTrendingJobsCache() async {
    await sharedPreferences.remove(_kTrendingJobs);
  }

  @override
  Future<void> clearCachedJobById(String id) async {
    await sharedPreferences.remove('$_kJob-$id');
  }

  @override
  Future<void> clearJobStatsCache() async {
    await sharedPreferences.remove(_kJobStat);
  }
}
