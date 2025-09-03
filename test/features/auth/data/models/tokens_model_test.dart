import 'package:flutter_test/flutter_test.dart';
import 'package:job_gen_mobile/features/auth/data/models/tokens_model.dart';

void main() {
  const model = TokensModel(accessToken: 'a', refreshToken: 'r');

  test('fromJson should create TokensModel', () {
    final json = {'access_token': 'a', 'refresh_token': 'r'};
    final result = TokensModel.fromJson(json);
    expect(result.accessToken, 'a');
    expect(result.refreshToken, 'r');
  });

  test('toJson should return correct map', () {
    final result = model.toJson();
    expect(result, {'access_token': 'a', 'refresh_token': 'r'});
  });
}
