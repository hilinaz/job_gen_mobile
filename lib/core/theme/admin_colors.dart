import 'package:flutter/material.dart';

/// Admin UI color constants that match the web admin UI
class AdminColors {
  // Primary theme colors
  static const Color primaryColor = Color(0xFF4FD1C7);       // Main teal color
  static const Color primaryDarkColor = Color(0xFF38B2AC);   // Darker teal for gradients
  static const Color textPrimaryColor = Color(0xFF2D3748);   // Main text color
  static const Color textSecondaryColor = Color(0xFF4A5568); // Secondary text color
  static const Color textTertiaryColor = Color(0xFF718096);  // Tertiary/hint text
  static const Color backgroundColor = Color(0xFFF7FAFC);    // Background light color
  
  // Role badge colors - matching backend roles (admin and user only)
  static const Map<String, Map<String, Color>> roleBadgeColors = {
    'admin': {
      'background': Color(0xFFFEF5E7),
      'text': Color(0xFF744210),
    },
    'user': {
      'background': Color(0xFFEBF4FF),
      'text': Color(0xFF2C5282),
    },
  };
  
  // Status badge colors
  static const Map<String, Map<String, Color>> statusBadgeColors = {
    'active': {
      'background': Color(0xFFF0FFF4),
      'text': Color(0xFF22543D),
    },
    'inactive': {
      'background': Color(0xFFFED7D7),
      'text': Color(0xFF742A2A),
    },
  };
  
  // Action button colors
  static const Map<String, Map<String, Color>> actionButtonColors = {
    'edit': {
      'background': Color(0xFFE6FFFA),
      'text': Color(0xFF234E52),
      'hover': Color(0xFF4FD1C7),
    },
    'toggle': {
      'background': Color(0xFFF0FFF4),
      'text': Color(0xFF22543D),
      'hover': Color(0xFF48BB78),
    },
    'delete': {
      'background': Color(0xFFFED7D7),
      'text': Color(0xFF742A2A),
      'hover': Color(0xFFF56565),
    },
  };
  
  // Button colors
  static const Color primaryButtonColor = Color(0xFF4FD1C7);
  static const Color primaryButtonHoverColor = Color(0xFF38B2AC);
  static const Color secondaryButtonColor = Color(0xFFE2E8F0);
  static const Color secondaryButtonHoverColor = Color(0xFFCBD5E0);
  static const Color dangerButtonColor = Color(0xFFF56565);
  static const Color dangerButtonHoverColor = Color(0xFFE53E3E);
  
  // Notification colors
  static const Map<String, Color> notificationColors = {
    'success': Color(0xFF48BB78),
    'error': Color(0xFFF56565),
    'warning': Color(0xFFED8936),
    'info': Color(0xFF4FD1C7),
  };
  
  // Modal colors
  static const Color modalHeaderBackground = Color(0xFFF8FAFC);
  static const Color modalFooterBackground = Color(0xFFF8FAFC);
  static const Color modalBorderColor = Color(0xFFE2E8F0);
  
  // Pagination colors
  static const Color paginationActiveColor = Color(0xFF4FD1C7);
  static const Color paginationInactiveColor = Color(0xFFE2E8F0);
  static const Color paginationTextColor = Color(0xFF4A5568);
  static const Color paginationActiveTextColor = Colors.white;
}
