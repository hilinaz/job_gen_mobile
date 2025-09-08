import '../../domain/entities/chat_request.dart';

class ChatRequestModel extends ChatRequest {
  const ChatRequestModel({
    super.sessionId,
    required super.message,
    super.cvData,
  });

  Map<String, dynamic> toJson() {
    return {
      if (sessionId != null) 'session_id': sessionId,
      'message': message,
      if (cvData != null) 'cv_data': cvData,
    };
  }
}
