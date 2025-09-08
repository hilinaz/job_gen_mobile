import 'package:flutter/material.dart';

class TypingBubble extends StatelessWidget {
  const TypingBubble();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFFEFF7F6),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Dot(),
            SizedBox(width: 4),
            Dot(),
            SizedBox(width: 4),
            Dot(),
          ],
        ),
      ),
    );
  }
}

class Dot extends StatefulWidget {
  const Dot({super.key});

  @override
  State<Dot> createState() => _DotState();
}

class _DotState extends State<Dot> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.3, end: 1).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: const CircleAvatar(radius: 3, backgroundColor: Colors.black54),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
