import 'package:dio/dio.dart';
import 'package:job_gen_mobile/core/constants/endpoints.dart';
import 'package:job_gen_mobile/core/network/envelope.dart';

import 'package:job_gen_mobile/features/jobs/data/datasource/job_local_datasource.dart';
import 'package:job_gen_mobile/features/jobs/data/models/job_model.dart';
import 'package:job_gen_mobile/features/jobs/data/models/job_status_model.dart';
import 'package:job_gen_mobile/features/jobs/domain/entities/job_stat.dart';

abstract class JobRemoteDatasource {
  Future<List<JobModel>> getJobs({
    int page = 1,
    int limit = 10,
   
  });

  Future<List<JobModel>> getJobsBySearch({required String searchKey});
    Future<List<JobModel>> getJobsBySkills({
    required List<String> skills,
  });
    Future<List<String>> getJobsBySource();
  Future<List<JobModel>> getMatchedJobs();

  Future<List<JobModel>> getTrendingJobs();
  Future<JobModel> getJobById({required String id});
  Future<JobStats> getJobStats();
}

class JobRemoteDataSourceImpl implements JobRemoteDatasource {
  final Dio dio;
  final JobLocalDatasourceImpl localDatasource;
  JobRemoteDataSourceImpl({required this.dio, required this.localDatasource});
  @override
  Future<JobModel> getJobById({required String id}) async {
    final req = await dio.get("${Endpoints.getJobById}/$id");

    final result = ApiEnvelope.fromJson(
      req.data as Map<String, dynamic>,
      (data) => JobModel.fromJson(Map<String, dynamic>.from(data as Map)),
    );

    if (result.data == null) {
      throw DioException(
        requestOptions: req.requestOptions,
        message: result.error?.message ?? 'Failed to fetch job with id $id',
      );
    }
    final job = result.data!;
    await localDatasource.cacheJob(job);
    return job;
  }

  @override
  Future<JobStats> getJobStats() async {
    final req = await dio.get(Endpoints.jobStats);

    final result = ApiEnvelope.fromJson(
      req.data as Map<String, dynamic>,
      (data) => JobStatsModel.fromJson(Map<String, dynamic>.from(data as Map)),
    );

    if (result.data == null) {
      throw DioException(
        requestOptions: req.requestOptions,
        message: result.error?.message,
      );
    }
    final jobStat = result.data!;
    await localDatasource.cacheJobStats(jobStat);
    return jobStat;
  }

  @override
  Future<List<JobModel>> getJobs({
    int page = 1,
    int limit = 10,
   
  }) async {
     final req = await dio.get(
      Endpoints.getJobs,
      
    );

    final result = ApiEnvelope.fromJson(
      req.data as Map<String, dynamic>,
      (data) => (data as List)
          .map((e) => JobModel.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
    );

    if (result.data == null) {
      throw DioException(
        requestOptions: req.requestOptions,
        message: result.error?.message ?? 'Failed to fetch jobs'
      );
    }

    final jobs = result.data!;
    await localDatasource.cacheJobs(jobs);
    return jobs;
  
  }

  @override
 Future<List<JobModel>> getJobsBySearch({required String searchKey}) async {
    final req = await dio.get(
      Endpoints.jobSearch,
      queryParameters: {'query': searchKey},
    );

    final result = ApiEnvelope.fromJson(
      req.data as Map<String, dynamic>,
      (data) => (data as List)
          .map((e) => JobModel.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
    );

    if (result.data == null) {
      throw DioException(
        requestOptions: req.requestOptions,
        message: result.error?.message ?? 'Failed to fetch jobs for $searchKey',
      );
    }

    final jobs = result.data!;
    return jobs;
  }


  @override
  Future<List<JobModel>> getMatchedJobs() async{
     final req = await dio.get(
      Endpoints.matchedJobs,
      
    );

    final result = ApiEnvelope.fromJson(
      req.data as Map<String, dynamic>,
      (data) => (data as List)
          .map((e) => JobModel.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
    );

    if (result.data == null) {
      throw DioException(
        requestOptions: req.requestOptions,
        message: result.error?.message ?? 'Failed to fetch jobs'
      );
    }

    final jobs = result.data!;
    await localDatasource.cacheMatchedJobs(jobs);
    return jobs;
  
  }

  @override
  Future<List<JobModel>> getTrendingJobs()async {
      final req = await dio.get(
      Endpoints.trandingJobs,
      
    );

    final result = ApiEnvelope.fromJson(
      req.data as Map<String, dynamic>,
      (data) => (data as List)
          .map((e) => JobModel.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
    );

    if (result.data == null) {
      throw DioException(
        requestOptions: req.requestOptions,
        message: result.error?.message ?? 'Failed to fetch jobs'
      );
    }

    final jobs = result.data!;
    await localDatasource.cacheTrendingJobs(jobs);
    return jobs;
  
  
  }
  
  @override
  Future<List<JobModel>> getJobsBySkills({required List<String> skills}) async{
    final skillQuery = skills.join(',');
    final req = await dio.get(
      Endpoints.jobBySkill,
      queryParameters: {'query': skillQuery},
    );

    final result = ApiEnvelope.fromJson(
      req.data as Map<String, dynamic>,
      (data) => (data as List)
          .map((e) => JobModel.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
    );

    if (result.data == null) {
      throw DioException(
        requestOptions: req.requestOptions,
        message: result.error?.message ?? 'Failed to fetch jobs for based on the skillset',
      );
    }

    final jobs = result.data!;

    return jobs;
  }
  
  @override
Future<List<String>> getJobsBySource() async {
    final req = await dio.get(
      Endpoints.jobSources, 
    );

    final result = ApiEnvelope.fromJson(
      req.data as Map<String, dynamic>,
      (data) => List<String>.from(data as List),
    );

    if (result.data == null) {
      throw DioException(
        requestOptions: req.requestOptions,
        message: result.error?.message ?? 'Failed to fetch job sources',
      );
    }

    final sources = result.data!;
    return sources;
  }

}
