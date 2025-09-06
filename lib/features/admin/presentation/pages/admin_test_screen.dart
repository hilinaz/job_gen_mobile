import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../../core/theme/admin_colors.dart';
import '../../domain/entities/user.dart';
import '../widgets/admin_app_bar.dart';
import '../widgets/custom_notification.dart';
import '../widgets/role_badge.dart';
import '../widgets/status_badge.dart';
import '../widgets/role_edit_modal.dart';
import '../widgets/delete_confirmation_modal.dart';

class AdminTestScreen extends StatefulWidget {
  const AdminTestScreen({Key? key}) : super(key: key);

  @override
  State<AdminTestScreen> createState() => _AdminTestScreenState();
}

class _AdminTestScreenState extends State<AdminTestScreen> {
  final TextEditingController _apiUrlController = TextEditingController();
  final TextEditingController _apiMethodController = TextEditingController(
    text: 'GET',
  );
  final TextEditingController _apiBodyController = TextEditingController();
  final TextEditingController _apiHeadersController = TextEditingController(
    text:
        '{"Content-Type": "application/json", "Authorization": "Bearer YOUR_TOKEN_HERE"}',
  );
  final TextEditingController _baseUrlController = TextEditingController(
    text: 'http://localhost:8080',
  );

  // Request history
  final List<Map<String, dynamic>> _requestHistory = [];
  final int _maxHistoryItems = 5;

  // Environment options
  final Map<String, String> _environments = {
    'Local': 'http://localhost:8080',
    'Local (Android Emulator)': 'http://10.0.2.2:8080',
    'Local (iOS Simulator)': 'http://127.0.0.1:8080',
    'Staging': 'https://staging-api.jobgen.io',
    'Production': 'https://api.jobgen.io',
  };
  String _selectedEnvironment = 'Local';

  // Authentication token storage
  String? _savedAuthToken;
  final TextEditingController _authTokenController = TextEditingController();

  // Admin API endpoint presets
  final Map<String, Map<String, String>> _apiPresets = {
    'Get Users': {
      'url':
          '/api/v1/admin/users?page=1&limit=10&sort_by=created_at&sort_order=desc',
      'method': 'GET',
      'body': '',
    },
    'Get Users (Filtered)': {
      'url': '/api/v1/admin/users?page=1&limit=10&role=admin&active=true',
      'method': 'GET',
      'body': '',
    },
    'Search Users': {
      'url': '/api/v1/admin/users?page=1&limit=10&search=john',
      'method': 'GET',
      'body': '',
    },
    'Delete User': {
      'url': '/api/v1/admin/users/USER_ID',
      'method': 'DELETE',
      'body': '',
    },
    'Update User Role': {
      'url': '/api/v1/admin/users/USER_ID/role',
      'method': 'PUT',
      'body': '{"role": "admin"}',
    },
    'Toggle User Status': {
      'url': '/api/v1/admin/users/USER_ID/toggle-status',
      'method': 'PUT',
      'body': '',
    },
  };

  String _apiResponse = '';
  bool _isLoading = false;

