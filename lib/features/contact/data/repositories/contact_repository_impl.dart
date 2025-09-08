import 'package:dartz/dartz.dart';
import 'package:job_gen_mobile/core/error/failures.dart';
import 'package:job_gen_mobile/features/contact/domain/entities/contact.dart';
import 'package:job_gen_mobile/features/contact/domain/repository/contact_repository.dart';

class ContactRepositoryImpl extends ContactRepository{
  @override
  Future<Either<Failure, void>> submitContactForm(ContactForm contactForm) {

    throw UnimplementedError();
  }
} 