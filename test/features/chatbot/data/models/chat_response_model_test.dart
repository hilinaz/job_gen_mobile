import 'package:flutter_test/flutter_test.dart';
import 'package:job_gen_mobile/features/chatbot/data/models/chat_response_model.dart';

void main() {
  group('ChatResponseModel', () {
    test('fromJson should parse correctly', () {
      final json = {
        'session_id': 's1',
        'message': 'Hi!',
        'history': [
          {
            'id': '1',
            'session_id': 's1',
            'role': 'user',
            'content': 'Hello',
            'timestamp': '2025-09-01T12:00:00Z',
          },
        ],
        'suggestions': [
          {
            'type': 'cv_improvement',
            'content': 'Add metrics',
            'applied': false,
          }
        ],
      };

      final model = ChatResponseModel.fromJson(json);

      expect(model.sessionId, 's1');
      expect(model.message, 'Hi!');
      expect(model.history.first.role, 'user');
      expect(model.suggestions.first.type, 'cv_improvement');
    });
  });
}
