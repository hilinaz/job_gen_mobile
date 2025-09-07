import 'package:flutter/material.dart';

Widget jobListingCard({
  required String title,
  required String company,
  required String description,
  VoidCallback? onTap,
}) {
  return Card(
    color: Colors.white, // distinct card color
    elevation: 6,
    margin: const EdgeInsets.symmetric(vertical: 8),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    shadowColor: Colors.black.withOpacity(0.15), // stronger shadow
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Job Title
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F4529),
              ),
            ),
            const SizedBox(height: 4),
            // Company Name
            Text(
              company,
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 8),
            // Description
            Text(
              description,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            // Optional: View Details
            Align(
              alignment: Alignment.bottomRight,
              child: TextButton(
                onPressed: onTap,
                child: const Text(
                  'View Details',
                  style: TextStyle(
                    color: Color(0xFF6BBAA5),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
