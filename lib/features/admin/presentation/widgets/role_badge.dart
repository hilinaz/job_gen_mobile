import 'package:flutter/material.dart';
import '../../../../core/theme/admin_colors.dart';

class RoleBadge extends StatelessWidget {
  final String role;
  
  const RoleBadge({
    Key? key,
    required this.role,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final roleKey = role.toLowerCase();
    final bgColor = AdminColors.roleBadgeColors[roleKey]?['background'] ?? 
        const Color(0xFFE6FFFA);
    final textColor = AdminColors.roleBadgeColors[roleKey]?['text'] ?? 
        const Color(0xFF234E52);
        
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        role.toUpperCase(),
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w600,
          fontSize: 12,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
