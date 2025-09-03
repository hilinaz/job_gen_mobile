import 'package:flutter/material.dart';
import '../../widget/widget.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF7BBFB3),
        toolbarHeight: 60,
        elevation: 10,
        title: const Padding(
          padding: EdgeInsets.only(left: 8.0, top: 8.0, bottom: 8.0),
          child: Text(
            'JobGen',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
        centerTitle: false,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios, size: 24),
             onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: const Icon(Icons.menu, size: 28),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 20.0,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Create an Account',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Sign up to continue your job search journey',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color.fromARGB(255, 75, 75, 75),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      buildSocialButton(
                        context,
                        icon: Icons.g_mobiledata_rounded,
                        text: 'SignUp with Google',
                      ),
                      const SizedBox(height: 16),
                      buildSocialButton(
                        context,
                        icon: Icons.mail_sharp,
                        text: 'SignUp with GitHub',
                      ),
                      const SizedBox(height: 32),
                      Row(
                        children: [
                          const Expanded(child: Divider()),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                            child: Text(
                              'OR SIGN UP WITH EMAIL',
                              style: TextStyle(
                                color: const Color.fromARGB(255, 70, 69, 69),
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const Expanded(child: Divider()),
                        ],
                      ),
                      const SizedBox(height: 32),
                      buildInputField('Full Name', 'Enter your full name'),
                      const SizedBox(height: 16),
                      buildInputField('Email Address', 'Enter your email'),
                      const SizedBox(height: 16),
                      buildInputField('Username', 'Enter your username'),
                      const SizedBox(height: 16),
                      buildInputField(
                        'Password',
                        'Enter your password',
                        isPassword: true,
                      ),
                      const SizedBox(height: 16),
                      buildInputField(
                        'Confirm Password',
                        'Confirm your password',
                        isPassword: true,
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6BBAA5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Already have an account? ',
                            style: TextStyle(fontSize: 14),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/sign_in');
                            },
                            child: const Text(
                              'Sign In',
                              style: TextStyle(
                                color: Color(0xFF6BBAA5),
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
