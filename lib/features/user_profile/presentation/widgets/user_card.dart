import 'package:flutter/material.dart';
import 'package:job_gen_mobile/features/user_profile/domain/entity/user_profile.dart';

class UserCard extends StatefulWidget {
  final UserProfile? userProfile;
  final Future<void> Function(UserProfile) onSave;

  const UserCard({
    super.key,
    this.userProfile,
    required this.onSave,
  });

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _bioController;
  bool _isEditing = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.userProfile?.fullName ?? '');
    _emailController = TextEditingController(text: widget.userProfile?.email ?? '');
    _bioController = TextEditingController(text: widget.userProfile?.bio ?? '');
  }

  @override
  void didUpdateWidget(covariant UserCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.userProfile != widget.userProfile) {
      _nameController.text = widget.userProfile?.fullName ?? '';
      _emailController.text = widget.userProfile?.email ?? '';
      _bioController.text = widget.userProfile?.bio ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (_nameController.text.isEmpty || _emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Name and email are required')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      await widget.onSave(
        UserProfile(
          id: widget.userProfile?.id ?? '',
          username: widget.userProfile?.username ?? _emailController.text.split('@').first,
          email: _emailController.text,
          fullName: _nameController.text,
          bio: _bioController.text,
          skills: widget.userProfile?.skills ?? [],
          experienceYears: widget.userProfile?.experienceYears,
          location: widget.userProfile?.location,
          phoneNumber: widget.userProfile?.phoneNumber,
          profilePicture: widget.userProfile?.profilePicture,
          active: widget.userProfile?.active ?? true,
        ),
      );
      setState(() => _isEditing = false);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

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
            offset: const Offset(6, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              Column(
                children: [
                  const SizedBox(height: 24),
                  // Profile Picture
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[200],
                    backgroundImage: widget.userProfile?.profilePicture != null
                        ? NetworkImage(widget.userProfile!.profilePicture!)
                        : null,
                    child: widget.userProfile?.profilePicture == null
                        ? const Icon(Icons.person, size: 50, color: Colors.grey)
                        : null,
                  ),
                  const SizedBox(height: 16),
                  // Name
                  Center(
                    child: Text(
                      _isEditing ? 'Edit Profile' : widget.userProfile?.fullName ?? 'No Name',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Bio
                  if (widget.userProfile?.bio?.isNotEmpty == true && !_isEditing)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Text(
                        widget.userProfile!.bio!,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                ],
              ),
              if (!_isLoading)
                IconButton(
                  icon: Icon(_isEditing ? Icons.close : Icons.edit),
                  onPressed: () {
                    setState(() {
                      _isEditing = !_isEditing;
                      if (!_isEditing) {
                        // Reset controllers when canceling edit
                        _nameController.text = widget.userProfile?.fullName ?? '';
                        _emailController.text = widget.userProfile?.email ?? '';
                        _bioController.text = widget.userProfile?.bio ?? '';
                      }
                    });
                  },
                ),
            ],
          ),
          const SizedBox(height: 24),
          // Edit Form / View Mode
          _isEditing ? _buildEditForm() : _buildViewMode(),
          // Save Button (only in edit mode)
          if (_isEditing) ...[
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleSave,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Save Changes',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEditForm() {
    return Column(
      children: [
        UserCardInput(
          title: 'Full Name',
          placeholder: 'Enter your full name',
          controller: _nameController,
          enabled: !_isLoading,
        ),
        const SizedBox(height: 16.0),
        UserCardInput(
          title: 'Email',
          placeholder: 'Enter your email',
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          enabled: !_isLoading,
        ),
        const SizedBox(height: 16.0),
        UserCardInput(
          title: 'Bio',
          placeholder: 'Tell us about yourself',
          controller: _bioController,
          maxLines: 3,
          enabled: !_isLoading,
        ),
      ],
    );
  }

  Widget _buildViewMode() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.userProfile != null) ...[
          _buildInfoRow(Icons.email, widget.userProfile!.email),
          if (widget.userProfile?.location?.isNotEmpty == true)
            _buildInfoRow(Icons.location_on, widget.userProfile!.location!),
          if (widget.userProfile?.phoneNumber?.isNotEmpty == true)
            _buildInfoRow(Icons.phone, widget.userProfile!.phoneNumber!),
          if (widget.userProfile?.experienceYears != null)
            _buildInfoRow(
              Icons.work,
              '${widget.userProfile!.experienceYears} years of experience',
            ),
        ] else
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(
              child: Text('No profile information available. Tap edit to create one.'),
            ),
          ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 15, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}

class UserCardInput extends StatelessWidget {
  final String title;
  final String placeholder;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final int? maxLines;
  final bool enabled;

  const UserCardInput({
    super.key,
    required this.title,
    required this.placeholder,
    required this.controller,
    this.keyboardType,
    this.maxLines = 1,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: enabled ? Colors.grey[100] : Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
            enabled: enabled,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              hintText: placeholder,
              hintStyle: TextStyle(color: Colors.grey[500]),
              border: InputBorder.none,
              isDense: true,
            ),
            style: const TextStyle(fontSize: 15),
          ),
        ),
      ],
    );
  }
}