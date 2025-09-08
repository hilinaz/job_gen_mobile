import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:job_gen_mobile/features/files/domain/repositories/file_repository.dart';
import 'package:job_gen_mobile/features/files/domain/usecases/delete_file.dart';
import 'package:job_gen_mobile/features/files/domain/usecases/download_file.dart';
import 'package:job_gen_mobile/features/files/domain/usecases/get_current_user_files.dart';
import 'package:job_gen_mobile/features/files/domain/usecases/get_my_profile_picture_url_usecase.dart';
import 'package:job_gen_mobile/features/files/domain/usecases/get_profile_picture.dart';
import 'package:job_gen_mobile/features/files/domain/usecases/get_user_files.dart';
import 'package:job_gen_mobile/features/files/domain/usecases/upload_document.dart';
import 'package:job_gen_mobile/features/files/domain/usecases/upload_profile_picture.dart';
import 'package:job_gen_mobile/features/files/presentation/bloc/files_bloc.dart';
import 'package:job_gen_mobile/features/user_profile/domain/usecases/user_profile/delete_account.dart';
import 'package:job_gen_mobile/features/user_profile/domain/usecases/user_profile/get_user_profile.dart';
import 'package:job_gen_mobile/features/user_profile/domain/usecases/user_profile/update_user_profile.dart';
import 'package:job_gen_mobile/features/user_profile/presentation/bloc/user_profile_bloc.dart';
import 'package:job_gen_mobile/features/user_profile/presentation/pages/user_profile_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    // Get dependencies from service locator
    final getUserProfile = GetIt.I<GetUserProfile>();
    final updateUserProfile = GetIt.I<UpdateUserProfile>();
    final deleteAccount = GetIt.I<DeleteAccount>();
    final getProfilePicture = GetIt.I<GetProfilePictureUrlByUserId>();
    final uploadProfilePicture = GetIt.I<UploadProfilePicture>();
    final uploadDocument = GetIt.I<UploadDocument>();
    final downloadFile = GetIt.I<GetDownloadUrl>();
    final deleteFile = GetIt.I<DeleteFileById>();
    final fileRepository = GetIt.I<FileRepository>();
    final getCurrentUserFiles = GetIt.I<GetCurrentUserFiles>();
    final getMyProfilePicture = GetIt.I<GetMyProfilePictureUrlUsecase>();

    return MultiBlocProvider(
      providers: [
        BlocProvider<UserProfileBloc>(
          create: (_) => UserProfileBloc(
            getUserProfile: getUserProfile,
            updateUserProfile: updateUserProfile,
            deleteAccount: deleteAccount,
            // getMyProfilePicture: getMyProfilePicture,
          ),
        ),
        BlocProvider<FilesBloc>(
          create: (_) => FilesBloc(
            uploadProfilePicture: uploadProfilePicture,
            uploadDocument: uploadDocument,
            downloadFile: downloadFile,
            deleteFile: deleteFile,
            getProfilePicture: getProfilePicture,
            fileRepository: fileRepository,
            getUserFiles: getCurrentUserFiles,
            getMyProfilePicture: getMyProfilePicture,
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Job Gen Mobile',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: UserProfilePage(
          getUserProfile: getUserProfile,
          updateUserProfile: updateUserProfile,
          deleteAccount: deleteAccount,
          getProfilePicture: getProfilePicture,
          updateProfilePicture: uploadProfilePicture,
          deleteProfilePicture: deleteFile,
          fileRepository: fileRepository,
          getUserFiles: GetUserFiles(fileRepository),
          getCurrentUserFiles: getCurrentUserFiles,
          getMyProfilePicture: getMyProfilePicture,
        ),
      ),
    );
  }
}
