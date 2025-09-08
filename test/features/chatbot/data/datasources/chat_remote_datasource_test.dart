import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';
import 'package:job_gen_mobile/features/chatbot/data/datasources/chat_remote_datasource.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio dio;
  late ChatRemoteDataSourceImpl dataSource;

  setUp(() {
    dio = MockDio();
    dataSource = ChatRemoteDataSourceImpl(dio);
  });

  test('sendMessage returns map data', () async {
    final response = Response(
      data: {
        'data': {
          'session_id': 's1',
          'message': 'Hi!',
          'history': [],
          'suggestions': [],
        }
      },
      requestOptions: RequestOptions(path: ''),
    );

    when(() => dio.post(any(), data: any(named: 'data')))
        .thenAnswer((_) async => response);

    final result = await dataSource.sendMessage({'message': 'Hello'});

    expect(result['session_id'], 's1');
    expect(result['message'], 'Hi!');
  });

  test('getUserSessions returns list', () async {
    final response = Response(
      data: {
        'data': [
          {
            'id': 's1',
            'user_id': 'u1',
            'created_at': '2025-09-01T10:00:00Z',
            'updated_at': '2025-09-01T11:00:00Z',
            'message_count': 2,
            'title': 'My Session',
          }
        ]
      },
      requestOptions: RequestOptions(path: ''),
    );

    when(() => dio.get(any(), queryParameters: any(named: 'queryParameters')))
        .thenAnswer((_) async => response);

    final result = await dataSource.getUserSessions(limit: 10, offset: 0);

    expect(result, isA<List<dynamic>>());
    expect(result.first['id'], 's1');
  });

  test('getSessionHistory returns list', () async {
    final response = Response(
      data: {
        'data': [
          {
            'id': '1',
            'session_id': 's1',
            'role': 'user',
            'content': 'Hello',
            'timestamp': '2025-09-01T12:00:00Z',
          }
        ]
      },
      requestOptions: RequestOptions(path: ''),
    );

    when(() => dio.get(any())).thenAnswer((_) async => response);

    final result = await dataSource.getSessionHistory('s1');

    expect(result.first['content'], 'Hello');
  });

  test('deleteSession calls dio.delete', () async {
    final response = Response(
      data: {'success': true},
      requestOptions: RequestOptions(path: ''),
    );

    when(() => dio.delete(any())).thenAnswer((_) async => response);

    await dataSource.deleteSession('s1');

    verify(() => dio.delete('/api/v1/chat/session/s1')).called(1);
  });
}
