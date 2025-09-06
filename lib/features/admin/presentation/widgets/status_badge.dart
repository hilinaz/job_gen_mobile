import 'package:flutter/material.dart';
import '../../../../core/theme/admin_colors.dart';

class StatusBadge extends StatelessWidget {
  final bool isActive;
  
  const StatusBadge({
    Key? key,
    required this.isActive,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final status = isActive ? 'active' : 'inactive';
    final bgColor = AdminColors.statusBadgeColors[status]?['background'] ?? 
        (isActive ? const Color(0xFFF0FFF4) : const Color(0xFFFED7D7));
    final textColor = AdminColors.statusBadgeColors[status]?['text'] ?? 
        (isActive ? const Color(0xFF22543D) : const Color(0xFF742A2A));
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: textColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            isActive ? 'ACTIVE' : 'INACTIVE',
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w600,
              fontSize: 12,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
