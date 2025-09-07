import 'package:mocktail/mocktail.dart';
import 'package:job_gen_mobile/features/files/domain/entities/jg_file.dart';
import 'package:job_gen_mobile/features/files/domain/repositories/file_repository.dart';

class MockFileRepository extends Mock implements FileRepository {}

final tFile = JgFile(
  id: '123',
  userId: 'user-1',
  uniqueId: 'unique-key',
  fileName: 'doc.pdf',
  bucketName: 'documents',
  contentType: 'application/pdf',
  size: 2000,
  createdAt: DateTime.now(),
  updatedAt: DateTime.now(),
);
