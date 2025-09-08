












import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/chat_bloc.dart';
import '../pages/chat_page.dart';

class ChatSessionsDrawer extends StatelessWidget {
  const ChatSessionsDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<ChatBloc>().add(LoadUserSessionsEvent());

    return Drawer(
      backgroundColor: const Color(0xFFEFF7F6),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Chats",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),

              Expanded(
                child: BlocConsumer<ChatBloc, ChatState>(
                  listener: (context, state) {
                    if (state is ChatSessionsLoaded) {
                    }
                  },
                  builder: (context, state) {
                    if (state is ChatLoading) {
                      return const Center(
                          child: CircularProgressIndicator());
                    }
                    if (state is ChatSessionsLoaded) {
                      final sessions = state.sessions;
                      if (sessions.isEmpty) {
                        return const Text("No chats yet");
                      }
                      return ListView.separated(
                        itemCount: sessions.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final s = sessions[index];
                          return _pillTile(
                            title: s.title.isNotEmpty
                                ? s.title
                                : "Untitled Chat",
                            onTap: () {
                              context
                                  .read<ChatBloc>()
                                  .add(LoadSessionHistoryEvent(s.id));
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const ChatPage(),
                                ),
                              );
                            },
                            onDelete: () {
                              context
                                  .read<ChatBloc>()
                                  .add(DeleteSessionEvent(s.id));
                            },
                          );
                        },
                      );
                    }
                    if (state is ChatError) {
                      return Text(
                        "Error: ${state.message}",
                        style: const TextStyle(color: Colors.red),
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _pillTile({
    required String title,
    required VoidCallback onTap,
    required VoidCallback onDelete,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF2E9E8F),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            
          ],
        ),
      ),
    );
  }
}
