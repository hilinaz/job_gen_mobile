import 'package:equatable/equatable.dart';

/// Job entity representing a job listing in the system
class Job extends Equatable {
  final String id;
  final String title;
  final String company;
  final String description;
  final String location;
  final String type; // full-time, part-time, contract, etc.
  final List<String> skills;
  final int experienceYears;
  final String salaryRange;
  final DateTime postedDate;
  final DateTime? deadline;
  final bool isActive;
  final String source; // manual, api, scraper, etc.

  const Job({
    required this.id,
    required this.title,
    required this.company,
    required this.description,
    required this.location,
    required this.type,
    required this.skills,
    required this.experienceYears,
    required this.salaryRange,
    required this.postedDate,
    this.deadline,
    required this.isActive,
    required this.source,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    company,
    description,
    location,
    type,
    skills,
    experienceYears,
    salaryRange,
    postedDate,
    deadline,
    isActive,
    source,
  ];
}

/// Class representing paginated jobs
class PaginatedJobs {
  final List<Job> jobs;
  final int total;
  final int page;
  final int limit;
  final int totalPages;
  final bool hasNext;
  final bool hasPrev;

  PaginatedJobs({
    required this.jobs,
    required this.total,
    required this.page,
    required this.limit,
    this.totalPages = 1,
    this.hasNext = false,
    this.hasPrev = false,
  });
}
