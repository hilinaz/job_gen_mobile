import 'chat_message.dart';
import 'suggestion.dart';

class ChatResponse {
  final String sessionId;
  final String message;
  final List<ChatMessage> history;
  final List<Suggestion> suggestions;

  const ChatResponse({
    required this.sessionId,
    required this.message,
    required this.history,
    required this.suggestions,
  });
}
