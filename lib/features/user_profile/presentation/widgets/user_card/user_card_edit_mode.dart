import 'package:flutter/material.dart';
import 'package:job_gen_mobile/features/user_profile/presentation/widgets/user_card/user_card.controllers.dart';
import 'package:job_gen_mobile/features/user_profile/presentation/widgets/user_card_input.dart';
import 'user_card_input.dart' hide UserCardInput;

Widget buildEditMode(UserCardController controller, BuildContext context) {
  return Column(
    children: [
      UserCardInput(
        title: 'Full Name',
        placeholder: 'Enter your full name',
        controller: controller.nameController,
        enabled: !controller.isLoading,
      ),
      const SizedBox(height: 16.0),
      UserCardInput(
        title: 'Bio',
        placeholder: 'Tell us about yourself',
        controller: controller.bioController,
        maxLines: 3,
        enabled: !controller.isLoading,
      ),
      const SizedBox(height: 16.0),
      UserCardInput(
        title: 'Location',
        placeholder: 'Where are you based?',
        controller: controller.locationController,
        enabled: !controller.isLoading,
      ),
      const SizedBox(height: 16.0),
      UserCardInput(
        title: 'Phone Number',
        placeholder: 'Enter your phone number',
        controller: controller.phoneController,
        keyboardType: TextInputType.phone,
        enabled: !controller.isLoading,
      ),
      const SizedBox(height: 16.0),
      UserCardInput(
        title: 'Experience Years',
        placeholder: 'e.g., 3',
        controller: controller.experienceController,
        keyboardType: TextInputType.number,
        enabled: !controller.isLoading,
      ),
      const SizedBox(height: 16.0),
      UserCardInput(
        title: 'Skills',
        placeholder: 'Comma separated (e.g., Dart, Flutter, REST)',
        controller: controller.skillsController,
        enabled: !controller.isLoading,
      ),
    ],
  );
}
