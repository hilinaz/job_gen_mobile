import 'package:dio/dio.dart';
import 'package:job_gen_mobile/core/constants/endpoints.dart';
import 'package:job_gen_mobile/core/network/envelope.dart';
import 'package:job_gen_mobile/features/contact/data/model/contact_model.dart';

abstract class ContactRemoteDatasource {
  Future<void> submitContactForm(ContactFormModel contactForm);
}

class ContactRemoteDatasourceImpl implements ContactRemoteDatasource {
  final Dio dio;

  ContactRemoteDatasourceImpl({required this.dio});

  @override
  Future<void> submitContactForm(ContactFormModel contactForm) async {
    final url = Endpoints.contact;

    try {
      final response = await dio.post(
        url,
        data: contactForm.toJson(),
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      final env = ApiEnvelope.fromJson(
        response.data as Map<String, dynamic>,
        (data) => data,
      );

      if (env.success != true) {
        throw DioException(
          requestOptions: response.requestOptions,
          message: env.message ?? 'Failed to submit contact form',
        );
      }

      print('[ContactRemote] Contact form submitted successfully');
    } catch (_) {
      rethrow;
    }
  }
}
