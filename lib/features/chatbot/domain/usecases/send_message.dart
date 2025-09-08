import '../entities/chat_request.dart';
import '../entities/chat_response.dart';
import '../repositories/chat_repository.dart';

class SendMessage {
  final ChatRepository repository;
  SendMessage(this.repository);

  Future<ChatResponse> call(ChatRequest request) {
    return repository.sendMessage(request);
  }
}
