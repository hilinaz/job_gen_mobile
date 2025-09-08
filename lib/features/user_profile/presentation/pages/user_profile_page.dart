import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:job_gen_mobile/core/usecases/usecases.dart';
import 'package:job_gen_mobile/features/files/domain/entities/jg_file.dart';
import 'package:job_gen_mobile/features/files/domain/repositories/file_repository.dart';
import 'package:job_gen_mobile/features/files/domain/usecases/get_current_user_files.dart';
import 'package:job_gen_mobile/features/files/domain/usecases/get_my_profile_picture_url_usecase.dart';
import 'package:job_gen_mobile/features/files/domain/usecases/get_user_files.dart';
import 'package:job_gen_mobile/features/files/presentation/bloc/files_bloc_state.dart';
import 'package:job_gen_mobile/features/files/domain/usecases/delete_file.dart';
import 'package:job_gen_mobile/features/files/domain/usecases/download_file.dart';
import 'package:job_gen_mobile/features/files/domain/usecases/get_profile_picture.dart';
import 'package:job_gen_mobile/features/files/domain/usecases/upload_document.dart';
import 'package:job_gen_mobile/features/files/domain/usecases/upload_profile_picture.dart';
import 'package:job_gen_mobile/features/files/presentation/bloc/files_bloc.dart'
    as files_bloc;
import 'package:job_gen_mobile/features/user_profile/domain/entity/user_profile.dart';
import 'package:job_gen_mobile/features/user_profile/domain/usecases/user_profile/delete_account.dart';
import 'package:job_gen_mobile/features/user_profile/domain/usecases/user_profile/get_user_profile.dart';
import 'package:job_gen_mobile/features/user_profile/domain/usecases/user_profile/update_user_profile.dart';
import 'package:job_gen_mobile/features/user_profile/presentation/bloc/user_profile_bloc.dart';
import 'package:job_gen_mobile/features/user_profile/presentation/bloc/user_profile_event.dart'
    as profile_events;
import 'package:job_gen_mobile/features/user_profile/presentation/widgets/cv_card.dart';
import 'package:job_gen_mobile/features/user_profile/presentation/widgets/prefered_location_card.dart';
import 'package:job_gen_mobile/features/user_profile/presentation/widgets/skilled_set.dart'
    as skilled_set;
import 'package:job_gen_mobile/features/user_profile/presentation/widgets/user_card/user_card.dart';

class UserProfilePage extends StatefulWidget {
  final GetUserProfile getUserProfile;
  final UpdateUserProfile updateUserProfile;
  final DeleteAccount deleteAccount;
  final GetProfilePictureUrlByUserId getProfilePicture;
  final GetMyProfilePictureUrlUsecase getMyProfilePicture;
  final UploadProfilePicture updateProfilePicture;
  final DeleteFileById deleteProfilePicture;
  final FileRepository fileRepository;
  final GetUserFiles getUserFiles;
  final GetCurrentUserFiles getCurrentUserFiles;

