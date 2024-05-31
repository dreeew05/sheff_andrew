import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HelloProfile extends StatelessWidget {
  final String name;
  // final String image;

  const HelloProfile({
    super.key,
    required this.name,
    // required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello $name',
              maxLines: 1,
              overflow: TextOverflow.fade,
              style: GoogleFonts.poppins(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'What are you cooking today?',
              style: GoogleFonts.poppins(fontSize: 16),
            )
          ],
        ),
        const Spacer(),
        CircleAvatar(
          radius: 35,
          backgroundColor: Colors.blue[200],
        ),
      ],
    );
  }
}
