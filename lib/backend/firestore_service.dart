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
  if (text.isEmpty) return text;
  return text[0].toUpperCase() + text.substring(1);
}

class FirestoreService {
  // Collections
  final CollectionReference _post =
      FirebaseFirestore.instance.collection('posts');
  final CollectionReference _users =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference _recipes =
      FirebaseFirestore.instance.collection('recipes');
  final CollectionReference _recipeInfo =
      FirebaseFirestore.instance.collection('recipe_info');
  final CollectionReference _ingredientsInfo =
      FirebaseFirestore.instance.collection('ingredients');
  final CollectionReference _nutrientsInfo =
      FirebaseFirestore.instance.collection('nutrients');

  // Getters
  CollectionReference get users => _users;
  CollectionReference get recipes => _recipes;

  // Get user
  Future<String?> getCurrentUserID() async {
    final user = FirebaseAuth.instance.currentUser;
    return user?.uid;
  }

  Future<String?> getRecipeUserName(String? userKey) async {
    try {
      // Create a query to find the document with the specified userKey
      QuerySnapshot querySnapshot =
          await _users.where('userKey', isEqualTo: userKey).get();
      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot userDoc = querySnapshot.docs.first;
        return userDoc['name'] as String?;
      } else {
        return 'Null';
      }
    } catch (e) {
      return 'Null';
    }
  }

  // Fetch user details
  Future<DocumentSnapshot> fetchUserDetails() async {
    DocumentSnapshot documentSnapshot =
        await _users.doc(await getCurrentUserID()).get();
    return documentSnapshot;
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

  // Delete Recipe
  Future<void> deleteRecipe(String postKey) async {
    QuerySnapshot recipeSnapshots =
        await _recipes.where('post_key', isEqualTo: postKey).get();
    QuerySnapshot recipeInfoSnapshots =
        await _recipeInfo.where('post_key', isEqualTo: postKey).get();
    QuerySnapshot nutrientsSnapshots =
        await _nutrientsInfo.where('post_key', isEqualTo: postKey).get();
    QuerySnapshot ingredientsSnapshots =
        await _ingredientsInfo.where('post_key', isEqualTo: postKey).get();

    // Delete the posts from Recipes Collection
    for (QueryDocumentSnapshot doc in recipeSnapshots.docs) {
      await doc.reference.delete();
    }

    // Delete the posts from RecipeInfo Collection
    for (QueryDocumentSnapshot doc in recipeInfoSnapshots.docs) {
      await doc.reference.delete();
    }

    // Delete the posts Nutrients Collection
    for (QueryDocumentSnapshot doc in nutrientsSnapshots.docs) {
      await doc.reference.delete();
    }

    // Delete the posts Ingredients Collection
    for (QueryDocumentSnapshot doc in ingredientsSnapshots.docs) {
      await doc.reference.delete();
    }

    // Delete the post from Posts Collection
    await _post.doc(postKey).delete();
  }

  // Fetch bookmarked recipes by current user
  // Future<List<String>> fetchBookmarkedRecipes(String userKey) async {
  //   DocumentSnapshot doc = await _users.doc(userKey).get();
  //   List<String> bookmarks = doc.get('bookmarks');
  //   return bookmarks;
  // }

  // Fetch all recipes from the user
  Stream<QuerySnapshot> fetchRecipesByCurrentUser(String userKey) {
    final allRecipesByUserStream =
        _recipes.where('user', isEqualTo: userKey).snapshots();
    return allRecipesByUserStream;
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
        .startAt([capitalizeFirstLetter(query)]).endAt(
            ['${capitalizeFirstLetter(query)}\uf8ff']);
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
