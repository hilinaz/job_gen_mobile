import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:job_gen_mobile/core/error/failures.dart';
import 'package:job_gen_mobile/features/files/domain/usecases/delete_file.dart';
import 'package:job_gen_mobile/features/files/domain/usecases/upload_profile_picture.dart';
import 'package:job_gen_mobile/features/user_profile/domain/entity/user_profile.dart';

class UserCard extends StatefulWidget {
  final UserProfile? userProfile;
  final Future<void> Function(UserProfile) onSave;
  final UploadProfilePicture updateProfilePicture;
  final DeleteFileById deleteProfilePictureById;

  const UserCard({
    super.key,
    this.userProfile,
    required this.onSave,
    required this.updateProfilePicture,
    required this.deleteProfilePictureById,
  });

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _bioController;
  late TextEditingController _locationController;
  late TextEditingController _phoneController;
  late TextEditingController _experienceController;
  late TextEditingController _skillsController;
  late TextEditingController _profilePictureController;
  bool _isEditing = false;
  bool _isLoading = false;
  bool _isUploading = false;
  bool _isDeleting = false;
  final ImagePicker _imagePicker = ImagePicker();

  Future<void> _pickAndUploadImage() async {
    if (_isUploading) return;

    try {
      setState(() => _isUploading = true);

      // Show options to pick from gallery or camera
      final XFile? pickedFile = await showModalBottomSheet<XFile>(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Gallery'),
                  onTap: () async {
                    final file = await _imagePicker.pickImage(
                      source: ImageSource.gallery,
                      imageQuality: 85,
                      maxWidth: 800,
                    );
                    if (file != null) {
                      Navigator.of(context).pop(file);
                    }
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Camera'),
                  onTap: () async {
                    final file = await _imagePicker.pickImage(
                      source: ImageSource.camera,
                      imageQuality: 85,
                      maxWidth: 800,
                    );
                    if (file != null) {
                      Navigator.of(context).pop(file);
                    }
                  },
                ),
              ],
            ),
          );
        },
      );

      if (pickedFile == null) return;

      // Upload the image
      final result = await widget.updateProfilePicture(
        fileName: 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg',
        contentType: 'image/jpeg',
        bytes: await pickedFile.readAsBytes(),
      );

      result.fold(
        (failure) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(_mapFailureToMessage(failure)),
              backgroundColor: Colors.red,
            ),
          );
        },
        (imageUrl) {
          if (!mounted) return;
          // Update the profile picture URL in the UI
          setState(() {
            _profilePictureController.text = imageUrl.toString();
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile picture updated successfully'),
              backgroundColor: Colors.green,
            ),
          );
        },
      );
    } catch (e) {
      print('Error in _pickAndUploadImage: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isUploading = false);
      }
    }
  }

  Future<void> _deleteProfilePictureById() async {
    if (_isDeleting || _profilePictureController.text.isEmpty) return;

    try {
      setState(() => _isDeleting = true);

      // Show confirmation dialog
      final bool confirmDelete = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Delete Profile Picture'),
            content: const Text(
              'Are you sure you want to delete your profile picture?',
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          );
        },
      );

      if (!confirmDelete) return;

      // Delete the profile picture
      final result = await widget.deleteProfilePictureById(
        _profilePictureController.text,
      );

      result.fold(
        (failure) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(_mapFailureToMessage(failure)),
              backgroundColor: Colors.red,
            ),
          );
        },
        (_) {
          if (!mounted) return;
          // Clear the profile picture URL in the UI
          setState(() {
            _profilePictureController.text = '';
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile picture deleted successfully'),
            ),
          );
        },
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isDeleting = false);
      }
    }
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Server error: ${failure.message}';
      case NetworkFailure:
        return 'Network error: ${failure.message}';
      default:
        return 'An error occurred: ${failure.message}';
    }
  }

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.userProfile?.fullName ?? '',
    );
    _emailController = TextEditingController(
      text: widget.userProfile?.email ?? '',
    );
    _bioController = TextEditingController(text: widget.userProfile?.bio ?? '');
    _locationController = TextEditingController(
      text: widget.userProfile?.location ?? '',
    );
    _phoneController = TextEditingController(
      text: widget.userProfile?.phoneNumber ?? '',
    );
    _experienceController = TextEditingController(
      text: widget.userProfile?.experienceYears?.toString() ?? '0',
    );
    _skillsController = TextEditingController(
      text: (widget.userProfile?.skills ?? []).join(', '),
    );
    _profilePictureController = TextEditingController(
      text: widget.userProfile?.profilePicture ?? '',
    );
  }

  @override
  void didUpdateWidget(covariant UserCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.userProfile != widget.userProfile) {
      _nameController.text = widget.userProfile?.fullName ?? '';
      _emailController.text = widget.userProfile?.email ?? '';
      _bioController.text = widget.userProfile?.bio ?? '';
      _locationController.text = widget.userProfile?.location ?? '';
      _phoneController.text = widget.userProfile?.phoneNumber ?? '';
      _experienceController.text =
          widget.userProfile?.experienceYears?.toString() ?? '';
      _skillsController.text = (widget.userProfile?.skills ?? []).join(', ');
      _profilePictureController.text = widget.userProfile?.profilePicture ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _bioController.dispose();
    _locationController.dispose();
    _phoneController.dispose();
    _experienceController.dispose();
    _skillsController.dispose();
    _profilePictureController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    print('Starting save process...');

    if (_nameController.text.isEmpty || _emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Name and email are required')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      // Parse experience years
      int? exp;
      if (_experienceController.text.trim().isNotEmpty) {
        exp = int.tryParse(_experienceController.text.trim());
        if (exp == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please enter a valid number for experience years'),
            ),
          );
          return;
        }
      }

      // Parse skills as comma-separated list
      final skills = _skillsController.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      // Create the updated profile
      final updatedProfile = UserProfile(
        id: widget.userProfile?.id ?? '',
        username:
            widget.userProfile?.username ??
            _emailController.text.split('@').first,
        email: _emailController.text,
        fullName: _nameController.text,
        bio: _bioController.text,
        skills: skills.isNotEmpty ? skills : (widget.userProfile?.skills ?? []),
        experienceYears: exp ?? widget.userProfile?.experienceYears,
        location: _locationController.text.isNotEmpty
            ? _locationController.text
            : widget.userProfile?.location,
        phoneNumber: _phoneController.text.isNotEmpty
            ? _phoneController.text
            : widget.userProfile?.phoneNumber,
        profilePicture: _profilePictureController.text.isNotEmpty
            ? _profilePictureController.text
            : widget.userProfile?.profilePicture,
        active: widget.userProfile?.active ?? true,
      );

      // Call the onSave function
      await widget.onSave(updatedProfile);

      setState(() => _isEditing = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
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
                  Stack(
                    children: [
                      _isUploading || _isDeleting
                          ? Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey[200],
                              ),
                              child: Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Theme.of(context).primaryColor,
                                  ),
                                ),
                              ),
                            )
                          : CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.grey[200],
                              backgroundImage:
                                  _profilePictureController.text.isNotEmpty
                                  ? NetworkImage(_profilePictureController.text)
                                  : null,
                              child: _profilePictureController.text.isEmpty
                                  ? const Icon(
                                      Icons.person,
                                      size: 50,
                                      color: Colors.grey,
                                    )
                                  : null,
                            ),
                      if (_isEditing)
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Row(
                            children: [
                              // Upload button
                              InkWell(
                                onTap: _isUploading || _isDeleting
                                    ? null
                                    : _pickAndUploadImage,
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 4,
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.add_a_photo,
                                    size: 20,
                                    color: _isUploading || _isDeleting
                                        ? Colors.grey
                                        : Colors.black87,
                                  ),
                                ),
                              ),
                              // Delete button
                              if (_profilePictureController
                                  .text
                                  .isNotEmpty) ...[
                                const SizedBox(width: 8),
                                InkWell(
                                  onTap: _isUploading || _isDeleting
                                      ? null
                                      : _deleteProfilePictureById,
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          blurRadius: 4,
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      Icons.delete,
                                      size: 20,
                                      color: _isUploading || _isDeleting
                                          ? Colors.grey
                                          : Colors.red,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Name
                  Center(
                    child: Text(
                      _isEditing
                          ? 'Edit Profile'
                          : widget.userProfile?.fullName ?? 'No Name',
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            color: Colors.teal,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Bio
                  if (widget.userProfile?.bio?.isNotEmpty == true &&
                      !_isEditing)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Text(
                        widget.userProfile!.bio!,
                        textAlign: TextAlign.center,
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.copyWith(fontSize: 15),
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
                        _nameController.text =
                            widget.userProfile?.fullName ?? '';
                        _emailController.text = widget.userProfile?.email ?? '';
                        _bioController.text = widget.userProfile?.bio ?? '';
                        _locationController.text =
                            widget.userProfile?.location ?? '';
                        _phoneController.text =
                            widget.userProfile?.phoneNumber ?? '';
                        _experienceController.text =
                            widget.userProfile?.experienceYears?.toString() ??
                            '';
                        _skillsController.text =
                            (widget.userProfile?.skills ?? []).join(', ');
                        _profilePictureController.text =
                            widget.userProfile?.profilePicture ?? '';
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
                  backgroundColor: Colors.teal,
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
        const SizedBox(height: 16.0),
        UserCardInput(
          title: 'Location',
          placeholder: 'Where are you based?',
          controller: _locationController,
          enabled: !_isLoading,
        ),
        const SizedBox(height: 16.0),
        UserCardInput(
          title: 'Phone Number',
          placeholder: 'Enter your phone number',
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          enabled: !_isLoading,
        ),
        const SizedBox(height: 16.0),
        UserCardInput(
          title: 'Experience Years',
          placeholder: 'e.g., 3',
          controller: _experienceController,
          keyboardType: TextInputType.number,
          enabled: !_isLoading,
        ),
        const SizedBox(height: 16.0),
        UserCardInput(
          title: 'Skills',
          placeholder: 'Comma separated (e.g., Dart, Flutter, REST)',
          controller: _skillsController,
          enabled: !_isLoading,
        ),
        const SizedBox(height: 16.0),
        UserCardInput(
          title: 'Profile Picture URL',
          placeholder: 'https://... (optional)',
          controller: _profilePictureController,
          keyboardType: TextInputType.url,
          enabled: !_isLoading,
        ),
      ],
    );
  }

  Widget _buildViewMode() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            'Personal Information',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        if (widget.userProfile != null) ...[
          _buildInfoRow(
            Icons.email,
            widget.userProfile!.email,
            'Email Address',
          ),
          if (widget.userProfile?.fullName?.isNotEmpty == true)
            _buildInfoRow(
              Icons.person,
              widget.userProfile!.fullName!,
              'Full Name',
            ),
          if (widget.userProfile?.location?.isNotEmpty == true)
            _buildInfoRow(
              Icons.location_on,
              widget.userProfile!.location!,
              'Location',
            ),
          if (widget.userProfile?.phoneNumber?.isNotEmpty == true)
            _buildInfoRow(
              Icons.phone,
              widget.userProfile!.phoneNumber!,
              'Phone Number',
            ),
          if (widget.userProfile?.experienceYears != null)
            _buildInfoRow(
              Icons.work,
              '${widget.userProfile!.experienceYears} years of experience',
              'Experience',
            ),
          if (widget.userProfile?.skills?.isNotEmpty == true)
            _buildInfoRow(
              Icons.code,
              widget.userProfile!.skills!.join(', '),
              'Skills',
            ),
        ] else
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                'No profile information available. Tap edit to create one.',
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String value, String key) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Text(
              key,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              textAlign: TextAlign.start,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 12.0,
              horizontal: 16.0,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 1,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 20, color: Colors.teal[300]),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    value,
                    textAlign: TextAlign.start,
                    style: const TextStyle(fontSize: 15, height: 1.4),
                  ),
                ),
              ],
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




// save changes