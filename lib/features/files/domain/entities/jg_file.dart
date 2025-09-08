import 'dart:typed_data';
import 'package:equatable/equatable.dart';

class JgFile extends Equatable {
  final String id;
  final String userId;
  final String uniqueId;
  final String fileName;
  final String bucketName;
  final String contentType;
  final int size;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Uint8List? bytes;

  const JgFile({
    required this.id,
    required this.userId,
    required this.uniqueId,
    required this.fileName,
    required this.bucketName,
    required this.contentType,
    required this.size,
    required this.createdAt,
    required this.updatedAt,
    this.bytes,
  });

  factory JgFile.fromJson(Map<String, dynamic> json) {
    return JgFile(
      id: json['_id'] ?? '',
      userId: json['user_id'] ?? '',
      uniqueId: json['unique_id'] ?? '',
      fileName: json['file_name'] ?? '',
      bucketName: json['bucket_name'] ?? '',
      contentType: json['content_type'] ?? '',
      size: json['size'] ?? 0,
      createdAt: DateTime.parse(
        json['created_at'] ?? DateTime.now().toString(),
      ),
      updatedAt: DateTime.parse(
        json['updated_at'] ?? DateTime.now().toString(),
      ),
      bytes: null,
    );
  }

  JgFile copyWith({
    String? id,
    String? userId,
    String? uniqueId,
    String? fileName,
    String? bucketName,
    String? contentType,
    int? size,
    DateTime? createdAt,
    DateTime? updatedAt,
    Uint8List? bytes,
  }) {
    return JgFile(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      uniqueId: uniqueId ?? this.uniqueId,
      fileName: fileName ?? this.fileName,
      bucketName: bucketName ?? this.bucketName,
      contentType: contentType ?? this.contentType,
      size: size ?? this.size,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      bytes: bytes ?? this.bytes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
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

  @override
  List<Object?> get props => [
    id,
    userId,
    uniqueId,
    fileName,
    bucketName,
    contentType,
    size,
    createdAt,
    updatedAt,
    bytes,
  ];
}
