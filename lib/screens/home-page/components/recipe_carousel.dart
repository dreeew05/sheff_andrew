import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sheff_andrew/backend/firestore_service.dart';
import 'package:sheff_andrew/screens/home-page/components/featured_recipe.dart';

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
                  )));
        });
  }
}
