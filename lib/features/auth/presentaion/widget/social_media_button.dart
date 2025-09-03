import 'package:flutter/material.dart';

Widget buildSocialButton(
  BuildContext context, {
  required IconData icon,
  required String text,
}) {
  return SizedBox(
    height: 50,
    child: OutlinedButton(
      onPressed: () {},
      style:
          OutlinedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black87,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            side: BorderSide(color: Colors.grey.shade300, width: 1),
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
          ).copyWith(
            overlayColor: MaterialStateProperty.resolveWith<Color?>((states) {
              if (states.contains(MaterialState.pressed)) {
                return const Color(
                  0xFF7BBFB3,
                ).withOpacity(0.2); // pressed color
              }
              return null; // default overlay
            }),
          ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 26, color: Colors.black87),
          const SizedBox(width: 12),
          Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    ),
  );
}
