import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileDetails extends StatelessWidget {
  final String name;
  final String profileImage;
  // final String image;
  // Todo: Add image
  const ProfileDetails({
    super.key,
    required this.name,
    required this.profileImage,
    // required this.image
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Supposed to be picture
        CircleAvatar(
          radius: 60,
          backgroundImage:
              profileImage.isNotEmpty ? NetworkImage(profileImage) : null,
          child: profileImage.isEmpty ? Icon(Icons.person, size: 50) : null,
        ),
        const SizedBox(height: 10),
        Text(
          name,
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        const Divider(),
      ],
    );
  }
}
