/*
  Author: Glen Andrew C. Bulaong
  Purpose of this file: Carousel Effect for Featured Recipes
*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sheff_andrew/backend/firestore_service.dart';
import 'package:sheff_andrew/screens/home/components/featured_recipe.dart';

class RecipeCarousel extends StatelessWidget {
  final FirestoreService firestoreService = FirestoreService();

  RecipeCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: firestoreService.getRecipeStream(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Something went wrong',
                style: GoogleFonts.poppins(),
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            final List recipeList = snapshot.data!.docs;

            return SafeArea(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  child: Row(
                    children: recipeList.map((recipe) {
                      return FeaturedRecipe(
                          recipe: recipe.data() as Map<String, dynamic>);
                    }).toList(),
                  ),
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
        });
  }
}
