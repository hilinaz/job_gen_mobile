import '../../domain/entities/suggestion.dart';

class SuggestionModel extends Suggestion {
  const SuggestionModel({
    required super.type,
    required super.content,
    required super.applied,
  });

  factory SuggestionModel.fromJson(Map<String, dynamic> json) {
    return SuggestionModel(
      type: json['type'] ?? '',
      content: json['content'] ?? '',
      applied: json['applied'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'type': type,
        'content': content,
        'applied': applied,
      };
}
