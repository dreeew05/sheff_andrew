/*
  Author: Glen Andrew C. Bulaong
  Purpose of this file: All in One File for Firestore Service
*/
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sheff_andrew/models/ingredient.dart';
import 'package:sheff_andrew/models/nutrients.dart';
import 'package:sheff_andrew/models/recipe_form_model.dart';

String capitalizeFirstLetter(String text) {
  if (text == null || text.isEmpty) return text;
  return text[0].toUpperCase() + text.substring(1);
}

class FirestoreService {
  // Collections
  final CollectionReference _post =
      FirebaseFirestore.instance.collection('posts');
  final CollectionReference _recipes =
      FirebaseFirestore.instance.collection('recipes');
  final CollectionReference _recipeInfo =
      FirebaseFirestore.instance.collection('recipe_info');
  final CollectionReference _ingredientsInfo =
      FirebaseFirestore.instance.collection('ingredients');
  final CollectionReference _nutrientsInfo =
      FirebaseFirestore.instance.collection('nutrients');

  // Get user
  Future<String?> getCurrentUserID() async {
    final user = FirebaseAuth.instance.currentUser;
    return user?.uid;
  }

  // Fetch specific document given the post_key
  Future<DocumentSnapshot<Map<String, dynamic>>> fetchDocument(
      String collection, String postKey) async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection(collection)
        .where('post_key', isEqualTo: postKey)
        .get();
    return querySnapshot.docs.first;
  }

  // Fetch all recipes
  Stream<QuerySnapshot> getRecipeStream() {
    final recipeStream = _recipes.snapshots();
    return recipeStream;
  }

  // Fetch relevant recipe
  Stream<QuerySnapshot> getSearchedRecipeStream(String query) {
    final relevantRecipeStream = _recipes
        .orderBy('name')
        .startAt([capitalizeFirstLetter(query)])
        .endAt(['${capitalizeFirstLetter(query)}\uf8ff']); 
    return relevantRecipeStream.snapshots();
  }

  // Insert Data
  Future<void> insertData(RecipeFormModel recipeForm) async {
    try {
      // Create post first, to generate the post key
      DocumentReference docRef = await _post.add({
        'user': await getCurrentUserID(),
        'date_posted': Timestamp.now(),
      });

      String documentID = docRef.id;

      await _recipes.add({
        'category': recipeForm.category,
        'image': recipeForm.recipeImageLink,
        'name': recipeForm.recipeName,
        'time_to_cook': recipeForm.timeToCook,
        'meal_type': recipeForm.mealType,
        'post_key': documentID,
        'user': await getCurrentUserID(),
      });

      await _recipeInfo.add({
        'steps': recipeForm.steps,
        'diet_labels': recipeForm.dietLabels, // Optional
        'health_labels': recipeForm.healthLabels, // Optional
        'tags': recipeForm.tags, // Optional
        'cautions': recipeForm.cautions, // Optional
        'calories': recipeForm.calories, // Optional
        'post_key': documentID,
        'user': await getCurrentUserID(),
      });

      // Each Ingredient has its own attributes
      for (Ingredient ingredient in recipeForm.ingredients) {
        await _ingredientsInfo.add({
          'label': ingredient.label,
          'quantity': ingredient.quantity,
          'unit': ingredient.unit,
          'image': ingredient.image,
          'post_key': documentID,
          'user': await getCurrentUserID(),
        });
      }

      // Each Nutrient has its own attributes
      // Total Nutrients is optional in the form
      if (recipeForm.totalNutrients != null) {
        for (Nutrients nutrient in recipeForm.totalNutrients!) {
          await _nutrientsInfo.add({
            'label': nutrient.label,
            'quantity': nutrient.quantity,
            'unit': nutrient.unit,
            'post_key': documentID,
            'user': await getCurrentUserID(),
          });
        }
      }
    } catch (e) {
      // Todo: Implement this
      print('Error Adding');
    }
  }
}
