import 'package:flutter_test/flutter_test.dart';
import 'package:job_gen_mobile/features/auth/data/models/user_model.dart';

void main() {
  const model = UserModel(
    id: '1',
    email: 'e@mail.com',
    username: 'user1',
    fullName: 'Test User',
    role: 'user',
    active: true,
  );

  final json = {
    '_id': '1',
    'email': 'e@mail.com',
    'username': 'user1',
    'full_name': 'Test User',
    'role': 'user',
    'active': true,
  };

  test('fromJson should create UserModel', () {
    final result = UserModel.fromJson(json);
    expect(result.id, '1');
    expect(result.fullName, 'Test User');
  });

  test('toJson should return correct map', () {
    final result = model.toJson();
    expect(result['_id'], '1');
    expect(result['role'], 'user');
  });
}
