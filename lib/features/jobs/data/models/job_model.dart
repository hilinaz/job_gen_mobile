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
      id: json['id'] as String,
      title: json['title'] as String,
      companyName: json['company_name'] as String,
      location: json['location'] as String,
      description: HtmlParser.parse(json['description'] as String),
      applyUrl: json['apply_url'] as String,
      source: json['source'] as String,
      postedAt: DateTime.parse(json['posted_at'] as String),
      isSponsorshipAvailable: json['is_sponsorship_available'] as bool,
      extractedSkills: List<String>.from(json['extracted_skills'] as List),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      remoteOkId: json['remote_ok_id'] as String,
      salary: json['salary'] as String,
      tags: List<String>.from(json['tags'] as List),
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
