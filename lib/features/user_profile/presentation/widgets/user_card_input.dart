import 'package:flutter/material.dart';

class UserCardInput extends StatelessWidget {
  final String title;
  final String placeholder;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final int? maxLines;
  final bool enabled;

  const UserCardInput({
    super.key,
    required this.title,
    required this.placeholder,
    required this.controller,
    this.keyboardType,
    this.maxLines = 1,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: enabled ? Colors.grey[100] : Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
            enabled: enabled,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              hintText: placeholder,
              hintStyle: TextStyle(color: Colors.grey[500]),
              border: InputBorder.none,
              isDense: true,
            ),
            style: const TextStyle(fontSize: 15),
          ),
        ),
      ],
    );
  }
}
