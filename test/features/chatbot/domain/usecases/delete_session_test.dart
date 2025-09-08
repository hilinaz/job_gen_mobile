import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:job_gen_mobile/features/chatbot/domain/repositories/chat_repository.dart';
import 'package:job_gen_mobile/features/chatbot/domain/usecases/delete_session.dart';

class MockChatRepository extends Mock implements ChatRepository {}

void main() {
  late MockChatRepository mockRepo;
  late DeleteSession usecase;

  setUp(() {
    mockRepo = MockChatRepository();
    usecase = DeleteSession(mockRepo);
  });

  test('should call repository to delete session', () async {
    when(() => mockRepo.deleteSession('s1')).thenAnswer((_) async {});

    await usecase('s1');

    verify(() => mockRepo.deleteSession('s1')).called(1);
    verifyNoMoreInteractions(mockRepo);
  });
}
