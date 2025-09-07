class Job {
  final String id;
  final String title;
  final String companyName;
  final String location;
  final String description;
  final String applyUrl;
  final String source;
  final DateTime postedAt;
  final bool isSponsorshipAvailable;
  final List<String> extractedSkills;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String remoteOkId;
  final String salary;
  final List<String> tags;

  Job({
    required this.id,
    required this.title,
    required this.companyName,
    required this.location,
    required this.description,
    required this.applyUrl,
    required this.source,
    required this.postedAt,
    required this.isSponsorshipAvailable,
    required this.extractedSkills,
    required this.createdAt,
    required this.updatedAt,
    required this.remoteOkId,
    required this.salary,
    required this.tags,
  });

  // factory Job.fromJson(Map<String, dynamic> json) {
  //   return Job(
  //     id: json['id'] as String,
  //     title: json['title'] as String,
  //     companyName: json['company_name'] as String,
  //     location: json['location'] as String,
  //     description: json['description'] as String,
  //     applyUrl: json['apply_url'] as String,
  //     source: json['source'] as String,
  //     postedAt: DateTime.parse(json['posted_at']),
  //     isSponsorshipAvailable: json['is_sponsorship_available'] as bool,
  //     extractedSkills: List<String>.from(json['extracted_skills']),
  //     createdAt: DateTime.parse(json['created_at']),
  //     updatedAt: DateTime.parse(json['updated_at']),
  //     remoteOkId: json['remote_ok_id'] as String,
  //     salary: json['salary'] as String,
  //     tags: List<String>.from(json['tags']),
  //   );
  // }

  // Map<String, dynamic> toJson() {
  //   return {
  //     'id': id,
  //     'title': title,
  //     'company_name': companyName,
  //     'location': location,
  //     'description': description,
  //     'apply_url': applyUrl,
  //     'source': source,
  //     'posted_at': postedAt.toIso8601String(),
  //     'is_sponsorship_available': isSponsorshipAvailable,
  //     'extracted_skills': extractedSkills,
  //     'created_at': createdAt.toIso8601String(),
  //     'updated_at': updatedAt.toIso8601String(),
  //     'remote_ok_id': remoteOkId,
  //     'salary': salary,
  //     'tags': tags,
  //   };
  // }
}
