import 'package:flutter/material.dart';
Widget buildTextField({
  required TextEditingController controller,
  required String labelText,
  required IconData icon,
  TextInputType keyboardType = TextInputType.text,
  String? Function(String?)? validator,
  int maxLines = 1,
  bool iconAlignmentTop = false,
}) {
  return TextFormField(
    controller: controller,
    keyboardType: keyboardType,
    maxLines: maxLines,
    validator: validator,
    decoration: InputDecoration(
      labelText: labelText,
      labelStyle: const TextStyle(color: Colors.black54),
      prefixIcon: iconAlignmentTop
          ? Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Icon(icon, color: const Color(0xFF7BBFB3)),
            )
          : Icon(icon, color: const Color(0xFF7BBFB3)),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide.none,
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(
        vertical: 16.0,
        horizontal: 12.0,
      ),
    ),
  );
}
