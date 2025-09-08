import 'package:flutter_test/flutter_test.dart';
import 'package:job_gen_mobile/features/chatbot/data/models/chat_message_model.dart';

void main() {
  group('ChatMessageModel', () {
    test('fromJson should parse correctly', () {
      final json = {
        'id': '1',
        'session_id': 's1',
        'role': 'user',
        'content': 'Hello',
        'timestamp': '2025-09-01T12:00:00Z',
      };

      final model = ChatMessageModel.fromJson(json);

      expect(model.id, '1');
      expect(model.sessionId, 's1');
      expect(model.role, 'user');
      expect(model.content, 'Hello');
      expect(model.timestamp.toIso8601String(), '2025-09-01T12:00:00.000Z');
    });

    test('toJson should convert correctly', () {
      final model = ChatMessageModel(
        id: '1',
        sessionId: 's1',
        role: 'assistant',
        content: 'Hi!',
        timestamp: DateTime.parse('2025-09-01T12:00:00Z'),
      );

      final json = model.toJson();

      expect(json['id'], '1');
      expect(json['session_id'], 's1');
      expect(json['role'], 'assistant');
      expect(json['content'], 'Hi!');
    });
  });
}
