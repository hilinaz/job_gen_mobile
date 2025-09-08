class ChatRequest {
  final String? sessionId;
  final String message;
  final Map<String, dynamic>? cvData;

  const ChatRequest({
    this.sessionId,
    required this.message,
    this.cvData,
  });
}
