import '../entities/chat_message.dart';
import '../repositories/chat_repository.dart';

class GetSessionHistory {
  final ChatRepository repository;
  GetSessionHistory(this.repository);

  Future<List<ChatMessage>> call(String sessionId) {
    return repository.getSessionHistory(sessionId);
  }
}
