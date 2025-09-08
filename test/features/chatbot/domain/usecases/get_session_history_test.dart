import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:job_gen_mobile/features/chatbot/domain/entities/chat_message.dart';
import 'package:job_gen_mobile/features/chatbot/domain/repositories/chat_repository.dart';
import 'package:job_gen_mobile/features/chatbot/domain/usecases/get_session_history.dart';

class MockChatRepository extends Mock implements ChatRepository {}

void main() {
  late MockChatRepository mockRepo;
  late GetSessionHistory usecase;

  setUp(() {
    mockRepo = MockChatRepository();
    usecase = GetSessionHistory(mockRepo);
  });

  test('should return list of ChatMessages from repository', () async {
    final messages = [
      ChatMessage(
        id: '1',
        sessionId: 's1',
        role: 'user',
        content: 'Hello',
        timestamp: DateTime.now(),
      ),
      ChatMessage(
        id: '2',
        sessionId: 's1',
        role: 'assistant',
        content: 'Hi!',
        timestamp: DateTime.now(),
      ),
    ];

    when(() => mockRepo.getSessionHistory('s1')).thenAnswer((_) async => messages);

    final result = await usecase('s1');

    expect(result, messages);
    expect(result.first.role, 'user');
    expect(result.last.role, 'assistant');
    verify(() => mockRepo.getSessionHistory('s1')).called(1);
    verifyNoMoreInteractions(mockRepo);
  });
}
