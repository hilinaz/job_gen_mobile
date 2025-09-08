import '../entities/chat_session.dart';
import '../repositories/chat_repository.dart';

class GetUserSessions {
  final ChatRepository repository;
  GetUserSessions(this.repository);

  Future<List<ChatSession>> call({int limit = 10, int offset = 0}) {
    return repository.getUserSessions(limit: limit, offset: offset);
  }
}
