import 'package:flutter/material.dart';
import 'package:job_gen_mobile/features/user_profile/presentation/widgets/cv_card.dart';
import 'package:job_gen_mobile/features/user_profile/presentation/widgets/prefered_location_card.dart';
import 'package:job_gen_mobile/features/user_profile/presentation/widgets/skilled_set.dart';
import 'package:job_gen_mobile/features/user_profile/presentation/widgets/user_card.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final TextEditingController _nameController = TextEditingController(text: "Random User");
  final TextEditingController _emailController = TextEditingController(text: "RandomUser@gmail.com");
  final TextEditingController _occupationController = TextEditingController(text: "UX Designer");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF7BBFB3),
        title: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12.0,
          ), // Whole AppBar content padding
          child: Row(
            children: [
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 8),
                ),
                child: Container(
                  margin: const EdgeInsets.all(4), // optional: adjust spacing
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF7BBFB3),
                  ),
                ),
              ),
              const SizedBox(width: 12), // Space between icon and title
              const Text(
                'JobGen',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              icon: const Icon(Icons.menu, color: Colors.white, size: 34),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              
              UserCard(
                nameController: _nameController,
                emailController: _emailController,
                occupationController: _occupationController,
              ),


              CVCard(newUser: false,),
              PreferedLocationCard(),
              SkilledSetCard(),
            ],
          ),
        )
      
    );
  }
}




class SkillChips extends StatelessWidget {
  const SkillChips({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _buildSkillChip('UI/UX Design'),
        _buildSkillChip('Wireframing'),
        _buildSkillChip('Prototyping'),
        _buildSkillChip('User Research'),
        _buildSkillChip('Figma'),
        _buildSkillChip('Adobe XD'),
      ],
    );
  }
  

  Widget _buildSkillChip(String skill) {
    return Chip(
      backgroundColor: const Color(0xFFE8F5F2),
      label: Text(
        skill,
        style: const TextStyle(color: Color(0xFF7BBFB3)),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}