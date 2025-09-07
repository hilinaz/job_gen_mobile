import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SkilledSetCard extends StatelessWidget {
  final List<String> skills;
  final ValueChanged<List<String>>? onSkillsChanged;

  const SkilledSetCard({
    super.key,
    this.skills = const <String>[],
    this.onSkillsChanged,
  });

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
          SkillMapCard(
            newUser: skills.isEmpty,
            initialSkills: skills,
            onSkillsChanged: onSkillsChanged,
          ),
        ],
      ),
    );
  }
}

class SkillMapCard extends StatefulWidget {
  final bool newUser;
  final List<String> initialSkills;
  final ValueChanged<List<String>>? onSkillsChanged;

  const SkillMapCard({
    super.key,
    required this.newUser,
    this.initialSkills = const <String>[],
    this.onSkillsChanged,
  });

  @override
  State<SkillMapCard> createState() => _SkillMapCardState();
}

class _SkillMapCardState extends State<SkillMapCard> {
  // Persisted skills array for backend; levels are local-only metadata
  final List<String> _skills = [];
  final Map<String, String> _levels = {};

  static const _prefsSkillsKey = 'user_skills_list';
  static const _prefsLevelsKey = 'user_skills_levels';

  @override
  void initState() {
    super.initState();
    // Seed with provided initial skills first
    if (widget.initialSkills.isNotEmpty) {
      _skills
        ..clear()
        ..addAll(widget.initialSkills);
    }
    _loadFromPrefs();
  }

  @override
  void didUpdateWidget(covariant SkillMapCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If parent passes new skills (e.g., after fetching profile), adopt them
    if (oldWidget.initialSkills != widget.initialSkills &&
        widget.initialSkills.isNotEmpty) {
      setState(() {
        _skills
          ..clear()
          ..addAll(widget.initialSkills);
      });
    }
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final savedSkills = prefs.getStringList(_prefsSkillsKey) ?? <String>[];
    final savedLevelsJson = prefs.getString(_prefsLevelsKey);
    Map<String, dynamic> levelsMap = {};
    if (savedLevelsJson != null && savedLevelsJson.isNotEmpty) {
      try {
        levelsMap = jsonDecode(savedLevelsJson) as Map<String, dynamic>;
      } catch (_) {}
    }
    setState(() {
      // Only override skills from prefs if prefs has data; otherwise keep initial ones
      if (savedSkills.isNotEmpty) {
        _skills
          ..clear()
          ..addAll(savedSkills);
      }
      _levels
        ..clear()
        ..addAll(levelsMap.map((k, v) => MapEntry(k, v?.toString() ?? '')));
    });
  }

  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_prefsSkillsKey, _skills);
    await prefs.setString(_prefsLevelsKey, jsonEncode(_levels));
  }

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
              title: 'Add New Skill',
              submitLabel: 'Add Skill',
              onSubmit: (skill, level) async {
                // Normalize and avoid duplicates
                final normalized = skill.trim();
                if (normalized.isEmpty) return;
                if (!_skills.contains(normalized)) {
                  setState(() {
                    _skills.add(normalized);
                    _levels[normalized] = level;
                  });
                  await _saveToPrefs();
                  widget.onSkillsChanged?.call(List<String>.from(_skills));
                  if (context.mounted) {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Added $normalized (Level: $level)'),
                        backgroundColor: Colors.teal,
                      ),
                    );
                  }
                } else {
                  _levels[normalized] = level; // update level if exists
                  await _saveToPrefs();
                  widget.onSkillsChanged?.call(List<String>.from(_skills));
                  if (context.mounted) {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Skill already exists; level updated'),
                      ),
                    );
                  }
                }
              },
            ),
          ),
        );
      },
    );
  }

  void _showEditSkillDialog({required int index}) {
    final oldSkill = _skills[index];
    final oldLevel = _levels[oldSkill] ?? '';
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
              title: 'Edit Skill',
              submitLabel: 'Save Changes',
              initialSkill: oldSkill,
              initialLevel: oldLevel,
              onSubmit: (newSkill, newLevel) async {
                final normalized = newSkill.trim();
                if (normalized.isEmpty) return;

                // If renaming to an existing skill (different index), just update level for that existing skill
                final existingIndex = _skills.indexOf(normalized);
                if (existingIndex != -1 && existingIndex != index) {
                  setState(() {
                    // remove old skill entry
                    final removed = _skills.removeAt(index);
                    _levels.remove(removed);
                    // update level of existing
                    _levels[normalized] = newLevel;
                  });
                } else {
                  setState(() {
                    _skills[index] = normalized;
                    // move level under new key
                    _levels.remove(oldSkill);
                    _levels[normalized] = newLevel;
                  });
                }

                await _saveToPrefs();
                widget.onSkillsChanged?.call(List<String>.from(_skills));
                if (context.mounted) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Skill updated')),
                  );
                }
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final listView = Column(
      children: [
        // Render dynamic skills list
        for (int i = 0; i < _skills.length; i++)
          ShowSkill(
            skill: _skills[i],
            level: _levels[_skills[i]] ?? '',
            index: i,
            onEdit: (idx) => _showEditSkillDialog(index: idx),
            onDelete: (idx) {
              final removed = _skills[idx];
              setState(() {
                _skills.removeAt(idx);
                _levels.remove(removed);
              });
              _saveToPrefs();
              widget.onSkillsChanged?.call(List<String>.from(_skills));
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Skill removed')));
            },
          ),
        const SizedBox(height: 6),
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton.icon(
            onPressed: _showAddSkillDialog,
            icon: const Icon(Icons.add, size: 20),
            label: const Text(
              'Add Skill',
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromRGBO(123, 191, 179, 1),
              iconColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
        ),
      ],
    );

    if (!widget.newUser) {
      return listView;
    } else {
      return Center(
        child: Column(
          children: [
            if (_skills.isEmpty) ...[
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
            ] else ...[
              listView,
            ],
          ],
        ),
      );
    }
  }
}

