import 'package:flutter/material.dart';

class CVCard extends StatelessWidget {
  final bool newUser;

  const CVCard({
    super.key,
    required this.newUser,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 5,
            spreadRadius: 2,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
              'CV\'s',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          
          const SizedBox(height: 8),
          // Subtitle
          Center(
            child: newUser ? Text("No CV's uploaded yet",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
            ): Center(
              child: 
              Icon(Icons.image, size: 100, color: Colors.grey[300]),
            ),
          ),
          const SizedBox(height: 24),
          // Section Label
          Center(
            child: Text(
              'Professional CV',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 18,
                  ),
            ),
          ),
          const SizedBox(height: 16),
          // Upload Button
          Center(
            child: Column(
              children: [
                 ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(220, 50),
              backgroundColor: const Color(0xFF7BBFB3),
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 14.0),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
              elevation: 2,
            ),
            child: Text(
              newUser ? 'Upload your CV' : 'Upload new CV',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Delete Button (only if not new user)
          if (!newUser)
            ElevatedButton(
              
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(220, 50),
                backgroundColor: const Color(0xFF7BBFB3),
                side: const BorderSide(color: Color(0xFF7BBFB3), width: 2),
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 14.0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                elevation: 0,
              ),
              child: const Text(
                'Delete CV',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
              ],
            ),
          )
        ],
      ),
    );
  }
}