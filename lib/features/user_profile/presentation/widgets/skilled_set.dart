import 'package:flutter/material.dart';

class SkilledSetCard extends StatelessWidget {
  const SkilledSetCard({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    return Container(
      padding: const EdgeInsets.all(26.0),
      width: deviceWidth,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Skill Set',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          const SkillMapCard(newUser: false),
        ],
      ),
    );
  }
}

class SkillMapCard extends StatefulWidget {
  final bool newUser;

  const SkillMapCard({super.key, required this.newUser});

  @override
  State<SkillMapCard> createState() => _SkillMapCardState();
}

class _SkillMapCardState extends State<SkillMapCard> {
  void _showAddSkillDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: AddSkill(
              onSkillAdded: (skill, level) {
                // Handle the added skill here
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Added $skill (Level: $level)'),
                    backgroundColor: Colors.teal,
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.newUser) {
      return Column(
        children: [
          ShowSkill(level: 'Expert', skill: 'Front stack web developer'),
          ShowSkill(
            level: 'Expert',
            skill: 'Full Stack Flutter and Supabse developer',
          ),
          const SizedBox(height: 6),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              onPressed: () {
                _showAddSkillDialog();
              },
              icon: const Icon(Icons.add, size: 20),
              label: const Text(
                'Add Skill',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromRGBO(123, 191, 179, 1),
                iconColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      return Center(
        child: Column(
          children: [
            GestureDetector(
              onTap: _showAddSkillDialog,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.teal[50],
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.teal[300]!, width: 2),
                ),
                child: Icon(Icons.add, size: 30, color: Colors.teal[700]),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "Add your skill set",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      );
    }
  }
}

class AddSkill extends StatefulWidget {
  final Function(String skill, String level) onSkillAdded;

  const AddSkill({super.key, required this.onSkillAdded});

  @override
  State<AddSkill> createState() => _AddSkillState();
}

class _AddSkillState extends State<AddSkill> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _skillController = TextEditingController();
  final TextEditingController _levelController = TextEditingController();
  String? _selectedLevel;

  // Predefined skill levels
  final List<String> _skillLevels = [
    'Beginner',
    'Intermediate',
    'Advanced',
    'Expert',
  ];

  @override
  void dispose() {
    _skillController.dispose();
    _levelController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      widget.onSkillAdded(
        _skillController.text.trim(),
        _selectedLevel ?? _levelController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Add New Skill",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.teal[800],
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _skillController,
            decoration: InputDecoration(
              labelText: 'Skill Name',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              filled: true,
              fillColor: Colors.grey[50],
              prefixIcon: const Icon(Icons.work_outline),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a skill name';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: 'Skill Level',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              filled: true,
              fillColor: Colors.grey[50],
              prefixIcon: const Icon(Icons.star_outline),
            ),
            value: _selectedLevel,
            items: _skillLevels.map((String level) {
              return DropdownMenuItem<String>(value: level, child: Text(level));
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedLevel = newValue;
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select a skill level';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text(
                  'Add Skill',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ShowSkill extends StatefulWidget {
  final String skill;
  final String level;

  const ShowSkill({super.key, required this.skill, required this.level});

  @override
  State<ShowSkill> createState() => _ShowSkillState();
}

class _ShowSkillState extends State<ShowSkill> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              formatSkill(widget.skill), // 👈 lowercase
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16, // 👈 slightly smaller for better fit
                color: Colors.black87,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              softWrap: true,
              textAlign: TextAlign.left,
            ),
          ),
          const Spacer(),
          Text(
            widget.level,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () {
              debugPrint('Edited');
            },
            child: const Icon(Icons.edit, size: 20),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () {
              debugPrint('Deleted');
            },
            child: const Icon(Icons.delete, color: Colors.red, size: 20),
          ),
        ],
      ),
    );
  }

  String formatSkill(String skill) {
    if (skill.isEmpty) return '';
    return skill[0].toUpperCase() + skill.substring(1).toLowerCase();
  }
}
