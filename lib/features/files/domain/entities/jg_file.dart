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
  });

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
      ];
}
