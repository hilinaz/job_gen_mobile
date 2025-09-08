import 'package:flutter_test/flutter_test.dart';
import 'package:job_gen_mobile/features/chatbot/data/models/suggestion_model.dart';

void main() {
  group('SuggestionModel', () {
    test('fromJson should parse correctly', () {
      final json = {
        'type': 'cv_improvement',
        'content': 'Add metrics',
        'applied': false,
      };

      final model = SuggestionModel.fromJson(json);

      expect(model.type, 'cv_improvement');
      expect(model.content, 'Add metrics');
      expect(model.applied, false);
    });

    test('toJson should convert correctly', () {
      final model = SuggestionModel(
        type: 'cv_improvement',
        content: 'Quantify results',
        applied: true,
      );

      final json = model.toJson();

      expect(json['type'], 'cv_improvement');
      expect(json['content'], 'Quantify results');
      expect(json['applied'], true);
    });
  });
}
