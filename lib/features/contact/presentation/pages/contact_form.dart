import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_gen_mobile/features/jobs/presentation/pages/job_listing_page.dart';
import 'package:job_gen_mobile/features/contact/presentation/bloc/contact_bloc.dart';
import 'package:job_gen_mobile/core/utils/role_manager.dart';
import '../widget/widget.dart';

class ContactForm extends StatefulWidget {
  const ContactForm({super.key});

  @override
  State<ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  bool _isAdmin = false;

  @override
  void initState() {
    super.initState();
    _checkAdminRole();
  }

  Future<void> _checkAdminRole() async {
    final isAdmin = await RoleManager.hasAdminAccess();
    if (mounted) {
      setState(() {
        _isAdmin = isAdmin;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _sendForm() {
    if (_formKey.currentState!.validate()) {
      context.read<ContactBloc>().add(
        SendContactFormEvent(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          subject: _subjectController.text.trim(),
          message: _messageController.text.trim(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ContactBloc, ContactState>(
      listener: (context, state) {
        if (state is ContactSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: const Color(0xFF7BBFB3),
            ),
          );
          _nameController.clear();
          _emailController.clear();
          _subjectController.clear();
          _messageController.clear();
        }
        if (state is ContactError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        appBar: AppBar(
          backgroundColor: const Color(0xFF7BBFB3),
          elevation: 0,
          title: const Text(
            'Contact Us',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          centerTitle: false,
          actions: [
            PopupMenuButton<String>(
              icon: const Icon(Icons.menu, color: Colors.white),
              color: Colors.white,
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              onSelected: (value) async {
                switch (value) {
                  case 'jobs':
                    if (!mounted) return;
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const JobListingPage()),
                    );
                    break;
                  case 'profile':
                    if (!mounted) return;
                    Navigator.pushNamed(context, '/profile');
                    break;
                  case 'jobstat':
                    if (!mounted) return;
                    Navigator.pushNamed(context, '/job_stats');
                    break;
                  case 'chatbot':
                    if (!mounted) return;
                    Navigator.pushNamed(context, '/chatbot');
                    break;
                  case 'admin_dashboard':
                    if (!mounted) return;
                    Navigator.pushNamed(context, '/admin_dashboard');
                    break;
                  case 'logout':
                    Navigator.popUntil(context, (route) => route.isFirst);
                    break;
                }
              },
              itemBuilder: (context) {
                final menuItems = <PopupMenuEntry<String>>[
                  PopupMenuItem(
                    value: 'jobs',
                    child: SizedBox(
                      width: 220,
                      child: Row(
                        children: const [
                          Icon(Icons.work_outline, color: Colors.black87),
                          SizedBox(width: 12),
                          Text('Jobs'),
                        ],
                      ),
                    ),
                  ),
                  PopupMenuItem(
                    value: 'profile',
                    child: SizedBox(
                      width: 220,
                      child: Row(
                        children: const [
                          Icon(Icons.person, color: Colors.black87),
                          SizedBox(width: 12),
                          Text('Profile'),
                        ],
                      ),
                    ),
                  ),
                  PopupMenuItem(
                    value: 'jobstat',
                    child: SizedBox(
                      width: 220,
                      child: Row(
                        children: const [
                          Icon(Icons.bar_chart, color: Colors.black87),
                          SizedBox(width: 12),
                          Text('JobStat'),
                        ],
                      ),
                    ),
                  ),
                  PopupMenuItem(
                    value: 'chatbot',
                    child: SizedBox(
                      width: 220,
                      child: Row(
                        children: const [
                          Icon(Icons.smart_toy, color: Colors.black87),
                          SizedBox(width: 12),
                          Text('Chatbot'),
                        ],
                      ),
                    ),
                  ),
                ];

                if (_isAdmin) {
                  menuItems.add(
                    PopupMenuItem(
                      value: 'admin_dashboard',
                      child: SizedBox(
                        width: 220,
                        child: Row(
                          children: const [
                            Icon(
                              Icons.admin_panel_settings,
                              color: Colors.blue,
                            ),
                            SizedBox(width: 12),
                            Text('Admin Dashboard'),
                          ],
                        ),
                      ),
                    ),
                  );
                }

                menuItems.add(const PopupMenuDivider());
                menuItems.add(
                  PopupMenuItem(
                    value: 'logout',
                    child: SizedBox(
                      width: 220,
                      child: Row(
                        children: const [
                          Icon(Icons.logout, color: Colors.redAccent),
                          SizedBox(width: 12),
                          Text('Logout'),
                        ],
                      ),
                    ),
                  ),
                );

                return menuItems;
              },
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Icon(
                      Icons.feedback,
                      size: 80,
                      color: const Color(0xFF7BBFB3),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'We\'d love to hear from you!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Fill out the form below and we will get back to you as soon as possible.',
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                  const SizedBox(height: 24),
                  buildTextField(
                    controller: _nameController,
                    labelText: 'Name',
                    icon: Icons.person_outline,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  buildTextField(
                    controller: _emailController,
                    labelText: 'Email',
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  buildTextField(
                    controller: _subjectController,
                    labelText: 'Subject',
                    icon: Icons.subject_outlined,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a subject';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  buildTextField(
                    controller: _messageController,
                    labelText: 'Message',
                    icon: Icons.message_outlined,
                    maxLines: 5,
                    iconAlignmentTop: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your message';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: BlocBuilder<ContactBloc, ContactState>(
                      builder: (context, state) {
                        return ElevatedButton(
                          onPressed: state is ContactLoading ? null : _sendForm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF7BBFB3),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 48,
                              vertical: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: state is ContactLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  'Send Message',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
