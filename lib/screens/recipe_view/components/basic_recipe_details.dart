import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sheff_andrew/common/components/network_image_check.dart';
import 'package:sheff_andrew/common/utils/constants.dart';

class BasicRecipeDetails extends StatefulWidget {
  final String image;
  final String name;
  const BasicRecipeDetails(
      {super.key, required this.image, required this.name});

  @override
  _BasicRecipeDetailsState createState() => _BasicRecipeDetailsState();
}

class _BasicRecipeDetailsState extends State<BasicRecipeDetails> {
  String _imageLink = '';
  final NetworkImageCheck networkImageCheck = NetworkImageCheck();
  final Constants constants = Constants();

  @override
  void initState() {
    super.initState();
    _checkImageURL();
  }

  Future<void> _checkImageURL() async {
    String imageLink = await networkImageCheck.checkImageURL(
        widget.image, constants.defaultRecipeImageLink);
    setState(() {
      _imageLink = imageLink;
    });
  }

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
            image: DecorationImage(
                image: NetworkImage(_imageLink), fit: BoxFit.cover),
          ),
        ),
        const SizedBox(height: 15),
        Text(
          widget.name,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
      ],
    );
  }
}
