import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sheff_andrew/common/components/network_image_check.dart';
import 'package:sheff_andrew/common/utils/constants.dart';
import 'package:sheff_andrew/screens/recipe_view/recipe_view_page.dart';

class NewRecipeView extends StatefulWidget {
  final String postKey;
  final String name;
  final String image;

  const NewRecipeView({
    super.key,
    required this.postKey,
    required this.name,
    required this.image,
  });

  @override
  _NewRecipeViewState createState() => _NewRecipeViewState();
}

class _NewRecipeViewState extends State<NewRecipeView> {
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
    return Row(
      children: [
        GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RecipeViewPage(postKey: widget.postKey),
                ),
              );
            },
            child: SizedBox(
              height: 225,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        image: NetworkImage(_imageLink),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 7),
                  SizedBox(
                    width: 150,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5, right: 5),
                      child: Text(
                        widget.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )),
        const SizedBox(width: 20)
      ],
    );
  }
}
