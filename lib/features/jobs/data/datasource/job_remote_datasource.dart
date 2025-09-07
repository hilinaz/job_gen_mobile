import 'package:dio/dio.dart';
import 'package:job_gen_mobile/core/constants/endpoints.dart';
import 'package:job_gen_mobile/core/network/envelope.dart';
import 'package:job_gen_mobile/features/auth/data/datasources/auth_remote_datasource.dart';

import 'package:job_gen_mobile/features/jobs/data/datasource/job_local_datasource.dart';
import 'package:job_gen_mobile/features/jobs/data/models/job_model.dart';
import 'package:job_gen_mobile/features/jobs/data/models/job_status_model.dart';
import 'package:job_gen_mobile/features/jobs/domain/entities/job_stat.dart';

abstract class JobRemoteDatasource {
  Future<List<JobModel>> getJobs({int page = 1, int limit = 10});

  Future<List<JobModel>> getJobsBySearch({required String searchKey});
  Future<List<JobModel>> getJobsBySkills({required List<String> skills});
  Future<List<String>> getJobsBySource();
  Future<List<JobModel>> getMatchedJobs();

  Future<List<JobModel>> getTrendingJobs();
  Future<JobModel> getJobById({required String id});
  Future<JobStats> getJobStats();
}

class JobRemoteDataSourceImpl implements JobRemoteDatasource {
  final Dio dio;

  JobRemoteDataSourceImpl({required this.dio});
  @override
  Future<JobModel> getJobById({required String id}) async {
    final url = Endpoints.getJobById.replaceAll('{id}', id);
    print('[JobRemote] GET $url');
    final req = await dio.get(url);
    print('[JobRemote] status: ${req.statusCode}');

    final Map<String, dynamic> root = Map<String, dynamic>.from(
      req.data as Map,
    );
    final Object? maybeData = root.containsKey('data') ? root['data'] : root;
    Map<String, dynamic>? obj;
    if (maybeData is Map<String, dynamic>) {
      if (maybeData.containsKey('job') && maybeData['job'] is Map) {
        obj = Map<String, dynamic>.from(maybeData['job'] as Map);
      } else {
        obj = maybeData;
      }
    }

    if (obj == null) {
      print('[JobRemote] getJobById parse error. body: ${req.data}');
      throw DioException(
        requestOptions: req.requestOptions,
        message: 'Failed to fetch job with id $id',
      );
    }
    final job = JobModel.fromJson(obj);

    return job;
  }

  @override
Future<JobStats> getJobStats() async {
    print('[JobRemote] GET ${Endpoints.jobStats}');
    final req = await dio.get(Endpoints.jobStats);
    print('[JobRemote] status: ${req.data}');

    final Map<String, dynamic> body = req.data as Map<String, dynamic>;

    if (body['success'] != true) {
      throw DioException(
        requestOptions: req.requestOptions,
        message: body['error']?['message'] ?? 'Failed to fetch job stats',
      );
    }

    final data = body['data'] as Map<String, dynamic>;
    final jobStat = JobStatsModel.fromJson(data);

    return jobStat;
  }

