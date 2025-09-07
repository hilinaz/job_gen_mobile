import 'package:flutter/material.dart';
import '../../../../core/theme/admin_colors.dart';

enum NotificationType {
  success,
  error,
  warning,
  info,
}

extension NotificationTypeExtension on NotificationType {
  String get value {
    switch (this) {
      case NotificationType.success:
        return 'success';
      case NotificationType.error:
        return 'error';
      case NotificationType.warning:
        return 'warning';
      case NotificationType.info:
        return 'info';
    }
  }
}

/// A custom notification widget that slides in from the right
/// matching the web admin UI style
class CustomNotification extends StatelessWidget {
  final String message;
  final String type; // 'success', 'error', 'warning', 'info'
  final VoidCallback onDismiss;
  
  /// Static method to show a notification
  static void show({
    required BuildContext context,
    required String message,
    required NotificationType type,
    Duration? duration,
  }) {
    showCustomNotification(
      context,
      message,
      type.value,
      duration: duration,
    );
  }

  const CustomNotification({
    Key? key,
    required this.message,
    required this.type,
    required this.onDismiss,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: 300,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border(
            left: BorderSide(
              color: _getNotificationColor(),
              width: 4,
            ),
          ),
        ),
        child: Row(
          children: [
            _getNotificationIcon(),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: AdminColors.textPrimaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.close,
                size: 16,
                color: AdminColors.textTertiaryColor,
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: onDismiss,
            ),
          ],
        ),
      ),
    );
  }

  Color _getNotificationColor() {
    return AdminColors.notificationColors[type] ?? AdminColors.notificationColors['info']!;
  }

  Widget _getNotificationIcon() {
    IconData iconData;
    Color iconColor = _getNotificationColor();
    
    switch (type) {
      case 'success':
        iconData = Icons.check_circle;
        break;
      case 'error':
        iconData = Icons.error;
        break;
      case 'warning':
        iconData = Icons.warning;
        break;
      default:
        iconData = Icons.info;
    }
    
    return Icon(iconData, color: iconColor, size: 20);
  }
}

/// Shows a custom notification that slides in from the right
/// and automatically dismisses after a duration
void showCustomNotification(
  BuildContext context, 
  String message, 
  String type, // 'success', 'error', 'warning', 'info'
  {Duration? duration}
) {
  final overlayState = Overlay.of(context);
  late OverlayEntry overlayEntry;
  
  overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      top: 20,
      right: 20,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 100.0, end: 0.0),
        duration: const Duration(milliseconds: 300),
        builder: (context, value, child) {
          return Transform.translate(
            offset: Offset(value, 0),
            child: child,
          );
        },
        child: CustomNotification(
          message: message,
          type: type,
          onDismiss: () {
            overlayEntry.remove();
          },
        ),
      ),
    ),
  );
  
  overlayState.insert(overlayEntry);
  
  Future.delayed(duration ?? const Duration(seconds: 3), () {
    if (overlayEntry.mounted) {
      overlayEntry.remove();
    }
  });
}
