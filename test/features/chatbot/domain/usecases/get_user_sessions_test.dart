import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:job_gen_mobile/features/chatbot/domain/entities/chat_session.dart';
import 'package:job_gen_mobile/features/chatbot/domain/repositories/chat_repository.dart';
import 'package:job_gen_mobile/features/chatbot/domain/usecases/get_user_sessions.dart';

class MockChatRepository extends Mock implements ChatRepository {}

void main() {
  late MockChatRepository mockRepo;
  late GetUserSessions usecase;

  setUp(() {
    mockRepo = MockChatRepository();
    usecase = GetUserSessions(mockRepo);
  });

  test('should return list of ChatSessions from repository', () async {
    final sessions = [
      ChatSession(
        id: 's1',
        userId: 'u1',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        messageCount: 2,
        title: 'First Session',
      ),
      ChatSession(
        id: 's2',
        userId: 'u1',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        messageCount: 5,
        title: 'Second Session',
      ),
    ];

    when(() => mockRepo.getUserSessions(limit: 10, offset: 0))
        .thenAnswer((_) async => sessions);

    final result = await usecase(limit: 10, offset: 0);

    expect(result, sessions);
    expect(result.length, 2);
    verify(() => mockRepo.getUserSessions(limit: 10, offset: 0)).called(1);
    verifyNoMoreInteractions(mockRepo);
  });
}
