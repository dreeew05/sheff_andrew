/*
  Author: Glen Andrew C. Bulaong
  Purpose of this file: Carousel Effect for Featured Recipes
*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sheff_andrew/backend/firestore_service.dart';
import 'package:sheff_andrew/providers/user_provider.dart';
import 'package:sheff_andrew/screens/home/components/featured_recipe.dart';

class RecipeCarousel extends StatefulWidget {
  const RecipeCarousel({super.key});

  @override
  _RecipeCarouselState createState() => _RecipeCarouselState();
}

class _RecipeCarouselState extends State<RecipeCarousel> {
  List<String> _bookmarkedRecipes = [];

  @override
  void initState() {
    super.initState();
    _listenForUserDocument();
  }

  void _listenForUserDocument() {
    final userKey = context.read<UserProvider>().userKey;
    firestoreService.users.doc(userKey).snapshots().listen((snapshot) {
      if (snapshot.data() != null) {
        Map<String, dynamic> userData =
            snapshot.data()! as Map<String, dynamic>;
        List<dynamic> bookmarks = userData['bookmarks'];
        setState(() {
          _bookmarkedRecipes = bookmarks.cast<String>();
        });
      }
    });
  }

  final FirestoreService firestoreService = FirestoreService();
  @override
  Widget build(BuildContext context) {
    return _bookmarkedRecipes.isNotEmpty
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Bookmarked Recipes",
                textAlign: TextAlign.left,
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              StreamBuilder<QuerySnapshot>(
                stream: firestoreService.recipes
                    .where('post_key', whereIn: _bookmarkedRecipes)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Something went wrong',
                        style: GoogleFonts.poppins(),
                      ),
                    );
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasData) {
                    final List recipeList = snapshot.data!.docs;

                    return SafeArea(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: recipeList.map((recipe) {
                            final postKey = recipe.data()['post_key'] as String;
                            final name = recipe.data()['name'] as String;
                            final image = recipe.data()['image'] as String;
                            final timeToCook =
                                recipe.data()['time_to_cook'].toString();
                            return FeaturedRecipe(
                              image: image,
                              name: name,
                              timeToCook: timeToCook,
                              postKey: postKey,
                            );
                          }).toList(),
                        ),
                      ),
                    );
                  } else {
                    return Center(
                      child: Text(
                        'No data',
                        style: GoogleFonts.poppins(),
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 30)
            ],
          )
        : Container();
  }
}