  @override
  void dispose() {
    _apiUrlController.dispose();
    _apiMethodController.dispose();
    _apiBodyController.dispose();
    _apiHeadersController.dispose();
    _baseUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFC),
      appBar: const AdminAppBar(title: 'Admin UI Components'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Admin UI Components',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AdminColors.textPrimaryColor,
              ),
            ),
            const SizedBox(height: 24),
            _buildColorPalette(),
            const SizedBox(height: 24),
            _buildBadgesSection(),
            const SizedBox(height: 24),
            _buildButtonsSection(),
            const SizedBox(height: 24),
            _buildNotificationsSection(),
            const SizedBox(height: 24),
            _buildModalsSection(),
            const SizedBox(height: 24),
            _buildApiTestingSection(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AdminColors.primaryButtonColor,
        foregroundColor: Colors.white,
        onPressed: () {
          showCustomNotification(
            context,
            'This is a success notification',
            'success',
          );
        },
        child: const Icon(Icons.notifications),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AdminColors.textPrimaryColor,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: 60,
          height: 3,
          decoration: BoxDecoration(
            color: AdminColors.primaryButtonColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildColorPalette() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Color Palette'),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            _buildColorSwatch('Primary', AdminColors.primaryButtonColor),
            _buildColorSwatch('Secondary', AdminColors.secondaryButtonColor),
            _buildColorSwatch('Danger', AdminColors.dangerButtonColor),
            _buildColorSwatch(
              'Success',
              AdminColors.notificationColors['success']!,
            ),
            _buildColorSwatch(
              'Warning',
              AdminColors.notificationColors['warning']!,
            ),
            _buildColorSwatch('Info', AdminColors.notificationColors['info']!),
            _buildColorSwatch(
              'Error',
              AdminColors.notificationColors['error']!,
            ),
            _buildColorSwatch('Text Primary', AdminColors.textPrimaryColor),
            _buildColorSwatch('Text Secondary', AdminColors.textSecondaryColor),
            _buildColorSwatch('Text Tertiary', AdminColors.textTertiaryColor),
          ],
        ),
      ],
    );
  }

  Widget _buildColorSwatch(String name, Color color) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          name,
          style: TextStyle(fontSize: 12, color: AdminColors.textSecondaryColor),
        ),
        Text(
          '#${color.value.toRadixString(16).substring(2).toUpperCase()}',
          style: TextStyle(
            fontSize: 10,
            color: AdminColors.textTertiaryColor,
            fontFamily: 'monospace',
          ),
        ),
      ],
    );
  }

  Widget _buildBadgesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Badges'),
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: AdminColors.modalBorderColor),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Role Badges',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AdminColors.textPrimaryColor,
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    const RoleBadge(role: 'admin'),
                    const RoleBadge(role: 'recruiter'),
                    const RoleBadge(role: 'employer'),
                    const RoleBadge(role: 'jobseeker'),
                    const RoleBadge(role: 'moderator'),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  'Status Badges',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AdminColors.textPrimaryColor,
                  ),
                ),
                const SizedBox(height: 16),
                const Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    StatusBadge(isActive: true),
                    StatusBadge(isActive: false),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildButtonsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Buttons'),
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: AdminColors.modalBorderColor),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Primary Buttons',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AdminColors.textPrimaryColor,
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AdminColors.primaryButtonColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: const Text('Primary Button'),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AdminColors.secondaryButtonColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: const Text('Secondary Button'),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AdminColors.dangerButtonColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: const Text('Danger Button'),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  'Text Buttons',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AdminColors.textPrimaryColor,
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        foregroundColor: AdminColors.primaryButtonColor,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                      ),
                      child: const Text('Primary Text'),
                    ),
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        foregroundColor: AdminColors.secondaryButtonColor,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                      ),
                      child: const Text('Secondary Text'),
                    ),
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        foregroundColor: AdminColors.textTertiaryColor,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  'Action Buttons',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AdminColors.textPrimaryColor,
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _buildActionButton(
                      icon: Icons.edit,
                      color: AdminColors.actionButtonColors['edit']!['text']!,
                      onPressed: () {},
                      tooltip: 'Edit',
                    ),
                    _buildActionButton(
                      icon: Icons.toggle_on,
                      color: AdminColors.actionButtonColors['toggle']!['text']!,
                      onPressed: () {},
                      tooltip: 'Toggle Status',
                    ),
                    _buildActionButton(
                      icon: Icons.delete,
                      color: AdminColors.actionButtonColors['delete']!['text']!,
                      onPressed: () {},
                      tooltip: 'Delete',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
    required String tooltip,
  }) {
    return Material(
      color: Colors.transparent,
      child: Tooltip(
        message: tooltip,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Notifications'),
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: AdminColors.modalBorderColor),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Click to show notifications:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AdminColors.textPrimaryColor,
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        showCustomNotification(
                          context,
                          'This is a success notification',
                          'success',
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            AdminColors.notificationColors['success'],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: const Text('Success'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        showCustomNotification(
                          context,
                          'This is an error notification',
                          'error',
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            AdminColors.notificationColors['error'],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: const Text('Error'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        showCustomNotification(
                          context,
                          'This is a warning notification',
                          'warning',
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            AdminColors.notificationColors['warning'],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: const Text('Warning'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        showCustomNotification(
                          context,
                          'This is an info notification',
                          'info',
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AdminColors.notificationColors['info'],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: const Text('Info'),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  'Preview:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AdminColors.textPrimaryColor,
                  ),
                ),
                const SizedBox(height: 16),
                CustomNotification(
                  message: 'This is a sample success notification',
                  type: 'success',
                  onDismiss: () {},
                ),
                const SizedBox(height: 12),
                CustomNotification(
                  message: 'This is a sample error notification',
                  type: 'error',
                  onDismiss: () {},
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildApiTestingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('API Testing'),
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: AdminColors.modalBorderColor),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Test API Endpoints',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AdminColors.textPrimaryColor,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Admin API Presets',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AdminColors.textSecondaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _apiPresets.entries
                        .map(
                          (entry) => Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: ElevatedButton(
                              onPressed: () => _loadApiPreset(entry.key),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    AdminColors.secondaryButtonColor,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 10,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                elevation: 0,
                              ),
                              child: Text(entry.key),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
                if (_requestHistory.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text(
                    'Recent Requests',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AdminColors.textSecondaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _requestHistory
                          .map(
                            (item) => Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: ElevatedButton(
                                onPressed: () => _loadHistoryItem(item),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: item['success']
                                      ? AdminColors
                                            .notificationColors['success']
                                      : AdminColors.notificationColors['error'],
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 10,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  elevation: 0,
                                ),
                                child: Text(
                                  '${item['method']} (${item['statusCode']})',
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                Text(
                  'Environment',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AdminColors.textSecondaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: AdminColors.modalBorderColor),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: _selectedEnvironment,
                      items: _environments.keys.map((String env) {
                        return DropdownMenuItem<String>(
                          value: env,
                          child: Text(env),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _selectedEnvironment = newValue;
                            _baseUrlController.text = _environments[newValue]!;
                          });
                          showCustomNotification(
                            context,
                            'Switched to $newValue environment',
                            'info',
                          );
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _baseUrlController,
                  decoration: InputDecoration(
                    labelText: 'Base URL',
                    hintText: 'http://localhost:8080',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: AdminColors.modalBorderColor,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: AdminColors.modalBorderColor,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: AdminColors.primaryColor),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        Icons.refresh,
                        color: AdminColors.primaryColor,
                      ),
                      onPressed: () {
                        _baseUrlController.text =
                            _environments[_selectedEnvironment]!;
                      },
                      tooltip: 'Reset to default',
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Authentication Token',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AdminColors.textSecondaryColor,
                        ),
                      ),
                    ),
                    _savedAuthToken != null
                        ? TextButton.icon(
                            onPressed: () {
                              setState(() {
                                _authTokenController.text = _savedAuthToken!;
                              });
                              showCustomNotification(
                                context,
                                'Saved token loaded',
                                'info',
                              );
                            },
                            icon: Icon(
                              Icons.refresh,
                              color: AdminColors.primaryColor,
                              size: 16,
                            ),
                            label: Text(
                              'Load Saved',
                              style: TextStyle(
                                color: AdminColors.primaryColor,
                                fontSize: 12,
                              ),
                            ),
                          )
                        : const SizedBox(),
                  ],
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _authTokenController,
                  decoration: InputDecoration(
                    hintText: 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: AdminColors.modalBorderColor,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: AdminColors.modalBorderColor,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: AdminColors.primaryColor),
                    ),
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.save,
                            color: AdminColors.primaryColor,
                          ),
                          onPressed: () async {
                            if (_authTokenController.text.isNotEmpty) {
                              setState(() {
                                _savedAuthToken = _authTokenController.text;
                              });
                              // Token will be handled by auth system
                              showCustomNotification(
                                context,
                                'Authentication token saved',
                                'success',
                              );
                            }
                          },
                          tooltip: 'Save token',
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.clear,
                            color: AdminColors.textSecondaryColor,
                          ),
                          onPressed: () {
                            _authTokenController.clear();
                          },
                          tooltip: 'Clear',
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _apiUrlController,
                  decoration: InputDecoration(
                    labelText: 'API Endpoint',
                    hintText: '/admin/users',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: AdminColors.modalBorderColor,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: AdminColors.modalBorderColor,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: AdminColors.primaryButtonColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: TextField(
                        controller: _apiMethodController,
                        decoration: InputDecoration(
                          labelText: 'Method',
                          hintText: 'GET',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: AdminColors.modalBorderColor,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: AdminColors.modalBorderColor,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: AdminColors.primaryButtonColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 3,
                      child: TextField(
                        controller: _apiHeadersController,
                        decoration: InputDecoration(
                          labelText: 'Headers (JSON)',
                          hintText: '{"Content-Type": "application/json"}',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: AdminColors.modalBorderColor,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: AdminColors.modalBorderColor,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: AdminColors.primaryButtonColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _apiBodyController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    labelText: 'Request Body (JSON)',
                    hintText: '{"key": "value"}',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: AdminColors.modalBorderColor,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: AdminColors.modalBorderColor,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: AdminColors.primaryButtonColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _sendApiRequest,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AdminColors.primaryButtonColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text('Send Request'),
                  ),
                ),
                if (_apiResponse.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  Text(
                    'Response:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AdminColors.textPrimaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AdminColors.modalBorderColor),
                    ),
                    child: SelectableText(
                      _apiResponse,
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 14,
                        color: AdminColors.textPrimaryColor,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _loadApiPreset(String presetName) {
    final preset = _apiPresets[presetName];
    if (preset != null) {
      setState(() {
        _apiUrlController.text = preset['url']!;
        _apiMethodController.text = preset['method']!;
        _apiBodyController.text = preset['body']!;
      });

      showCustomNotification(context, 'Loaded $presetName preset', 'info');
    }
  }

  void _loadHistoryItem(Map<String, dynamic> historyItem) {
    // Extract the endpoint from the full URL
    final Uri uri = Uri.parse(historyItem['url']);
    final String endpoint =
        uri.path + (uri.query.isNotEmpty ? '?${uri.query}' : '');

    setState(() {
      _apiUrlController.text = endpoint;
      _apiMethodController.text = historyItem['method'];
      // We don't store the body in history to keep it simple
    });

    showCustomNotification(
      context,
      'Loaded previous ${historyItem['method']} request',
      'info',
    );
  }

  Future<void> _sendApiRequest() async {
    if (_apiUrlController.text.isEmpty || _baseUrlController.text.isEmpty) {
      showCustomNotification(
        context,
        'Please enter both base URL and API endpoint',
        'error',
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _apiResponse = 'Loading...';
    });

    try {
      // Combine base URL and endpoint
      String fullUrl = _baseUrlController.text;
      String endpoint = _apiUrlController.text;

      // Ensure proper formatting between base URL and endpoint
      if (!fullUrl.endsWith('/') && !endpoint.startsWith('/')) {
        fullUrl += '/';
      } else if (fullUrl.endsWith('/') && endpoint.startsWith('/')) {
        endpoint = endpoint.substring(1);
      }

      final url = Uri.parse(fullUrl + endpoint);
      Map<String, dynamic> headers = {};

      try {
        if (_apiHeadersController.text.isNotEmpty) {
          headers =
              jsonDecode(_apiHeadersController.text) as Map<String, dynamic>;
        }
      } catch (e) {
        showCustomNotification(context, 'Invalid JSON in headers: $e', 'error');
        setState(() => _isLoading = false);
        return;
      }

      // Add authentication token if provided
      if (_authTokenController.text.isNotEmpty) {
        // Check if token already has Bearer prefix
        String token = _authTokenController.text.trim();
        if (!token.startsWith('Bearer ')) {
          token = 'Bearer $token';
        }
        headers['Authorization'] = token;
      }

      final method = _apiMethodController.text.toUpperCase();
      http.Response response;

      switch (method) {
        case 'GET':
          response = await http.get(
            url,
            headers: headers.map((k, v) => MapEntry(k, v.toString())),
          );
          break;
        case 'POST':
          response = await http.post(
            url,
            headers: headers.map((k, v) => MapEntry(k, v.toString())),
            body: _apiBodyController.text.isNotEmpty
                ? _apiBodyController.text
                : null,
          );
          break;
        case 'PUT':
          response = await http.put(
            url,
            headers: headers.map((k, v) => MapEntry(k, v.toString())),
            body: _apiBodyController.text.isNotEmpty
                ? _apiBodyController.text
                : null,
          );
          break;
        case 'DELETE':
          response = await http.delete(
            url,
            headers: headers.map((k, v) => MapEntry(k, v.toString())),
            body: _apiBodyController.text.isNotEmpty
                ? _apiBodyController.text
                : null,
          );
          break;
        default:
          showCustomNotification(
            context,
            'Unsupported method: $method',
            'error',
          );
          setState(() => _isLoading = false);
          return;
      }

      // Try to format JSON response if possible
      String formattedResponse;
      try {
        final dynamic jsonResponse = json.decode(response.body);
        formattedResponse = const JsonEncoder.withIndent(
          '  ',
        ).convert(jsonResponse);
      } catch (e) {
        formattedResponse = response.body;
      }

      // Add to request history
      final historyItem = {
        'url': url.toString(),
        'method': method,
        'statusCode': response.statusCode,
        'timestamp': DateTime.now(),
        'success': response.statusCode >= 200 && response.statusCode < 300,
      };

      setState(() {
        _requestHistory.insert(0, historyItem);
        if (_requestHistory.length > _maxHistoryItems) {
          _requestHistory.removeLast();
        }
        _apiResponse =
            'Status Code: ${response.statusCode}\n\nHeaders: ${response.headers}\n\n$formattedResponse';
        _isLoading = false;
      });

      if (response.statusCode >= 200 && response.statusCode < 300) {
        showCustomNotification(
          context,
          'Request successful: ${response.statusCode}',
          'success',
        );
      } else {
        showCustomNotification(
          context,
          'Request failed: ${response.statusCode}',
          'error',
        );
      }
    } catch (e) {
      setState(() {
        _apiResponse = 'Error: $e';
        _isLoading = false;
      });
      showCustomNotification(context, 'Request error: $e', 'error');
    }
  }

  Widget _buildModalsSection() {
    // Sample user for demonstration
    final User sampleUser = User(
      id: '1',
      name: 'John Doe',
      email: 'john.doe@example.com',
      role: 'admin',
      isActive: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Modals'),
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: AdminColors.modalBorderColor),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Click to show modals:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AdminColors.textPrimaryColor,
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => RoleEditModal(
                            user: sampleUser,
                            onRoleChanged: (String role) {
                              showCustomNotification(
                                context,
                                'Role changed to $role',
                                'success',
                              );
                            },
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AdminColors.primaryButtonColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: const Text('Edit Role Modal'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => DeleteConfirmationModal(
                            user: sampleUser,
                            onConfirm: () {
                              showCustomNotification(
                                context,
                                'User deleted successfully',
                                'success',
                              );
                            },
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AdminColors.dangerButtonColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: const Text('Delete User Modal'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
