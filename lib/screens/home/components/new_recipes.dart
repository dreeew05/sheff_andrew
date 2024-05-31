import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sheff_andrew/backend/firestore_service.dart';
import 'package:sheff_andrew/screens/home/components/new_recipe_view.dart';

class NewRecipes extends StatelessWidget {
  final FirestoreService firestoreService = FirestoreService();

  NewRecipes({super.key});

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
              child: Row(
                children: recipeList.map((recipe) {
                  final postKey = recipe.data()['post_key'] as String;
                  final name = recipe.data()['name'] as String;
                  final image = recipe.data()['image'] as String;
                  return NewRecipeView(
                    postKey: postKey,
                    name: name,
                    image: image,
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
    );
  }
}