  const UserProfilePage({
    super.key,
    required this.getUserProfile,
    required this.updateUserProfile,
    required this.deleteAccount,
    required this.getProfilePicture,
    required this.getMyProfilePicture,
    required this.updateProfilePicture,
    required this.deleteProfilePicture,
    required this.fileRepository,
    required this.getUserFiles,
    required this.getCurrentUserFiles,
  });

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  UserProfile? _userProfile;
  JgFile? _cvFile;
  bool _isLoading = true;
  String? _errorMessage;
  String? _profilePictureUrl;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserProfileBloc>().add(profile_events.LoadUserProfile());
      context.read<files_bloc.FilesBloc>().add(
        files_bloc.GetProfilePictureEvent(userId: 'current-user'),
      );
    });

    widget.getMyProfilePicture.call(NoParams()).then((value) {
      value.fold(
        (failure) {
          print('Failed to get profile picture: $failure');
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Failed to load profile picture: ${failure.message}',
                ),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        (url) {
          if (mounted) {
            setState(() {
              _profilePictureUrl = url;
            });
          }
        },
      );
    });
  }

  void _loadCVFile(String userId) {
    context.read<files_bloc.FilesBloc>().add(
      files_bloc.GetUserCVEvent(userId: userId),
    );
  }

  final sl = GetIt.instance;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => UserProfileBloc(
            getUserProfile: widget.getUserProfile,
            updateUserProfile: widget.updateUserProfile,
            deleteAccount: widget.deleteAccount,
          )..add(profile_events.LoadUserProfile()),
        ),
        BlocProvider(
          create: (context) => files_bloc.FilesBloc(
            uploadProfilePicture: widget.updateProfilePicture,
            uploadDocument: sl<UploadDocument>(),
            downloadFile: sl<GetDownloadUrl>(),
            deleteFile: widget.deleteProfilePicture,
            getProfilePicture: widget.getProfilePicture,
            fileRepository: widget.fileRepository,
            getUserFiles: widget.getCurrentUserFiles,
            getMyProfilePicture: widget.getMyProfilePicture,
          ),
        ),
      ],
      child: BlocListener<files_bloc.FilesBloc, FilesState>(
        listener: (context, state) {
          if (state is FilesCvLoaded) {
            setState(() {
              _cvFile = state.cvFile;
            });
          } else if (state is FilesProfilePictureLoaded) {
            setState(() {
              _profilePictureUrl = state.profilePictureUrl;
            });
          }
        },
        child: BlocConsumer<UserProfileBloc, UserProfileState>(
          listener: (context, state) {
            if (state is UserProfileError) {
              setState(() {
                _errorMessage = state.message;
                _isLoading = false;
              });
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            } else if (state is UserProfileLoaded) {
              setState(() {
                _userProfile = state.userProfile;
                _isLoading = false;
              });
              _loadCVFile(state.userProfile.id);
            } else if (state is UserProfileLoading) {
              setState(() => _isLoading = true);
            }
          },
          builder: (context, state) {
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
                      icon: const Icon(
                        Icons.menu,
                        color: Colors.white,
                        size: 34,
                      ),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
              body: _buildBody(context),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(child: Text(_errorMessage!));
    }

    if (_userProfile == null) {
      return const Center(child: Text('Failed to load profile'));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          UserCard(
            userProfile: _userProfile!,
            getMyProfilePicture: _profilePictureUrl,
            onSave: (updatedProfile) async {
              context.read<UserProfileBloc>().add(
                profile_events.UpdateUserProfileEvent(updatedProfile),
              );
            },
            updateProfilePicture: widget.updateProfilePicture,
            deleteProfilePictureById: widget.deleteProfilePicture,
          ),
          CVCard(
            fileRepository: GetIt.I<FileRepository>(),
            cvFile: _cvFile,
            onCVUploaded: (file) {
              setState(() {
                _cvFile = file;
              });
            },
            onCVDeleted: () {
              setState(() {
                _cvFile = null;
              });
            },
            userId: _userProfile?.id,
          ),
          const SizedBox(height: 16),
          const PreferedLocationCard(),
          const SizedBox(height: 16),
          skilled_set.SkilledSetCard(
            skills: _userProfile?.skills ?? [],
            onSkillsChanged: _handleSkillsChanged,
          ),
        ],
      ),
    );
  }

  Future<void> _handleSkillsChanged(List<String> skills) async {
    if (_userProfile == null) return;

    final updatedProfile = UserProfile(
      id: _userProfile!.id,
      email: _userProfile!.email,
      fullName: _userProfile!.fullName,
      username: _userProfile!.username,
      active: _userProfile!.active,
      skills: skills,
      bio: _userProfile!.bio,
      location: _userProfile!.location,
      phoneNumber: _userProfile!.phoneNumber,
      experienceYears: _userProfile!.experienceYears,
      profilePicture: _userProfile!.profilePicture,
    );

    context.read<UserProfileBloc>().add(
      profile_events.UpdateUserProfileEvent(updatedProfile),
    );
  }
}
