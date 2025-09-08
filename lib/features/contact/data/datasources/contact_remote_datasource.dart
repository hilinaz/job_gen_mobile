import 'package:job_gen_mobile/features/contact/data/model/contact_model.dart';

abstract class ContactRemoteDatasource {
    Future<void> submitContactForm(ContactFormModel contactForm);
}

class ContactRemoteDatasourceImpl implements ContactRemoteDatasource{
  @override
  Future<void> submitContactForm(ContactFormModel contactForm) {
  
    throw UnimplementedError();
  }

}