import 'package:dartz/dartz.dart';
import 'package:job_gen_mobile/core/error/failures.dart';
import 'package:job_gen_mobile/core/usecases/usecase.dart';
import 'package:job_gen_mobile/features/contact/domain/entities/contact.dart';
import 'package:job_gen_mobile/features/contact/domain/repository/contact_repository.dart';

class SubmitContactForm extends UseCase<void, ContactFormParams> {
  final ContactRepository repository;

  SubmitContactForm(this.repository);

  @override
  Future<Either<Failure, void>> call(ContactFormParams params) {

    final contactForm = ContactForm(
      name: params.name,
      email: params.email,
      subject: params.subject,
      message: params.message,
    );

    return repository.submitContactForm(contactForm);
  }
}

class ContactFormParams {
  final String name;
  final String email;
  final String subject;
  final String message;

  ContactFormParams({
    required this.name,
    required this.email,
    required this.subject,
    required this.message,
  });
}
