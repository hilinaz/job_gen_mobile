class ChatSession {
  final String id;
  final String userId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int messageCount;
  final String title;

  const ChatSession({
    required this.id,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    required this.messageCount,
    required this.title,
  });
}
