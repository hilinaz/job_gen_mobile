import 'package:flutter/material.dart';

class ChatJobCard extends StatelessWidget {
  const ChatJobCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: const Text("Backend-Engineer"),
        subtitle: const Text("Acme Corp • Remote • 2 days ago"),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text("50%", style: TextStyle(fontWeight: FontWeight.bold)),
            Text("Match"),
          ],
        ),
      ),
    );
  }
}
