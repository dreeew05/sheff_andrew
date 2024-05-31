/*
  Author: Glen Andrew C. Bulaong
  Purpose of this file: Custom Widget that displays a featured recipe
*/

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sheff_andrew/common/components/network_image_check.dart';
import 'package:sheff_andrew/common/utils/app_painter.dart';
import 'package:sheff_andrew/common/utils/constants.dart';
import 'package:sheff_andrew/screens/recipe_view/recipe_view_page.dart';

class FeaturedRecipe extends StatefulWidget {
  // final Map<String, dynamic> recipe;
  final String image;
  final String name;
  final String timeToCook;
  final String postKey;

  const FeaturedRecipe({
    super.key,
    required this.image,
    required this.name,
    required this.timeToCook,
    required this.postKey,
  });

  @override
  _FeaturedRecipeState createState() => _FeaturedRecipeState();
}

class _FeaturedRecipeState extends State<FeaturedRecipe> {
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
    final AppPainter appPainter = AppPainter();
    return Row(
      children: [
        SizedBox(
          height: 275,
          width: 175,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                    margin: const EdgeInsets.only(top: 50),
                    decoration: BoxDecoration(
                        color: appPainter.getCardColor(),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15))),
                    child: Container(
                      margin: const EdgeInsets.only(top: 50),
                      padding: const EdgeInsets.only(
                          left: 15, right: 15, top: 10, bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      RecipeViewPage(postKey: widget.postKey),
                                ),
                              );
                            },
                            child: SizedBox(
                              height: 50,
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  widget.name,
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: GoogleFonts.poppins(
                                    color: appPainter.getCardTextColor(),
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const Padding(padding: EdgeInsets.only(top: 25)),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text("Time",
                                style: GoogleFonts.poppins(
                                  color: appPainter.getCardTextColor(),
                                  fontSize: 14,
                                )),
                          ),
                          const Padding(padding: EdgeInsets.only(top: 5)),
                          Text('${widget.timeToCook} Mins',
                              style: GoogleFonts.poppins(
                                color: appPainter.getCardTextColor(),
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              )),
                        ],
                      ),
                    )),
              ),
              Align(
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                    height: 100,
                    width: 100,
                    child: CircleAvatar(
                        radius: 100,
                        backgroundColor: appPainter.getCardColor(),
                        child: SizedBox(
                          height: 90,
                          width: 90,
                          child: CircleAvatar(
                            radius: 100,
                            backgroundImage: NetworkImage(
                              _imageLink,
                            ) as ImageProvider<Object>?,
                          ),
                        )),
                  )),
            ],
          ),
        ),
        const SizedBox(width: 25)
      ],
    );
  }
}