class AddSkill extends StatefulWidget {
  final Function(String skill, String level)? onSkillAdded; // legacy support
  final Function(String skill, String level)? onSubmit; // new generic submit
  final String? initialSkill;
  final String? initialLevel;
  final String? title;
  final String? submitLabel;

  const AddSkill({
    super.key,
    this.onSkillAdded,
    this.onSubmit,
    this.initialSkill,
    this.initialLevel,
    this.title,
    this.submitLabel,
  });

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
      final skill = _skillController.text.trim();
      final level = _selectedLevel ?? _levelController.text.trim();
      // Prefer new onSubmit if provided, else fallback to legacy onSkillAdded
      if (widget.onSubmit != null) {
        widget.onSubmit!(skill, level);
      } else if (widget.onSkillAdded != null) {
        widget.onSkillAdded!(skill, level);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Pre-fill fields if provided
    if ((_skillController.text.isEmpty) && (widget.initialSkill != null)) {
      _skillController.text = widget.initialSkill!;
    }
    if (_selectedLevel == null && (widget.initialLevel != null)) {
      _selectedLevel = widget.initialLevel;
    }

    // Ensure the dropdown's value is either null or in the list to avoid assertion
    if (_selectedLevel != null && !_skillLevels.contains(_selectedLevel)) {
      _selectedLevel = null;
    }

    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title ?? "Add New Skill",
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
                child: Text(
                  widget.submitLabel ?? 'Add Skill',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ShowSkill extends StatelessWidget {
  final String skill;
  final String level;
  final int index;
  final void Function(int index)? onDelete;
  final void Function(int index)? onEdit;

  const ShowSkill({
    super.key,
    required this.skill,
    required this.level,
    required this.index,
    this.onDelete,
    this.onEdit,
  });

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
              _formatSkill(skill),
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
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
            level,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () => onEdit?.call(index),
            child: const Icon(Icons.edit, size: 20),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () => onDelete?.call(index),
            child: const Icon(Icons.delete, color: Colors.red, size: 20),
          ),
        ],
      ),
    );
  }

  String _formatSkill(String skill) {
    if (skill.isEmpty) return '';
    return skill[0].toUpperCase() + skill.substring(1).toLowerCase();
  }
}
