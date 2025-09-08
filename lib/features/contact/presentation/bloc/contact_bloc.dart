import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:job_gen_mobile/features/contact/domain/usecases/submit_form.dart';

part 'contact_event.dart';
part 'contact_state.dart';

class ContactBloc extends Bloc<ContactEvent, ContactState> {
  final SubmitContactForm form;
  ContactBloc({required this.form}) : super(ContactInitial()) {
    on<SendContactFormEvent>(_sendForm);
  }

  FutureOr<void> _sendForm(
    SendContactFormEvent event,
    Emitter<ContactState> emit,
  ) async {
    emit(ContactLoading());
    final result = await form(
      ContactFormParams(
        name: event.name,
        email: event.email,
        subject: event.subject,
        message: event.message,
      ),
    );
    result.fold(
      (failure) {
        emit(ContactError(errorMessage: 'Failed to send feedback form'));
      },
      (_) {
        emit(ContactSuccess(message: 'Feedback Sent successfully'));
      },
    );
  }
}
