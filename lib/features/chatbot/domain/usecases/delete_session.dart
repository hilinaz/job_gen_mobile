import '../repositories/chat_repository.dart';

class DeleteSession {
  final ChatRepository repository;
  DeleteSession(this.repository);

  Future<void> call(String sessionId) {
    return repository.deleteSession(sessionId);
  }
}
