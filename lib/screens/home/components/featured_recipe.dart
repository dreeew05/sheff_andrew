/*
  Author: Glen Andrew C. Bulaong
  Purpose of this file: Custom Widget that displays a featured recipe
*/

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sheff_andrew/common/utils/app_painter.dart';
import 'package:sheff_andrew/screens/recipes/recipe_view_page.dart';

class FeaturedRecipe extends StatelessWidget {
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
  Widget build(BuildContext context) {
    AppPainter appPainter = AppPainter();
    return Container(
      height: 275,
      width: 175,
      margin: const EdgeInsets.only(left: 10, right: 10),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
                margin: const EdgeInsets.only(top: 50),
                decoration: BoxDecoration(
                    color: appPainter.getCardColor(),
                    borderRadius: const BorderRadius.all(Radius.circular(15))),
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
                                      RecipeViewPage(postKey: postKey)));
                        },
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            name,
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
                      Text('$timeToCook Mins',
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
                          image,
                        ) as ImageProvider<Object>?,
                      ),
                    )),
              )),
        ],
      ),
    );
  }
}
