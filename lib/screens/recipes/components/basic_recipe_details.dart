import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BasicRecipeDetails extends StatelessWidget {
  final String image;
  final String name;
  const BasicRecipeDetails(
      {super.key, required this.image, required this.name});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 250,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image:
                DecorationImage(image: NetworkImage(image), fit: BoxFit.cover),
          ),
        ),
        const SizedBox(height: 15),
        Text(
          name,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
      ],
    );
  }
}
