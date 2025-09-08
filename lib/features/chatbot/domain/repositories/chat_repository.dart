import '../entities/chat_request.dart';
import '../entities/chat_response.dart';
import '../entities/chat_message.dart';
import '../entities/chat_session.dart';

abstract class ChatRepository {
  Future<ChatResponse> sendMessage(ChatRequest request);
  Future<List<ChatSession>> getUserSessions({int limit = 10, int offset = 0});
  Future<List<ChatMessage>> getSessionHistory(String sessionId);
  Future<void> deleteSession(String sessionId);
}
