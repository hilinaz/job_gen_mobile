part of 'chat_bloc.dart';

abstract class ChatEvent {}

class SendMessageEvent extends ChatEvent {
  final String message;
  final dynamic cvData;
  final String? sessionId;
  SendMessageEvent(this.message, {this.cvData, this.sessionId});
}

class LoadSessionHistoryEvent extends ChatEvent {
  final String sessionId;
  LoadSessionHistoryEvent(this.sessionId);
}

class DeleteSessionEvent extends ChatEvent {
  final String sessionId;
  DeleteSessionEvent(this.sessionId);
}

class LoadUserSessionsEvent extends ChatEvent {}
