import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:job_gen_mobile/features/user_profile/domain/entity/user_profile.dart';
import 'package:job_gen_mobile/features/user_profile/presentation/widgets/user_card/user_card.dart';
import 'package:job_gen_mobile/features/user_profile/presentation/widgets/user_card/user_card_edit_mode.dart';
import 'package:job_gen_mobile/features/user_profile/presentation/widgets/user_card/user_card_view_mode.dart';
import 'user_card_helpers.dart';
import 'user_card_image_picker.dart';

class UserCardController extends State<UserCard> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController bioController;
  late TextEditingController locationController;
  late TextEditingController phoneController;
  late TextEditingController experienceController;
  late TextEditingController skillsController;
  late TextEditingController profilePictureController;
  bool isEditing = false;
  bool isLoading = false;
  bool isUploading = false;
  bool isDeleting = false;
  final ImagePicker imagePicker = ImagePicker();
  String? currentProfilePictureUrl;

  @override
  void initState() {
    super.initState();
    initializeControllers();
    currentProfilePictureUrl = widget.getMyProfilePicture;
  }

  void initializeControllers() {
    nameController = TextEditingController(
      text: widget.userProfile?.fullName ?? '',
    );
    emailController = TextEditingController(
      text: widget.userProfile?.email ?? '',
    );
    bioController = TextEditingController(text: widget.userProfile?.bio ?? '');
    locationController = TextEditingController(
      text: widget.userProfile?.location ?? '',
    );
    phoneController = TextEditingController(
      text: widget.userProfile?.phoneNumber ?? '',
    );
    experienceController = TextEditingController(
      text: widget.userProfile?.experienceYears?.toString() ?? '0',
    );
    skillsController = TextEditingController(
      text: (widget.userProfile?.skills ?? []).join(', '),
    );
    profilePictureController = TextEditingController(
      text: widget.userProfile?.profilePicture ?? '',
    );
  }

  @override
  void didUpdateWidget(covariant UserCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.userProfile != widget.userProfile)
      updateControllersFromProfile();
    if (oldWidget.getMyProfilePicture != widget.getMyProfilePicture) {
      setState(() {
        currentProfilePictureUrl = widget.getMyProfilePicture;
        profilePictureController.text = widget.getMyProfilePicture ?? '';
      });
    }
  }

  void updateControllersFromProfile() {
    nameController.text = widget.userProfile?.fullName ?? '';
    emailController.text = widget.userProfile?.email ?? '';
    bioController.text = widget.userProfile?.bio ?? '';
    locationController.text = widget.userProfile?.location ?? '';
    phoneController.text = widget.userProfile?.phoneNumber ?? '';
    experienceController.text =
        widget.userProfile?.experienceYears?.toString() ?? '';
    skillsController.text = (widget.userProfile?.skills ?? []).join(', ');
    profilePictureController.text = widget.userProfile?.profilePicture ?? '';
    currentProfilePictureUrl = widget.userProfile?.profilePicture;
  }

  void updateProfilePicture(String newUrl) {
    setState(() {
      currentProfilePictureUrl = newUrl.isNotEmpty ? newUrl : null;
      profilePictureController.text = newUrl;
    });

    final updatedProfile = UserProfile(
      id: widget.userProfile?.id ?? '',
      username: widget.userProfile?.username ?? '',
      email: widget.userProfile?.email ?? '',
      fullName: widget.userProfile?.fullName ?? '',
      bio: widget.userProfile?.bio,
      skills: widget.userProfile?.skills ?? [],
      experienceYears: widget.userProfile?.experienceYears,
      location: widget.userProfile?.location,
      phoneNumber: widget.userProfile?.phoneNumber,
      profilePicture: newUrl,
      active: widget.userProfile?.active ?? true,
    );

    widget.onSave(updatedProfile);
  }

  Future<void> handleSave() async {
    if (nameController.text.isEmpty || emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Name and email are required')),
      );
      return;
    }

    setState(() => isLoading = true);
    try {
      final updatedProfile = createUpdatedProfileFromControllers(
        widget.userProfile,
        nameController,
        emailController,
        bioController,
        locationController,
        phoneController,
        experienceController,
        skillsController,
        profilePictureController,
      );

      await widget.onSave(updatedProfile);
      setState(() => isEditing = false);

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
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    bioController.dispose();
    locationController.dispose();
    phoneController.dispose();
    experienceController.dispose();
    skillsController.dispose();
    profilePictureController.dispose();
    super.dispose();
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
          _buildHeaderSection(),
          const SizedBox(height: 24),
          isEditing
              ? buildEditMode(this, context)
              : buildViewMode(widget.userProfile, context),
          // if (isEditing) buildSaveButton(),
          if (isEditing) ...[
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : handleSave,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.teal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: isLoading
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

  Widget _buildHeaderSection() {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        Column(
          children: [
            const SizedBox(height: 24),
            Stack(
              children: [
                buildProfileImage(),
                if (isEditing) buildImageActionButtons(),
              ],
            ),
            const SizedBox(height: 16),
            Center(child: buildTitle()),
            const SizedBox(height: 8),
            if (widget.userProfile?.bio?.isNotEmpty == true && !isEditing)
              buildBioText(),
          ],
        ),
        if (!isLoading) buildEditButton(),
      ],
    );
  }

  Widget buildProfileImage() {
    if (isUploading || isDeleting) {
      return Container(
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
      );
    }

    final imageUrl = currentProfilePictureUrl;

    if (imageUrl == null || imageUrl.isEmpty) {
      return CircleAvatar(
        radius: 50,
        backgroundColor: Colors.grey[200],
        child: const Icon(Icons.person, size: 50, color: Colors.grey),
      );
    }

    return ClipOval(
      child: Image.network(
        imageUrl,
        width: 100,
        height: 100,
        fit: BoxFit.cover,
        key: ValueKey(imageUrl), // Force rebuild when URL changes
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              shape: BoxShape.circle,
            ),
            child: Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                    : null,
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return CircleAvatar(
            radius: 50,
            backgroundColor: Colors.grey[200],
            child: const Icon(Icons.error, color: Colors.red),
          );
        },
      ),
    );
  }

  Widget buildImageActionButtons() {
    return Positioned(
      bottom: 0,
      right: 0,
      child: Row(
        children: [
          buildImageActionButton(
            Icons.add_a_photo,
            () => pickAndUploadImage(
              context: context,
              onError: (error) {
                /* handle error */
              },
              onSuccess: (url) {
                updateProfilePicture(url);
              },
              updateProfilePicture: widget.updateProfilePicture,
            ),
          ),
          if (currentProfilePictureUrl != null &&
              currentProfilePictureUrl!.isNotEmpty) ...[
            const SizedBox(width: 8),
            buildImageActionButton(
              Icons.delete,
              () => widget.deleteProfilePictureById(widget.userProfile!.id),
              isDelete: true,
            ),
          ],
        ],
      ),
    );
  }

  Widget buildImageActionButton(
    IconData icon,
    Function() onTap, {
    bool isDelete = false,
  }) {
    return InkWell(
      onTap: isUploading || isDeleting ? null : onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 4),
          ],
        ),
        child: Icon(
          icon,
          size: 20,
          color: isUploading || isDeleting
              ? Colors.grey
              : (isDelete ? Colors.red : Colors.black87),
        ),
      ),
    );
  }

  Widget buildTitle() {
    return Text(
      isEditing ? 'Edit Profile' : widget.userProfile?.fullName ?? 'No Name',
      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
        color: Colors.teal,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget buildBioText() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Text(
        widget.userProfile!.bio!,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 15),
      ),
    );
  }

  Widget buildEditButton() {
    return IconButton(
      icon: Icon(isEditing ? Icons.close : Icons.edit),
      onPressed: () {
        setState(() {
          isEditing = !isEditing;
          if (!isEditing) updateControllersFromProfile();
        });
      },
    );
  }

  Widget buildSaveButton() {
    return Column(
      children: [
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: isLoading ? null : handleSave,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: Colors.teal,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: isLoading
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
    );
  }
}
