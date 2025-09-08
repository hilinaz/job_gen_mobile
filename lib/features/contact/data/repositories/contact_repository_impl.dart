import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:job_gen_mobile/core/error/failures.dart';
import 'package:job_gen_mobile/features/contact/data/datasources/contact_remote_datasource.dart';
import 'package:job_gen_mobile/features/contact/data/model/contact_model.dart';
import 'package:job_gen_mobile/features/contact/domain/entities/contact.dart';
import 'package:job_gen_mobile/features/contact/domain/repository/contact_repository.dart';

class ContactRepositoryImpl implements ContactRepository {
  final ContactRemoteDatasource remoteDatasource;

  ContactRepositoryImpl({required this.remoteDatasource});

  @override
  Future<Either<Failure, void>> submitContactForm(
    ContactForm contactForm,
  ) async {
    try {
      // Convert entity to model before sending to remote datasource
      final contactModel = ContactFormModel.fromEntity(contactForm);
      await remoteDatasource.submitContactForm(contactModel);
      print('[ContactRepository] Contact form submitted successfully');
      return const Right(null);
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          message:
              e.message ??
              'Failed to submit contact form. Please try again later.',
        ),
      );
    } catch (e) {
      return Left(
        ServerFailure(
          message: 'Unexpected error occurred while submitting contact form.',
        ),
      );
    }
  }
}
