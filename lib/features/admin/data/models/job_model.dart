import '../../domain/entities/job.dart';

class JobModel extends Job {
  final bool? isSponsorshipAvailable;

  const JobModel({
    required String id,
    required String title,
    required String company,
    required String description,
    required String location,
    required String type,
    required List<String> skills,
    required int experienceYears,
    required String salaryRange,
    required DateTime postedDate,
    DateTime? deadline,
    required bool isActive,
    required String source,
    this.isSponsorshipAvailable,
  }) : super(
          id: id,
          title: title,
          company: company,
          description: description,
          location: location,
          type: type,
          skills: skills,
          experienceYears: experienceYears,
          salaryRange: salaryRange,
          postedDate: postedDate,
          deadline: deadline,
          isActive: isActive,
          source: source,
        );

  factory JobModel.fromJson(Map<String, dynamic> json) {
    return JobModel(
      id: json['id'],
      title: json['title'] ?? '',
      company: json['company_name'] ?? '', // Changed from company to company_name
      description: json['description'] ?? '',
      location: json['location'] ?? '',
      type: json['job_type'] ?? json['type'] ?? 'full-time', // Try job_type first, then type
      skills: json['extracted_skills'] != null 
          ? List<String>.from(json['extracted_skills'])
          : (json['skills'] != null 
              ? List<String>.from(json['skills'])
              : []), // Handle null extracted_skills properly
      experienceYears: json['experience_years'] ?? json['experienceYears'] ?? 0,
      salaryRange: json['salary'] ?? json['salaryRange'] ?? '', // Try salary first, then salaryRange
      postedDate: json['posted_at'] != null
          ? DateTime.parse(json['posted_at'])
          : (json['postedDate'] != null 
              ? DateTime.parse(json['postedDate'])
              : DateTime.now()),
      deadline: json['deadline'] != null ? DateTime.parse(json['deadline']) : null,
      isActive: json['is_active'] ?? json['isActive'] ?? true, // Try is_active first, then isActive
      source: json['source'] ?? 'manual',
      isSponsorshipAvailable: json['is_sponsorship_available'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'company_name': company, // Changed from company to company_name
      'description': description,
      'location': location,
      'job_type': type, // Changed from type to job_type
      'extracted_skills': skills, // Changed from skills to extracted_skills
      'experience_years': experienceYears, // Changed from experienceYears to experience_years
      'salary': salaryRange, // Changed from salaryRange to salary
      'posted_at': postedDate.toIso8601String(), // Changed from postedDate to posted_at
      'deadline': deadline?.toIso8601String(),
      'is_active': isActive, // Changed from isActive to is_active
      'source': source,
      'is_sponsorship_available': isSponsorshipAvailable ?? false,
    };
  }

  JobModel copyWith({
    String? id,
    String? title,
    String? company,
    String? description,
    String? location,
    String? type,
    List<String>? skills,
    int? experienceYears,
    String? salaryRange,
    DateTime? postedDate,
    DateTime? deadline,
    bool? isActive,
    String? source,
    bool? isSponsorshipAvailable,
  }) {
    return JobModel(
      id: id ?? this.id,
      title: title ?? this.title,
      company: company ?? this.company,
      description: description ?? this.description,
      location: location ?? this.location,
      type: type ?? this.type,
      skills: skills ?? this.skills,
      experienceYears: experienceYears ?? this.experienceYears,
      salaryRange: salaryRange ?? this.salaryRange,
      postedDate: postedDate ?? this.postedDate,
      deadline: deadline ?? this.deadline,
      isActive: isActive ?? this.isActive,
      source: source ?? this.source,
      isSponsorshipAvailable: isSponsorshipAvailable ?? this.isSponsorshipAvailable,
    );
  }
}
