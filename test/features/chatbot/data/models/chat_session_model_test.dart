import 'package:flutter_test/flutter_test.dart';
import 'package:job_gen_mobile/features/chatbot/data/models/chat_session_model.dart';

void main() {
  group('ChatSessionModel', () {
    test('fromJson should parse correctly', () {
      final json = {
        'id': 's1',
        'user_id': 'u1',
        'created_at': '2025-09-01T10:00:00Z',
        'updated_at': '2025-09-01T11:00:00Z',
        'message_count': 5,
        'title': 'My Session',
      };

      final model = ChatSessionModel.fromJson(json);

      expect(model.id, 's1');
      expect(model.userId, 'u1');
      expect(model.messageCount, 5);
      expect(model.title, 'My Session');
    });
  });
}
