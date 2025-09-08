part of 'contact_bloc.dart';

sealed class ContactState extends Equatable {
  const ContactState();

  @override
  List<Object> get props => [];
}

// Initial state
final class ContactInitial extends ContactState {}


final class ContactLoading extends ContactState {}


final class ContactSuccess extends ContactState {
  final String message;

  const ContactSuccess({required this.message});

  @override
  List<Object> get props => [message];
}


final class ContactError extends ContactState {
  final String errorMessage;

  const ContactError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
