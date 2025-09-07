// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:job_gen_mobile/features/user_profile/domain/entity/user_profile.dart';

// class UserCard extends StatefulWidget {
//   final UserProfile? userProfile;
//   final Future<void> Function(UserProfile) onSave;

//   const UserCard({super.key, this.userProfile, required this.onSave});

//   @override
//   State<UserCard> createState() => _UserCardState();
// }

// class _UserCardState extends State<UserCard> {
//   late TextEditingController _nameController;
//   late TextEditingController _emailController;
//   late TextEditingController _bioController;
//   late TextEditingController _locationController;
//   late TextEditingController _phoneController;
//   late TextEditingController _experienceController;
//   late TextEditingController _skillsController;
//   late TextEditingController _profilePictureController;
//   bool _isEditing = false;
//   bool _isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     _nameController = TextEditingController(
//       text: widget.userProfile?.fullName ?? '',
//     );
//     _emailController = TextEditingController(
//       text: widget.userProfile?.email ?? '',
//     );
//     _bioController = TextEditingController(text: widget.userProfile?.bio ?? '');
//     _locationController = TextEditingController(
//       text: widget.userProfile?.location ?? '',
//     );
//     _phoneController = TextEditingController(
//       text: widget.userProfile?.phoneNumber ?? '',
//     );
//     _experienceController = TextEditingController(
//       text: widget.userProfile?.experienceYears?.toString() ?? '',
//     );
//     _skillsController = TextEditingController(
//       text: (widget.userProfile?.skills ?? []).join(', '),
//     );
//     _profilePictureController = TextEditingController(
//       text: widget.userProfile?.profilePicture ?? '',
//     );
//   }

//   @override
//   void didUpdateWidget(covariant UserCard oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (oldWidget.userProfile != widget.userProfile) {
//       _nameController.text = widget.userProfile?.fullName ?? '';
//       _emailController.text = widget.userProfile?.email ?? '';
//       _bioController.text = widget.userProfile?.bio ?? '';
//       _locationController.text = widget.userProfile?.location ?? '';
//       _phoneController.text = widget.userProfile?.phoneNumber ?? '';
//       _experienceController.text =
//           widget.userProfile?.experienceYears?.toString() ?? '';
//       _skillsController.text = (widget.userProfile?.skills ?? []).join(', ');
//       _profilePictureController.text = widget.userProfile?.profilePicture ?? '';
//     }
//   }

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _emailController.dispose();
//     _bioController.dispose();
//     _locationController.dispose();
//     _phoneController.dispose();
//     _experienceController.dispose();
//     _skillsController.dispose();
//     _profilePictureController.dispose();
//     super.dispose();
//   }

//   Future<void> _handleSave() async {
//     if (_nameController.text.isEmpty || _emailController.text.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Name and email are required')),
//       );
//       return;
//     }

//     setState(() => _isLoading = true);
//     try {
//       // Parse experience years
//       int? exp;
//       if (_experienceController.text.trim().isNotEmpty) {
//         exp = int.tryParse(_experienceController.text.trim());
//       }

//       // Parse skills as comma-separated list
//       final skills = _skillsController.text
//           .split(',')
//           .map((e) => e.trim())
//           .where((e) => e.isNotEmpty)
//           .toList();

