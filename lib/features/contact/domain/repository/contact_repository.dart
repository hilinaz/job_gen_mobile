import 'package:dartz/dartz.dart';
import 'package:job_gen_mobile/core/error/failures.dart';
import 'package:job_gen_mobile/features/contact/domain/entities/contact.dart';

abstract class ContactRepository {
  Future<Either<Failure, void>> submitContactForm(ContactForm contactForm);
}
