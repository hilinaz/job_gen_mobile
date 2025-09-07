import '../../domain/entities/jg_file.dart';

class JgFileModel extends JgFile {
  const JgFileModel({
    required super.id,
    required super.userId,
    required super.uniqueId,
    required super.fileName,
    required super.bucketName,
    required super.contentType,
    required super.size,
    required super.createdAt,
    required super.updatedAt,
  });

  factory JgFileModel.fromJson(Map<String, dynamic> json) {
    return JgFileModel(
      id: json['_id'] as String,
      userId: json['user_id'] as String,
      uniqueId: json['unique_id'] as String,
      fileName: json['file_name'] as String,
      bucketName: json['bucket_name'] as String,
      contentType: json['content_type'] as String,
      size: (json['size'] as num).toInt(),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'user_id': userId,
        'unique_id': uniqueId,
        'file_name': fileName,
        'bucket_name': bucketName,
        'content_type': contentType,
        'size': size,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
      };
}
