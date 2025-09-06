import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_gen_mobile/core/utils/role_manager.dart';
import '../bloc/auth_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('JobGen'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(SignOutEvent());
              Navigator.of(context).pushReplacementNamed('/sign_in');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome to JobGen',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your job generation platform',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 32),
            
            // Regular user features
            _buildFeatureCard(
              context,
              icon: Icons.work,
              title: 'Find Jobs',
              description: 'Browse and apply for jobs',
              onTap: () {
                // TODO: Navigate to jobs screen
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Jobs feature coming soon!')),
                );
              },
            ),
            const SizedBox(height: 16),
            
            _buildFeatureCard(
              context,
              icon: Icons.person,
              title: 'Profile',
              description: 'Manage your profile and settings',
              onTap: () {
                // TODO: Navigate to profile screen
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Profile feature coming soon!')),
                );
              },
            ),
            const SizedBox(height: 24),
            
            // Admin features section
            FutureBuilder<bool>(
              future: RoleManager.hasAdminAccess(),
              builder: (context, snapshot) {
                if (snapshot.data == true) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Divider(color: Colors.grey.shade300),
                      const SizedBox(height: 16),
                      Text(
                        'Admin Features',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade700,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      _buildFeatureCard(
                        context,
                        icon: Icons.dashboard,
                        title: 'Admin Dashboard',
                        description: 'View system overview and statistics',
                        color: Colors.blue.shade50,
                        onTap: () {
                          Navigator.of(context).pushNamed('/admin_dashboard');
                        },
                      ),
                      const SizedBox(height: 16),
                      
                      _buildFeatureCard(
                        context,
                        icon: Icons.people,
                        title: 'User Management',
                        description: 'Manage users, roles, and permissions',
                        color: Colors.blue.shade50,
                        onTap: () {
                          Navigator.of(context).pushNamed('/admin_users');
                        },
                      ),
                    ],
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
    Color? color,
  }) {
    return Card(
      color: color,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(
                icon,
                size: 32,
                color: color != null ? Colors.blue.shade700 : Colors.grey.shade700,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey.shade400,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
