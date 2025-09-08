import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/chat_bloc.dart';
import '../widgets/chat_message_bubble.dart';
// import '../widgets/typing_bubble.dart';
import '../widgets/typing_bubble.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("JobGen Chat"),
        backgroundColor: Colors.teal,
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<ChatBloc, ChatState>(
              builder: (context, state) {
                if (state is ChatLoading) {
                  return ListView(
                    padding: const EdgeInsets.all(12),
                    children: [
                      ...state.history
                          .map((msg) => ChatMessageBubble(message: msg))
                          .toList(),
                      const TypingBubble(),
                    ],
                  );
                }
                if (state is ChatLoaded) {
                  return ListView(
                    padding: const EdgeInsets.all(12),
                    children: state.history
                        .map((msg) => ChatMessageBubble(message: msg))
                        .toList(),
                  );
                }
                if (state is ChatError) {
                  return Center(
                      child: Text(
                    state.message,
                    style: const TextStyle(color: Colors.red),
                  ));
                }
                return const Center(child: Text("Start chatting with JobGen"));
              },
            ),
          ),
          _inputBar(context),
        ],
      ),
    );
  }

  Widget _inputBar(BuildContext context) {
    final controller = TextEditingController();
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(color: const Color(0xFFEFF7F6)),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                decoration: const InputDecoration(
                  hintText: "Type your message...",
                  border: InputBorder.none,
                ),
                onSubmitted: (msg) {
                  if (msg.trim().isNotEmpty) {
                    context.read<ChatBloc>().add(SendMessageEvent(msg.trim()));
                  }
                },
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send, color: Colors.teal),
              onPressed: () {
                if (controller.text.trim().isNotEmpty) {
                  context.read<ChatBloc>().add(
                        SendMessageEvent(controller.text.trim()),
                      );
                  controller.clear();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
