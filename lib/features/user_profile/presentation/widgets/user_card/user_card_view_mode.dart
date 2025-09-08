import 'package:flutter/material.dart';
import 'package:job_gen_mobile/features/user_profile/domain/entity/user_profile.dart';
import 'user_card_info_row.dart';

Widget buildViewMode(UserProfile? userProfile, BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      const Padding(
        padding: EdgeInsets.only(bottom: 8),
        child: Text(
          'Personal Information',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      if (userProfile != null) ...[
        buildInfoRow(Icons.email, userProfile.email, 'Email Address'),
        if (userProfile.fullName.isNotEmpty)
          buildInfoRow(Icons.person, userProfile.fullName, 'Full Name'),
        if (userProfile.location?.isNotEmpty == true)
          buildInfoRow(Icons.location_on, userProfile.location!, 'Location'),
        if (userProfile.phoneNumber?.isNotEmpty == true)
          buildInfoRow(Icons.phone, userProfile.phoneNumber!, 'Phone Number'),
        if (userProfile.experienceYears != null)
          buildInfoRow(
            Icons.work,
            '${userProfile.experienceYears} years of experience',
            'Experience',
          ),
        if (userProfile.skills.isNotEmpty)
          buildInfoRow(Icons.code, userProfile.skills.join(', '), 'Skills'),
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
