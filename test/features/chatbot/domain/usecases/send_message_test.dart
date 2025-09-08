import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:job_gen_mobile/features/chatbot/domain/entities/chat_request.dart';
import 'package:job_gen_mobile/features/chatbot/domain/entities/chat_response.dart';
import 'package:job_gen_mobile/features/chatbot/domain/entities/chat_message.dart';
import 'package:job_gen_mobile/features/chatbot/domain/entities/suggestion.dart';
import 'package:job_gen_mobile/features/chatbot/domain/repositories/chat_repository.dart';
import 'package:job_gen_mobile/features/chatbot/domain/usecases/send_message.dart';

class MockChatRepository extends Mock implements ChatRepository {}

void main() {
  late MockChatRepository mockRepo;
  late SendMessage usecase;

  setUp(() {
    mockRepo = MockChatRepository();
    usecase = SendMessage(mockRepo);
  });

  test('should return ChatResponse from repository', () async {
    final request = ChatRequest(message: 'Hello');
    final response = ChatResponse(
      sessionId: 'abc123',
      message: 'Hi!',
      history: [
        ChatMessage(
          id: '1',
          sessionId: 'abc123',
          role: 'user',
          content: 'Hello',
          timestamp: DateTime.now(),
        ),
        ChatMessage(
          id: '2',
          sessionId: 'abc123',
          role: 'assistant',
          content: 'Hi!',
          timestamp: DateTime.now(),
        ),
      ],
      suggestions: [
        Suggestion(type: 'cv_improvement', content: 'Add metrics', applied: false),
      ],
    );

    when(() => mockRepo.sendMessage(request)).thenAnswer((_) async => response);

    final result = await usecase(request);

    expect(result.sessionId, 'abc123');
    expect(result.message, 'Hi!');
    expect(result.history.length, 2);
    expect(result.suggestions.first.type, 'cv_improvement');
    verify(() => mockRepo.sendMessage(request)).called(1);
    verifyNoMoreInteractions(mockRepo);
  });
}
