import 'package:flutter_test/flutter_test.dart';
import 'package:job_gen_mobile/features/files/data/models/jg_file_model.dart';

void main() {
  final tJson = {
    '_id': '123',
    'user_id': 'u1',
    'unique_id': 'uid-xyz',
    'file_name': 'doc.pdf',
    'bucket_name': 'documents',
    'content_type': 'application/pdf',
    'size': 2000,
    'created_at': '2025-09-07T10:00:00.000Z',
    'updated_at': '2025-09-07T10:05:00.000Z',
  };

  final tModel = JgFileModel(
    id: '123',
    userId: 'u1',
    uniqueId: 'uid-xyz',
    fileName: 'doc.pdf',
    bucketName: 'documents',
    contentType: 'application/pdf',
    size: 2000,
    createdAt: DateTime.parse('2025-09-07T10:00:00.000Z'),
    updatedAt: DateTime.parse('2025-09-07T10:05:00.000Z'),
  );

  test('fromJson should return correct model', () {
    final result = JgFileModel.fromJson(tJson);
    expect(result, equals(tModel));
  });

  test('toJson should return correct map', () {
    final result = tModel.toJson();
    expect(result, equals(tJson));
  });
}
