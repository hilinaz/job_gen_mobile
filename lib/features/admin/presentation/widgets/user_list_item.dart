import 'package:flutter/material.dart';
import '../../../../core/theme/admin_colors.dart';
import '../../domain/entities/user.dart';
import 'role_badge.dart';
import 'status_badge.dart';

class UserListItem extends StatelessWidget {
  final User user;
  final VoidCallback onEdit;
  final VoidCallback onToggleStatus;
  final VoidCallback onDelete;
  
  const UserListItem({
    Key? key,
    required this.user,
    required this.onEdit,
    required this.onToggleStatus,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AdminColors.modalBorderColor, width: 1),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: AdminColors.primaryColor.withOpacity(0.1),
                  child: Text(
                    user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                    style: TextStyle(
                      color: AdminColors.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: AdminColors.textPrimaryColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user.email,
                        style: TextStyle(
                          color: AdminColors.textTertiaryColor,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                RoleBadge(role: user.role),
                const SizedBox(width: 12),
                StatusBadge(isActive: user.isActive),
                const Spacer(),
                _buildActionButton(
                  icon: Icons.edit,
                  type: 'edit',
                  onPressed: onEdit,
                  tooltip: 'Edit Role',
                ),
                const SizedBox(width: 8),
                _buildActionButton(
                  icon: user.isActive ? Icons.toggle_on : Icons.toggle_off,
                  type: 'toggle',
                  onPressed: onToggleStatus,
                  tooltip: user.isActive ? 'Deactivate' : 'Activate',
                ),
                const SizedBox(width: 8),
                _buildActionButton(
                  icon: Icons.delete_outline,
                  type: 'delete',
                  onPressed: onDelete,
                  tooltip: 'Delete User',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String type,
    required VoidCallback onPressed,
    required String tooltip,
  }) {
    final colors = AdminColors.actionButtonColors[type] ?? AdminColors.actionButtonColors['edit']!;
    final bgColor = colors['background']!;
    final textColor = colors['text']!;
    
    return Material(
      color: Colors.transparent,
      child: Tooltip(
        message: tooltip,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: textColor,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}
