import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:job_gen_mobile/features/chatbot/data/repositories/chat_repository_impl.dart';
import 'package:job_gen_mobile/features/chatbot/data/datasources/chat_remote_datasource.dart';
import 'package:job_gen_mobile/features/chatbot/domain/entities/chat_request.dart';

class MockRemote extends Mock implements ChatRemoteDataSource {}

void main() {
  late MockRemote remote;
  late ChatRepositoryImpl repo;

  setUp(() {
    remote = MockRemote();
    repo = ChatRepositoryImpl(remote);
  });

  test('sendMessage returns ChatResponse', () async {
    when(() => remote.sendMessage(any())).thenAnswer(
      (_) async => {
        'session_id': 's1',
        'message': 'Hi!',
        'history': [],
        'suggestions': [],
      },
    );

    final result = await repo.sendMessage(ChatRequest(message: 'Hello'));

    expect(result.sessionId, 's1');
    expect(result.message, 'Hi!');
  });

  test('getUserSessions returns list of ChatSessions', () async {
    when(() => remote.getUserSessions(limit: 10, offset: 0)).thenAnswer(
      (_) async => [
        {
          'id': 's1',
          'user_id': 'u1',
          'created_at': '2025-09-01T10:00:00Z',
          'updated_at': '2025-09-01T11:00:00Z',
          'message_count': 2,
          'title': 'My Session',
        }
      ],
    );

    final result = await repo.getUserSessions(limit: 10, offset: 0);

    expect(result.first.id, 's1');
    expect(result.first.title, 'My Session');
  });

  test('getSessionHistory returns list of ChatMessages', () async {
    when(() => remote.getSessionHistory('s1')).thenAnswer(
      (_) async => [
        {
          'id': '1',
          'session_id': 's1',
          'role': 'user',
          'content': 'Hello',
          'timestamp': '2025-09-01T12:00:00Z',
        }
      ],
    );

    final result = await repo.getSessionHistory('s1');

    expect(result.first.content, 'Hello');
    expect(result.first.role, 'user');
  });

  test('deleteSession delegates to remote', () async {
    when(() => remote.deleteSession('s1')).thenAnswer((_) async => {});

    await repo.deleteSession('s1');

    verify(() => remote.deleteSession('s1')).called(1);
  });
}
