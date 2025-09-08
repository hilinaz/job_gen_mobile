import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/chat_request.dart';
import '../../domain/usecases/send_message.dart';
import '../../domain/usecases/get_user_sessions.dart';
import '../../domain/usecases/get_session_history.dart';
import '../../domain/usecases/delete_session.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/entities/chat_session.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final SendMessage sendMessage;
  final GetUserSessions getUserSessions;
  final GetSessionHistory getSessionHistory;
  final DeleteSession deleteSession;

  ChatBloc({
    required this.sendMessage,
    required this.getUserSessions,
    required this.getSessionHistory,
    required this.deleteSession,
  }) : super(ChatInitial()) {
    on<SendMessageEvent>(_onSendMessage);
    on<LoadSessionHistoryEvent>(_onLoadSessionHistory);
    on<DeleteSessionEvent>(_onDeleteSession);
    on<LoadUserSessionsEvent>(_onLoadUserSessions);
  }

  Future<void> _onSendMessage(
      SendMessageEvent event, Emitter<ChatState> emit) async {
    final currentHistory = state is ChatLoaded
        ? (state as ChatLoaded).history
        : <ChatMessage>[];

    emit(ChatLoading(currentHistory));

    try {
      final response = await sendMessage(
        ChatRequest(
          sessionId: event.sessionId,
          message: event.message,
          cvData: event.cvData,
        ),
      );

      final updatedHistory = [...currentHistory, ...response.history];
      emit(ChatLoaded(updatedHistory, activeSessionId: response.sessionId));
    } catch (e) {
      emit(ChatError(e.toString(), currentHistory));
    }
  }

  Future<void> _onLoadSessionHistory(
      LoadSessionHistoryEvent event, Emitter<ChatState> emit) async {
    emit(ChatLoading(const []));
    try {
      final history = await getSessionHistory(event.sessionId);
      emit(ChatLoaded(history, activeSessionId: event.sessionId));
    } catch (e) {
      emit(ChatError(e.toString(), const []));
    }
  }

  Future<void> _onDeleteSession(
      DeleteSessionEvent event, Emitter<ChatState> emit) async {
    try {
      await deleteSession(event.sessionId);
      final sessions = await getUserSessions();
      emit(ChatSessionsLoaded(sessions));

      if (state is ChatLoaded &&
          (state as ChatLoaded).activeSessionId == event.sessionId) {
        emit(ChatInitial());
      }
    } catch (e) {
      emit(ChatError("Failed to delete session: $e", const []));
    }
  }

  Future<void> _onLoadUserSessions(
      LoadUserSessionsEvent event, Emitter<ChatState> emit) async {
    try {
      final sessions = await getUserSessions();
      emit(ChatSessionsLoaded(sessions));
    } catch (e) {
      emit(ChatError("Failed to load sessions: $e", const []));
    }
  }
}
