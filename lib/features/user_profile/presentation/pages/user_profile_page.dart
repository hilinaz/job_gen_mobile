import 'package:flutter/material.dart';
import 'package:job_gen_mobile/core/error/failures.dart';
import 'package:job_gen_mobile/features/user_profile/domain/entity/user_profile.dart';
import 'package:job_gen_mobile/features/user_profile/domain/usecases/get_user_profile.dart';
import 'package:job_gen_mobile/features/user_profile/domain/usecases/update_user_profile.dart';
import 'package:job_gen_mobile/features/user_profile/presentation/widgets/cv_card.dart';
import 'package:job_gen_mobile/features/user_profile/presentation/widgets/prefered_location_card.dart';
import 'package:job_gen_mobile/features/user_profile/presentation/widgets/skilled_set.dart';
import 'package:job_gen_mobile/features/user_profile/presentation/widgets/user_card.dart';

class UserProfilePage extends StatefulWidget {
  final GetUserProfile getUserProfile;
  final UpdateUserProfile updateUserProfile;

  const UserProfilePage({
    super.key,
    required this.getUserProfile,
    required this.updateUserProfile,
  });

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  UserProfile? _userProfile;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    setState(() => _isLoading = true);
    final result = await widget.getUserProfile();
    result.fold(
      (failure) {
        setState(() {
          _errorMessage = _mapFailureToMessage(failure);
          _isLoading = false;
        });
      },
      (profile) {
        setState(() {
          _userProfile = profile;
          _isLoading = false;
        });
      },
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Server error: ${(failure as ServerFailure).message}';
      case NetworkFailure:
        return 'Network error: ${(failure as NetworkFailure).message}';
      default:
        return 'An unexpected error occurred';
    }
  }

  Future<void> _handleSave(UserProfile updatedProfile) async {
    setState(() => _isLoading = true);
    final result = await widget.updateUserProfile(
      fullName: updatedProfile.fullName,
      bio: updatedProfile.bio,
      location: updatedProfile.location,
      phoneNumber: updatedProfile.phoneNumber,
      profilePicture: updatedProfile.profilePicture,
      experienceYears: updatedProfile.experienceYears,
      skills: updatedProfile.skills,
    );

    result.fold(
      (failure) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(_mapFailureToMessage(failure))));
        setState(() => _isLoading = false);
      },
      (profile) {
        setState(() {
          _userProfile = profile;
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF7BBFB3),
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
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
                  margin: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF7BBFB3),
                  ),
                ),
              ),
              const SizedBox(width: 12),
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? Center(child: Text(_errorMessage!))
          : SingleChildScrollView(
              child: Column(
                children: [
                  // UserCard(
                  //   userProfile: _userProfile,
                  //   onSave: _handleSave,
                  // ),
                  CVCard(newUser: _userProfile == null),
                  const PreferedLocationCard(),
                  const SkilledSetCard(),
                ],
              ),
            ),
    );
  }
}
//   const SkillChips({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Wrap(
//       spacing: 8,
//       runSpacing: 8,
//       children: [
//         _buildSkillChip('UI/UX Design'),
//         _buildSkillChip('Wireframing'),
//         _buildSkillChip('Prototyping'),
//         _buildSkillChip('User Research'),
//         _buildSkillChip('Figma'),
//         _buildSkillChip('Adobe XD'),
//       ],
//     );
//   }
  

//   Widget _buildSkillChip(String skill) {
//     return Chip(
//       backgroundColor: const Color(0xFFE8F5F2),
//       label: Text(
//         skill,
//         style: const TextStyle(color: Color(0xFF7BBFB3)),
//       ),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(8),
//       ),
//     );
//   }
// }