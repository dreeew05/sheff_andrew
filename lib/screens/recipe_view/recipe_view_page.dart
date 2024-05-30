/*
  Author: Glen Andrew C. Bulaong
  Purpose of this file: Recipe Page View
*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sheff_andrew/backend/firestore_service.dart';
import 'package:sheff_andrew/screens/recipe_view/components/basic_recipe_details.dart';
import 'package:sheff_andrew/screens/recipe_view/components/recipe_tab_view.dart';

class RecipeViewPage extends StatelessWidget {
  final String postKey;
  const RecipeViewPage({super.key, required this.postKey});

  @override
  Widget build(BuildContext context) {
    final FirestoreService firestoreService = FirestoreService();
    return Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                future: firestoreService.fetchDocument('recipes', postKey),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData) {
                    return const Center(child: Text('No recipe found'));
                  } else {
                    final Map<String, dynamic> recipeData =
                        snapshot.data!.data()!;
                    final image = recipeData['image'];
                    final name = recipeData['name'];
                    return BasicRecipeDetails(image: image, name: name);
                  }
                },
              ),
              const SizedBox(
                height: 20,
              ),
              // RecipeTabView(postKey: postKey),
              Expanded(
                child: RecipeTabView(
                  postKey: postKey,
                ),
              )
            ],
          ),
        ));
  }
}
