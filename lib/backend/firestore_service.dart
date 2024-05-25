/*
  Author: Glen Andrew C. Bulaong
  Purpose of this file: All in One File for Firestore Service
*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sheff_andrew/models/recipe_form_model.dart';

class FirestoreService {
  // Get Recipe Collection
  final CollectionReference _recipes =
      FirebaseFirestore.instance.collection('recipes');

  // Read Data
  Stream<QuerySnapshot> getRecipeStream() {
    final recipeStream = _recipes.snapshots();
    return recipeStream;
  }

  // Todo: Implement this
  // Insert Data
  Future<void> insertData(RecipeFormModel recipeForm) async {}
}
