import 'package:job_gen_mobile/core/parser/html_parser.dart';
import 'package:job_gen_mobile/features/jobs/domain/entities/job.dart';

class JobModel extends Job {
  JobModel({
    required super.id,
    required super.title,
    required super.companyName,
    required super.location,
    required super.description,
    required super.applyUrl,
    required super.source,
    required super.postedAt,
    required super.isSponsorshipAvailable,
    required super.extractedSkills,
    required super.createdAt,
    required super.updatedAt,
    required super.remoteOkId,
    required super.salary,
    required super.tags,
  });

  factory JobModel.fromJson(Map<String, dynamic> json) {
    return JobModel(
      id: (json['id'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      companyName: (json['company_name'] ?? 'Unknown Company').toString(),
      location: (json['location'] ?? 'Remote').toString(),
      description: HtmlParser.parse((json['description'] ?? '').toString()),
      applyUrl: (json['apply_url'] ?? '').toString(),
      source: (json['source'] ?? '').toString(),
      postedAt:
          DateTime.tryParse((json['posted_at'] ?? '').toString()) ??
          DateTime.now(),
      isSponsorshipAvailable:
          (json['is_sponsorship_available'] as bool?) ?? false,
      extractedSkills: (json['extracted_skills'] is List)
          ? List<String>.from(json['extracted_skills'] as List)
          : <String>[],
      createdAt:
          DateTime.tryParse((json['created_at'] ?? '').toString()) ??
          DateTime.now(),
      updatedAt:
          DateTime.tryParse((json['updated_at'] ?? '').toString()) ??
          DateTime.now(),
      remoteOkId: (json['remote_ok_id'] ?? '').toString(),
      salary: (json['salary'] ?? '').toString(),
      tags: (json['tags'] is List)
          ? List<String>.from(json['tags'] as List)
          : <String>[],
    );
  }

  factory JobModel.fromEntity(Job job) {
    return JobModel(
      id: job.id,
      title: job.title,
      companyName: job.companyName,
      location: job.location,
      description: job.description,
      applyUrl: job.applyUrl,
      source: job.source,
      postedAt: job.postedAt,
      isSponsorshipAvailable: job.isSponsorshipAvailable,
      extractedSkills: job.extractedSkills,
      createdAt: job.createdAt,
      updatedAt: job.updatedAt,
      remoteOkId: job.remoteOkId,
      salary: job.salary,
      tags: job.tags,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'company_name': companyName,
      'location': location,
      'description': description,
      'apply_url': applyUrl,
      'source': source,
      'posted_at': postedAt.toIso8601String(),
      'is_sponsorship_available': isSponsorshipAvailable,
      'extracted_skills': extractedSkills,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'remote_ok_id': remoteOkId,
      'salary': salary,
      'tags': tags,
    };
  }
}
