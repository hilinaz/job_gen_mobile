import 'package:flutter/material.dart';

class UserCard extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController occupationController;

  const UserCard({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.occupationController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
       decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 5,
              spreadRadius: 2,
              offset: Offset(6, 8),
            ),
          ],
        ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 124),
          // Title
          Center(
            child: Text(
              'Random User',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          const SizedBox(height: 8),
          // Description
          Center(
            child: Text(
              'A random user description goes here.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          const SizedBox(height: 16),
          // Personal Information Title
          Padding(padding:  const EdgeInsets.only(left: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Personal Information',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 0, 0, 0),
                        fontSize: 18,
                      ),
                ),
                const SizedBox(height: 16.0),
                UserCardInput(
                  title: 'Name',
                  placeholder: 'Enter your name',
                  controller: nameController,
                ),
                const SizedBox(height: 16.0),
                UserCardInput(
                  title: 'Email',
                  placeholder: 'Enter your email',
                  controller: emailController,
                ),
                const SizedBox(height: 16.0),
                UserCardInput(
                  title: 'Occupation',
                  placeholder: 'Enter your occupation',
                  controller: occupationController,
                ),
              ],
            ),),
        ],
      ),
    );
  }
}







class UserCardInput extends StatelessWidget {
  final String title;
  final String placeholder;
  final TextEditingController controller;
  final VoidCallback? onEdit;

  const UserCardInput({
    super.key,
    required this.title,
    required this.placeholder,
    required this.controller,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 16,
              ),
        ),
        const SizedBox(height: 8.0),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 14.0),
          decoration: BoxDecoration(
            color: const Color(0xFFE0F2F1), // soft solid background
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  controller.text.isEmpty ? placeholder : controller.text,
                  style: TextStyle(
                    color: controller.text.isEmpty ? Colors.grey : Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.black54),
                onPressed: onEdit,
              ),
            ],
          ),
        ),
      ],
    );
  }
}