//       await widget.onSave(
//         UserProfile(
//           id: widget.userProfile?.id ?? '',
//           username:
//               widget.userProfile?.username ??
//               _emailController.text.split('@').first,
//           email: _emailController.text,
//           fullName: _nameController.text,
//           bio: _bioController.text,
//           skills: skills.isNotEmpty
//               ? skills
//               : (widget.userProfile?.skills ?? []),
//           experienceYears: exp ?? widget.userProfile?.experienceYears,
//           location: _locationController.text.isNotEmpty
//               ? _locationController.text
//               : widget.userProfile?.location,
//           phoneNumber: _phoneController.text.isNotEmpty
//               ? _phoneController.text
//               : widget.userProfile?.phoneNumber,
//           profilePicture: _profilePictureController.text.isNotEmpty
//               ? _profilePictureController.text
//               : widget.userProfile?.profilePicture,
//           active: widget.userProfile?.active ?? true,
//         ),
//       );
//       setState(() => _isEditing = false);
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed to save: ${e.toString()}')),
//         );
//       }
//     } finally {
//       if (mounted) {
//         setState(() => _isLoading = false);
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(16.0),
//       margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
//       decoration: BoxDecoration(
//         color: const Color.fromARGB(255, 255, 255, 255),
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.4),
//             blurRadius: 5,
//             spreadRadius: 2,
//             offset: const Offset(6, 8),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Stack(
//             alignment: Alignment.topRight,
//             children: [
//               Column(
//                 children: [
//                   const SizedBox(height: 24),
//                   // Profile Picture
//                   Stack(
//                     children: [
//                       CircleAvatar(
//                         radius: 50,
//                         backgroundColor: Colors.grey[200],
//                         backgroundImage:
//                             widget.userProfile?.profilePicture != null
//                             ? NetworkImage(widget.userProfile!.profilePicture!)
//                             : const AssetImage('assets/images/avator.png')
//                                   as ImageProvider,
//                         child: widget.userProfile?.profilePicture == null
//                             ? const Icon(
//                                 Icons.person,
//                                 size: 50,
//                                 color: Colors.grey,
//                               )
//                             : null,
//                       ),
//                       Positioned(
//                         bottom: 0,
//                         right: 0,
//                         child: InkWell(
//                           onTap: () async {
//                             final pickedFile = await ImagePicker().pickImage(
//                               source: ImageSource.gallery,
//                             );
//                             if (pickedFile != null) {
//                               final imageBytes = await pickedFile.readAsBytes();
//                               // TODO: Upload imageBytes to Supabase or your backend
//                               // Then call setState to refresh the UI
//                               setState(() {
//                                 // Update local state or trigger a reload
//                               });
//                             }
//                           },
//                           child: Container(
//                             padding: const EdgeInsets.all(6),
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               shape: BoxShape.circle,
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.black.withOpacity(0.2),
//                                   blurRadius: 4,
//                                 ),
//                               ],
//                             ),
//                             child: const Icon(
//                               Icons.add_a_photo,
//                               size: 20,
//                               color: Colors.black87,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 16),
//                   // Name
//                   Center(
//                     child: Text(
//                       _isEditing
//                           ? 'Edit Profile'
//                           : widget.userProfile?.fullName ?? 'No Name',
//                       style: Theme.of(context).textTheme.headlineMedium
//                           ?.copyWith(
//                             color: Colors.teal,
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                           ),
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   // Bio
//                   if (widget.userProfile?.bio?.isNotEmpty == true &&
//                       !_isEditing)
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 24.0),
//                       child: Text(
//                         widget.userProfile!.bio!,
//                         textAlign: TextAlign.center,
//                         style: Theme.of(
//                           context,
//                         ).textTheme.bodyMedium?.copyWith(fontSize: 15),
//                       ),
//                     ),
//                 ],
//               ),
//               if (!_isLoading)
//                 IconButton(
//                   icon: Icon(_isEditing ? Icons.close : Icons.edit),
//                   onPressed: () {
//                     setState(() {
//                       _isEditing = !_isEditing;
//                       if (!_isEditing) {
//                         // Reset controllers when canceling edit
//                         _nameController.text =
//                             widget.userProfile?.fullName ?? '';
//                         _emailController.text = widget.userProfile?.email ?? '';
//                         _bioController.text = widget.userProfile?.bio ?? '';
//                       }
//                     });
//                   },
//                 ),
//             ],
//           ),
//           const SizedBox(height: 24),
//           // Edit Form / View Mode
//           _isEditing ? _buildEditForm() : _buildViewMode(),
//           // Save Button (only in edit mode)
//           if (_isEditing) ...[
//             const SizedBox(height: 24),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: _isLoading ? null : _handleSave,
//                 style: ElevatedButton.styleFrom(
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                   backgroundColor: Theme.of(context).primaryColor,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 child: _isLoading
//                     ? const SizedBox(
//                         width: 20,
//                         height: 20,
//                         child: CircularProgressIndicator(
//                           color: Colors.white,
//                           strokeWidth: 2,
//                         ),
//                       )
//                     : const Text(
//                         'Save Changes',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                         ),
//                       ),
//               ),
//             ),
//           ],
//         ],
//       ),
//     );
//   }

