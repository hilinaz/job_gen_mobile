part of 'chat_bloc.dart';

abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {
  final List<ChatMessage> history;
  ChatLoading(this.history);
}

class ChatLoaded extends ChatState {
  final List<ChatMessage> history;
  final String? activeSessionId;
  ChatLoaded(this.history, {this.activeSessionId});
}

class ChatSessionsLoaded extends ChatState {
  final List<ChatSession> sessions;
  ChatSessionsLoaded(this.sessions);
}

class ChatError extends ChatState {
  final String message;
  final List<ChatMessage> previousHistory;
  ChatError(this.message, this.previousHistory);
}
