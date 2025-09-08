import 'package:flutter_test/flutter_test.dart';
import 'package:job_gen_mobile/features/chatbot/data/models/chat_request_model.dart';

void main() {
  group('ChatRequestModel', () {
    test('toJson with sessionId and cvData', () {
      final model = ChatRequestModel(
        sessionId: 's1',
        message: 'Hello',
        cvData: {'skills': ['Go', 'MongoDB']},
      );

      final json = model.toJson();

      expect(json['session_id'], 's1');
      expect(json['message'], 'Hello');
      expect(json['cv_data'], isNotNull);
    });

    test('toJson without optional fields', () {
      final model = ChatRequestModel(message: 'Hello');

      final json = model.toJson();

      expect(json['session_id'], isNull);
      expect(json['cv_data'], isNull);
      expect(json['message'], 'Hello');
    });
  });
}
