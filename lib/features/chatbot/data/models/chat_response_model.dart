import '../../domain/entities/chat_response.dart';
import 'chat_message_model.dart';
import 'suggestion_model.dart';

class ChatResponseModel extends ChatResponse {
  ChatResponseModel({
    required super.sessionId,
    required super.message,
    required super.history,
    required super.suggestions,
  });

  factory ChatResponseModel.fromJson(Map<String, dynamic> json) {
    return ChatResponseModel(
      sessionId: json['session_id'],
      message: json['message'],
      history: (json['history'] as List<dynamic>)
          .map((e) => ChatMessageModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      suggestions: (json['suggestions'] as List<dynamic>? ?? [])
          .map((e) => SuggestionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
