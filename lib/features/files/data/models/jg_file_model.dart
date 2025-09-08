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
    super.bytes,
  });

  factory JgFileModel.fromJson(Map<String, dynamic> json) {
    return JgFileModel(
      id: json['_id'] ?? '',
      userId: json['user_id'] ?? '',
      uniqueId: json['unique_id'] ?? '',
      fileName: json['file_name'] ?? '',
      bucketName: json['bucket_name'] ?? '',
      contentType: json['content_type'] ?? '',
      size: json['size'] is int
          ? json['size']
          : (json['size'] as num?)?.toInt() ?? 0,
      createdAt: DateTime.parse(
        json['created_at']?.toString() ?? DateTime.now().toString(),
      ),
      updatedAt: DateTime.parse(
        json['updated_at']?.toString() ?? DateTime.now().toString(),
      ),
    );
  }

  @override
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

  JgFile toEntity() {
    return JgFile(
      id: id,
      userId: userId,
      uniqueId: uniqueId,
      fileName: fileName,
      bucketName: bucketName,
      contentType: contentType,
      size: size,
      createdAt: createdAt,
      updatedAt: updatedAt,
      bytes: bytes,
    );
  }

  factory JgFileModel.fromEntity(JgFile file) {
    return JgFileModel(
      id: file.id,
      userId: file.userId,
      uniqueId: file.uniqueId,
      fileName: file.fileName,
      bucketName: file.bucketName,
      contentType: file.contentType,
      size: file.size,
      createdAt: file.createdAt,
      updatedAt: file.updatedAt,
      bytes: file.bytes,
    );
  }
}
