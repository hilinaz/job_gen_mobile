part of 'contact_bloc.dart';

sealed class ContactEvent extends Equatable {
  const ContactEvent();

  @override
  List<Object> get props => [];
}


// ignore: must_be_immutable
class SendContactFormEvent extends ContactEvent {
  final String name;
  final String email;
  final String subject;
  final String message;
const  SendContactFormEvent({required this.name ,required this.email ,required this.subject,required this.message});
}
