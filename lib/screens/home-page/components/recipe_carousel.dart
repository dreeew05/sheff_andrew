import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sheff_andrew/backend/firestore_service.dart';
import 'package:sheff_andrew/screens/home-page/components/featured_recipe.dart';
import 'package:carousel_slider/carousel_slider.dart';

class RecipeCarousel extends StatelessWidget {
  final FirestoreService firestoreService = FirestoreService();

  RecipeCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: firestoreService.getRecipeStream(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          // Guard Clauses to Prevent Mishandle of Null Data

          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final List recipeList = snapshot.data!.docs;

          return CarouselSlider(
            items: [
              for (var i = 0; i < recipeList.length; i += 2)
                _RecipePair(
                  recipe1: recipeList[i].data() as Map<String, dynamic>,
                  recipe2: i + 1 < recipeList.length
                      ? recipeList[i + 1].data() as Map<String, dynamic>
                      : null,
                ),
            ],
            options: CarouselOptions(
                height: 255,
                viewportFraction: 0.9,
                enableInfiniteScroll: false),
          );
        });
  }
}

class _RecipePair extends StatelessWidget {
  final Map<String, dynamic> recipe1;
  final Map<String, dynamic>? recipe2;

  const _RecipePair({required this.recipe1, this.recipe2});

  void printRecipeValues(Map<String, dynamic> recipe) {
    recipe.forEach((key, value) {
      print('$key: $value');
    });
  }

  @override
  Widget build(BuildContext context) {
    printRecipeValues(recipe1);
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      child: Row(
        children: [
          if (recipe2 == null) ...[
            FeaturedRecipe(recipe: recipe1)
          ] else ...[
            Expanded(child: FeaturedRecipe(recipe: recipe1)),
            const Padding(padding: EdgeInsets.only(left: 10, right: 10)),
            Expanded(child: FeaturedRecipe(recipe: recipe2!))
          ]
        ],
      ),
    );
  }
}
