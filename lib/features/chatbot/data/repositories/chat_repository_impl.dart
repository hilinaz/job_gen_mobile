





import '../../domain/entities/chat_request.dart';
import '../../domain/entities/chat_response.dart';
import '../../domain/entities/chat_session.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_remote_datasource.dart';
import '../models/chat_request_model.dart';
import '../models/chat_response_model.dart';
import '../models/chat_session_model.dart';
import '../models/chat_message_model.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remote;
  ChatRepositoryImpl(this.remote);

  @override
  Future<ChatResponse> sendMessage(ChatRequest request) async {
    final body = ChatRequestModel(
      sessionId: request.sessionId,
      message: request.message,
      cvData: request.cvData,
    ).toJson();
    final data = await remote.sendMessage(body);
    return ChatResponseModel.fromJson(data);
  }

  @override
  Future<List<ChatSession>> getUserSessions(
      {int limit = 10, int offset = 0}) async {
    final list = await remote.getUserSessions(limit: limit, offset: offset);
    return list
        .map((e) => ChatSessionModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<ChatMessage>> getSessionHistory(String sessionId) async {
    final list = await remote.getSessionHistory(sessionId);
    return list
        .map((e) => ChatMessageModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> deleteSession(String sessionId) async {
    return remote.deleteSession(sessionId);
  }
}
