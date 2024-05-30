import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sheff_andrew/common/components/network_image_check.dart';
import 'package:sheff_andrew/common/utils/constants.dart';
import 'package:sheff_andrew/screens/recipe_view/recipe_view_page.dart';

class ProfileRecipes extends StatefulWidget {
  final String postKey;
  final String name;
  final String image;
  final String timeToCook;
  final VoidCallback onDelete;

  const ProfileRecipes({
    super.key,
    required this.postKey,
    required this.name,
    required this.image,
    required this.timeToCook,
    required this.onDelete,
  });

  @override
  _ProfileRecipesState createState() => _ProfileRecipesState();
}

class _ProfileRecipesState extends State<ProfileRecipes> {
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
      children: [
        Card(
          child: Container(
            height: 200,
            width: MediaQuery.of(context).size.width * 1,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                  image: NetworkImage(_imageLink), fit: BoxFit.cover),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Stack(
                children: [
                  // Gradient overlay
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: <Color>[
                            Colors.transparent,
                            Colors.black.withOpacity(0.8),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Text
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, bottom: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      RecipeViewPage(postKey: widget.postKey),
                                ),
                              );
                            },
                            child: Text(
                              widget.name,
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "Time to cook: ${widget.timeToCook} minutes",
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: PopupMenuButton(
                          onSelected: (value) {
                            if (value == 'delete') {
                              widget.onDelete();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Recipe deleted successfully'),
                                ),
                              );
                            }
                          },
                          icon: const Icon(
                            Icons.more_vert,
                            color: Colors.white,
                          ),
                          color: Colors.white,
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              height: 30,
                              value: 'delete',
                              child: Text(
                                'Delete',
                                style: GoogleFonts.poppins(),
                              ),
                            )
                          ],
                        ),
                      ))
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
