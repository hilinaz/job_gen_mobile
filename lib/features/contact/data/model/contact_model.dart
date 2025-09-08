import 'package:job_gen_mobile/features/contact/domain/entities/contact.dart';

class ContactFormModel extends ContactForm {
  ContactFormModel({
    required super.name,
    required super.email,
    required super.subject,
    required super.message,
  });

  // Convert from JSON to model
  factory ContactFormModel.fromJson(Map<String, dynamic> json) {
    return ContactFormModel(
      name: json['name'] as String,
      email: json['email'] as String,
      subject: json['subject'] as String,
      message: json['message'] as String,
    );
  }

  // Convert model to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'subject': subject,
      'message': message,
    };
  }

  // Create a model from a domain entity
  factory ContactFormModel.fromEntity(ContactForm entity) {
    return ContactFormModel(
      name: entity.name,
      email: entity.email,
      subject: entity.subject,
      message: entity.message,
    );
  }
}
