import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:job_gen_mobile/core/error/failures.dart';
import 'package:job_gen_mobile/features/files/domain/usecases/delete_file.dart';
import 'package:job_gen_mobile/features/files/domain/usecases/upload_profile_picture.dart';
import 'user_card_helpers.dart';

Future<void> pickAndUploadImage({
  required BuildContext context,
  required UploadProfilePicture updateProfilePicture,
  required Function(String) onSuccess,
  required Function(Failure) onError,
}) async {
  final imagePicker = ImagePicker();

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
                final file = await imagePicker.pickImage(
                  source: ImageSource.gallery,
                  imageQuality: 85,
                  maxWidth: 800,
                );
                if (file != null) Navigator.of(context).pop(file);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Camera'),
              onTap: () async {
                final file = await imagePicker.pickImage(
                  source: ImageSource.camera,
                  imageQuality: 85,
                  maxWidth: 800,
                );
                if (file != null) Navigator.of(context).pop(file);
              },
            ),
          ],
        ),
      );
    },
  );

  if (pickedFile == null) return;

  try {
    final result = await updateProfilePicture(
      fileName: 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg',
      contentType: 'image/jpeg',
      bytes: await pickedFile.readAsBytes(),
    );

    await result.fold(
      (failure) => onError(failure),
      (imageUrl) => onSuccess(imageUrl.toString()),
    );
  } catch (e) {
    onError(ServerFailure('Error: ${e.toString()}'));
  }
}

Future<void> deleteProfilePicture({
  required BuildContext context,
  required DeleteFileById deleteProfilePictureById,
  required String fileId,
  required Function() onSuccess,
  required Function(Failure) onError,
}) async {
  final bool confirmDelete = await showDialog(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: const Text('Delete Profile Picture'),
      content: const Text(
        'Are you sure you want to delete your profile picture?',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Delete', style: TextStyle(color: Colors.red)),
        ),
      ],
    ),
  );

  if (!confirmDelete) return;

  try {
    final result = await deleteProfilePictureById(fileId);
    result.fold((failure) => onError(failure), (_) => onSuccess());
  } catch (e) {
    onError(ServerFailure('Error: ${e.toString()}'));
  }
}