//   Widget _buildEditForm() {
//     return Column(
//       children: [
//         UserCardInput(
//           title: 'Full Name',
//           placeholder: 'Enter your full name',
//           controller: _nameController,
//           enabled: !_isLoading,
//         ),
//         const SizedBox(height: 16.0),
//         UserCardInput(
//           title: 'Email',
//           placeholder: 'Enter your email',
//           controller: _emailController,
//           keyboardType: TextInputType.emailAddress,
//           enabled: !_isLoading,
//         ),
//         const SizedBox(height: 16.0),
//         UserCardInput(
//           title: 'Bio',
//           placeholder: 'Tell us about yourself',
//           controller: _bioController,
//           maxLines: 3,
//           enabled: !_isLoading,
//         ),
//         const SizedBox(height: 16.0),
//         UserCardInput(
//           title: 'Location',
//           placeholder: 'Where are you based?',
//           controller: _locationController,
//           enabled: !_isLoading,
//         ),
//         const SizedBox(height: 16.0),
//         UserCardInput(
//           title: 'Phone Number',
//           placeholder: 'Enter your phone number',
//           controller: _phoneController,
//           keyboardType: TextInputType.phone,
//           enabled: !_isLoading,
//         ),
//         const SizedBox(height: 16.0),
//         UserCardInput(
//           title: 'Experience Years',
//           placeholder: 'e.g., 3',
//           controller: _experienceController,
//           keyboardType: TextInputType.number,
//           enabled: !_isLoading,
//         ),
//         const SizedBox(height: 16.0),
//         UserCardInput(
//           title: 'Skills',
//           placeholder: 'Comma separated (e.g., Dart, Flutter, REST)',
//           controller: _skillsController,
//           enabled: !_isLoading,
//         ),
//         const SizedBox(height: 16.0),
//         UserCardInput(
//           title: 'Profile Picture URL',
//           placeholder: 'https://... (optional)',
//           controller: _profilePictureController,
//           keyboardType: TextInputType.url,
//           enabled: !_isLoading,
//         ),
//       ],
//     );
//   }

//   Widget _buildViewMode() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         Padding(
//           padding: const EdgeInsets.only(bottom: 8),
//           child: Text(
//             'Personal Information',
//             style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//           ),
//         ),
//         if (widget.userProfile != null) ...[
//           _buildInfoRow(
//             Icons.email,
//             widget.userProfile!.email,
//             'Email Address',
//           ),
//           if (widget.userProfile?.location?.isNotEmpty == true)
//             _buildInfoRow(
//               Icons.verified_user,
//               widget.userProfile!.fullName,
//               'Full Name',
//             ),
//           if (widget.userProfile?.phoneNumber?.isNotEmpty == true)
//             _buildInfoRow(
//               Icons.phone,
//               widget.userProfile!.phoneNumber!,
//               'Phone Number',
//             ),
//           if (widget.userProfile?.experienceYears != null)
//             _buildInfoRow(
//               Icons.work,
//               '${widget.userProfile!.experienceYears} years of experience',
//               'Experience',
//             ),
//         ] else
//           const Padding(
//             padding: EdgeInsets.all(16.0),
//             child: Center(
//               child: Text(
//                 'No profile information available. Tap edit to create one.',
//               ),
//             ),
//           ),
//       ],
//     );
//   }

