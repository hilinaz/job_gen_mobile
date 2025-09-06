import 'package:flutter/material.dart';
import '../../../../core/theme/admin_colors.dart';
import '../../domain/entities/user.dart';

class DeleteConfirmationModal extends StatelessWidget {
  final User user;
  final VoidCallback onConfirm;
  
  const DeleteConfirmationModal({
    Key? key,
    required this.user,
    required this.onConfirm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AdminColors.modalBorderColor, width: 1),
      ),
      backgroundColor: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              color: AdminColors.modalHeaderBackground,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.warning_amber_rounded, 
                  color: Color(0xFFF56565), 
                  size: 28
                ),
                const SizedBox(width: 12),
                const Text(
                  'Delete User',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFF56565),
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: Icon(Icons.close, color: AdminColors.textTertiaryColor),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            Text(
              'Are you sure you want to delete this user?',
              style: TextStyle(
                fontSize: 16,
                color: AdminColors.textPrimaryColor,
              ),
            ),
            const SizedBox(height: 16),
            _buildUserInfo(),
            const SizedBox(height: 16),
            Text(
              'This action cannot be undone.',
              style: TextStyle(
                fontSize: 14,
                color: AdminColors.dangerButtonColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 32),
            _buildButtons(context),
          ],
        ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAFC),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AdminColors.modalBorderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            user.name,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AdminColors.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            user.email,
            style: TextStyle(
              fontSize: 14,
              color: AdminColors.textTertiaryColor,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AdminColors.roleBadgeColors[user.role.toLowerCase()]?['background'] ?? 
                      const Color(0xFFE6FFFA),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  user.role.toUpperCase(),
                  style: TextStyle(
                    fontSize: 12,
                    color: AdminColors.roleBadgeColors[user.role.toLowerCase()]?['text'] ?? 
                        const Color(0xFF234E52),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: user.isActive 
                    ? AdminColors.statusBadgeColors['active']!['background']
                    : AdminColors.statusBadgeColors['inactive']!['background'],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  user.isActive ? 'ACTIVE' : 'INACTIVE',
                  style: TextStyle(
                    fontSize: 12,
                    color: user.isActive 
                      ? AdminColors.statusBadgeColors['active']!['text']
                      : AdminColors.statusBadgeColors['inactive']!['text'],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      decoration: BoxDecoration(
        color: AdminColors.modalFooterBackground,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(
              foregroundColor: AdminColors.textTertiaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            ),
            child: const Text('Cancel'),
          ),
          const SizedBox(width: 16),
          ElevatedButton(
            onPressed: () {
              onConfirm();
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AdminColors.dangerButtonColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
            child: const Text('Delete User'),
          ),
        ],
      ),
    );
  }
}