  @override
  Future<List<JobModel>> getJobs({int page = 1, int limit = 10}) async {
    print('[JobRemote] GET ${Endpoints.getJobs}?page=$page&limit=$limit');
    final req = await dio.get(
      Endpoints.getJobs,
      queryParameters: {'page': page, 'limit': limit},
    );
    print('[JobRemote] status: ${req.statusCode}');

    final env = ApiEnvelope.fromJson(
      req.data as Map<String, dynamic>,
      (data) => data,
    );

    final Object? data = env.data;
    final List<dynamic> items = data is List
        ? data
        : (data is Map<String, dynamic> ? (data['items'] as List? ?? []) : []);

    print(env.data);
    final jobs = items
        .map((e) => JobModel.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();

    return jobs;
  }

  @override
  Future<List<JobModel>> getJobsBySearch({required String searchKey}) async {
    print('[JobRemote] GET ${Endpoints.jobSearch} query=$searchKey');
    final req = await dio.get(
      Endpoints.jobSearch,
      queryParameters: {'query': searchKey},
    );
    print('[JobRemote] status: ${req.data}');

    final env = ApiEnvelope.fromJson(
      req.data as Map<String, dynamic>,
      (data) => data,
    );

    final Object? data = env.data;
    final List<dynamic> items = data is List
        ? data
        : (data is Map<String, dynamic> ? (data['items'] as List? ?? []) : []);

    print(
      '[JobRemote] getJobsBySearch data shape: ${env.data.runtimeType} items: ${items.length}',
    );
    final jobs = items
        .map((e) => JobModel.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
    return jobs;
  }

  @override
  Future<List<JobModel>> getMatchedJobs() async {
    print('[JobRemote] GET ${Endpoints.matchedJobs}');
    final req = await dio.get(Endpoints.matchedJobs);
    print('[JobRemote] status: ${req.data}');

    final env = ApiEnvelope.fromJson(
      req.data as Map<String, dynamic>,
      (data) => data,
    );

    final Object? data = env.data;
    final List<dynamic> items = data is List
        ? data
        : (data is Map<String, dynamic> ? (data['items'] as List? ?? []) : []);

    print(
      '[JobRemote] getMatchedJobs data shape: ${env.data.runtimeType} items: ${items.length}',
    );
    final jobs = items
        .map((e) => JobModel.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();

    return jobs;
  }

  @override
  Future<List<JobModel>> getTrendingJobs() async {
    print('[JobRemote] GET ${Endpoints.trandingJobs}');
    final req = await dio.get(Endpoints.trandingJobs);
    print('[JobRemote] status: ${req.statusCode}');

    final env = ApiEnvelope.fromJson(
      req.data as Map<String, dynamic>,
      (data) => data,
    );

    final Object? data = env.data;
    final List<dynamic> items = data is List
        ? data
        : (data is Map<String, dynamic>
              ? ((data['items'] as List?) ?? (data['jobs'] as List?) ?? [])
              : []);

    print('treding ${env.data}');
    final jobs = items
        .map((e) => JobModel.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();

    return jobs;
  }

  @override
  Future<List<JobModel>> getJobsBySkills({required List<String> skills}) async {
    final skillQuery = skills.join(',');
    print('[JobRemote] GET ${Endpoints.jobBySkill} skills=$skillQuery');
    final req = await dio.get(
      Endpoints.jobBySkill,
      queryParameters: {'query': skillQuery},
    );
    print('[JobRemote] status: ${req.statusCode}');

    final env = ApiEnvelope.fromJson(
      req.data as Map<String, dynamic>,
      (data) => data,
    );

    final Object? data = env.data;
    final List<dynamic> items = data is List
        ? data
        : (data is Map<String, dynamic> ? (data['items'] as List? ?? []) : []);

    print(
      '[JobRemote] getJobsBySkills data shape: ${env.data.runtimeType} items: ${items.length}',
    );
    final jobs = items
        .map((e) => JobModel.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();

    return jobs;
  }

  @override
  Future<List<String>> getJobsBySource() async {
    print('[JobRemote] GET ${Endpoints.jobSources}');
    final req = await dio.get(Endpoints.jobSources);
    print('[JobRemote] status: ${req.statusCode}');

    final env = ApiEnvelope.fromJson(
      req.data as Map<String, dynamic>,
      (data) => data,
    );

    final Object? data = env.data;
    final List<dynamic> items = data is List
        ? data
        : (data is Map<String, dynamic> ? (data['items'] as List? ?? []) : []);

    print(
      '[JobRemote] getJobsBySource data shape: ${env.data.runtimeType} items: ${items.length}',
    );
    return items.map((e) => e.toString()).toList();
  }
}