//   Widget _buildInfoRow(IconData icon, String value, String key) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(left: 12.0),
//             child: Text(
//               key,
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//               textAlign: TextAlign.start,
//             ),
//           ),
//           Container(
//             padding: const EdgeInsets.symmetric(
//               vertical: 12.0,
//               horizontal: 16.0,
//             ),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(12),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.1),
//                   blurRadius: 10,
//                   spreadRadius: 1,
//                   offset: const Offset(0, 1),
//                 ),
//               ],
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Icon(icon, size: 20, color: Colors.teal[300]),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: Text(
//                     value,
//                     textAlign: TextAlign.start,
//                     style: const TextStyle(fontSize: 15, height: 1.4),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class UserCardInput extends StatelessWidget {
//   final String title;
//   final String placeholder;
//   final TextEditingController controller;
//   final TextInputType? keyboardType;
//   final int? maxLines;
//   final bool enabled;

//   const UserCardInput({
//     super.key,
//     required this.title,
//     required this.placeholder,
//     required this.controller,
//     this.keyboardType,
//     this.maxLines = 1,
//     this.enabled = true,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           title,
//           style: const TextStyle(
//             fontSize: 14,
//             fontWeight: FontWeight.w500,
//             color: Colors.black87,
//           ),
//         ),
//         const SizedBox(height: 6),
//         Container(
//           decoration: BoxDecoration(
//             color: enabled ? Colors.grey[100] : Colors.grey[200],
//             borderRadius: BorderRadius.circular(12),
//             border: Border.all(color: Colors.grey[300]!),
//           ),
//           child: TextField(
//             controller: controller,
//             keyboardType: keyboardType,
//             maxLines: maxLines,
//             enabled: enabled,
//             decoration: InputDecoration(
//               contentPadding: const EdgeInsets.symmetric(
//                 horizontal: 16,
//                 vertical: 14,
//               ),
//               hintText: placeholder,
//               hintStyle: TextStyle(color: Colors.grey[500]),
//               border: InputBorder.none,
//               isDense: true,
//             ),
//             style: const TextStyle(fontSize: 15),
//           ),
//         ),
//       ],
//     );
//   }
// }

// // save changes

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:job_gen_mobile/core/error/failures.dart';
import 'package:job_gen_mobile/features/user_profile/domain/entity/user_profile.dart';
import 'package:job_gen_mobile/features/user_profile/domain/usecases/user_profile/update_profile_picture.dart';
import 'package:job_gen_mobile/features/user_profile/domain/usecases/user_profile/delete_profile_picture.dart';

class UserCard extends StatefulWidget {
  final UserProfile? userProfile;
  final Future<void> Function(UserProfile) onSave;
  final UpdateProfilePicture updateProfilePicture;
  final DeleteProfilePicture deleteProfilePicture;

  const UserCard({
    super.key,
    this.userProfile,
    required this.onSave,
    required this.updateProfilePicture,
    required this.deleteProfilePicture,
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
                    Navigator.of(context).pop(
                      await _imagePicker.pickImage(
                        source: ImageSource.gallery,
                        imageQuality: 85,
                        maxWidth: 800,
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Camera'),
                  onTap: () async {
                    Navigator.of(context).pop(
                      await _imagePicker.pickImage(
                        source: ImageSource.camera,
                        imageQuality: 85,
                        maxWidth: 800,
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      );

      if (pickedFile == null) return;

      // Show loading indicator
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Uploading image...')));

      // Upload the image
      final result = await widget.updateProfilePicture(File(pickedFile.path));

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
        setState(() => _isUploading = false);
      }
    }
  }

  Future<void> _deleteProfilePicture() async {
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
      final result = await widget.deleteProfilePicture();

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
    if (!_isLoading) {
      setState(() => _isLoading = true);
      try {
        final updatedProfile = UserProfile(
          id: widget.userProfile?.id ?? '',
          username: widget.userProfile?.username ?? '',
          fullName: _nameController.text,
          email: _emailController.text,
          bio: _bioController.text,
          location: _locationController.text,
          phoneNumber: _phoneController.text,
          experienceYears: int.tryParse(_experienceController.text) ?? 0,
          skills: _skillsController.text
              .split(',')
              .map((s) => s.trim())
              .where((s) => s.isNotEmpty)
              .toList(),
          profilePicture: _profilePictureController.text,
          active: widget.userProfile?.active ?? true,
        );
        await widget.onSave(updatedProfile);
        setState(() => _isEditing = false);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Failed to save profile: $e')));
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  void _toggleEditMode() {
    setState(() => _isEditing = !_isEditing);
    if (!_isEditing) {
      // Reset controllers when canceling edit
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
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Header Section
            _buildProfileHeader(context),

            // Edit Form or View Mode Section
            const SizedBox(height: 24),
            _isEditing ? _buildEditForm() : _buildViewMode(),

            // Save Button (only in edit mode)
            if (_isEditing)
              ...[
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
                        ? Container(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            'Save Changes',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                  ),
                ),
              ].toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Row(
      children: [
        Stack(
          children: [
            // Profile Picture with loading state
            _isUploading || _isDeleting
                ? Container(
                    width: 80,
                    height: 80,
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
                    radius: 40,
                    backgroundImage: _profilePictureController.text.isNotEmpty
                        ? NetworkImage(_profilePictureController.text)
                        : null,
                    child: _profilePictureController.text.isEmpty
                        ? Icon(Icons.person, size: 40, color: Colors.grey[600])
                        : null,
                  ),
            // Edit and delete buttons (only in edit mode)
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
                        padding: EdgeInsets.all(6),
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
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    // Delete button (only shown if there's a profile picture)
                    if (_profilePictureController.text.isNotEmpty) ...[
                      SizedBox(width: 8),
                      InkWell(
                        onTap: _isUploading || _isDeleting
                            ? null
                            : _deleteProfilePicture,
                        child: Container(
                          padding: EdgeInsets.all(6),
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
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
          ],
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _nameController.text.isNotEmpty
                    ? _nameController.text
                    : 'No Name',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: 4),
              Text(
                _emailController.text.isNotEmpty
                    ? _emailController.text
                    : 'No Email',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        IconButton(
          icon: _isLoading
              ? Container(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Icon(_isEditing ? Icons.close : Icons.edit),
          onPressed: _isLoading || _isUploading || _isDeleting
              ? null
              : _toggleEditMode,
        ),
      ],
    );
  }

  Widget _buildEditForm() {
    return Column(
      children: [
        TextField(
          controller: _nameController,
          enabled: !_isLoading,
          decoration: const InputDecoration(
            labelText: 'Full Name',
            hintText: 'Enter your full name',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _emailController,
          enabled: !_isLoading,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            labelText: 'Email',
            hintText: 'Enter your email',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _bioController,
          enabled: !_isLoading,
          maxLines: 3,
          decoration: const InputDecoration(
            labelText: 'Bio',
            hintText: 'Tell us about yourself',
            border: OutlineInputBorder(),
            alignLabelWithHint: true,
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _locationController,
          enabled: !_isLoading,
          decoration: const InputDecoration(
            labelText: 'Location',
            hintText: 'Enter your location',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _phoneController,
          enabled: !_isLoading,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(
            labelText: 'Phone',
            hintText: 'Enter your phone number',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _experienceController,
          enabled: !_isLoading,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Years of Experience',
            hintText: 'Enter years of experience',
            border: OutlineInputBorder(),
          ),
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_bioController.text.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            'About',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            _bioController.text,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
        const SizedBox(height: 16),
        Row(
          children: [
            Icon(Icons.email_outlined, size: 20, color: Colors.grey[600]),
            const SizedBox(width: 8),
            Text(
              _emailController.text,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
        if (_locationController.text.isNotEmpty) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 20,
                color: Colors.grey[600],
              ),
              const SizedBox(width: 8),
              Text(
                _locationController.text,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ],
        if (_phoneController.text.isNotEmpty) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.phone_outlined, size: 20, color: Colors.grey[600]),
              const SizedBox(width: 8),
              Text(
                _phoneController.text,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ],
        if (_experienceController.text.isNotEmpty &&
            _experienceController.text != '0') ...[
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.work_outline, size: 20, color: Colors.grey[600]),
              const SizedBox(width: 8),
              Text(
                '${_experienceController.text} years of experience',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ],
      ],
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
