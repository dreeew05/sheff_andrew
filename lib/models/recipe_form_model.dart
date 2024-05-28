/*
  Author: Glen Andrew C. Bulaong
  Purpose of this file: Recipe Form Model
*/

import 'package:sheff_andrew/models/ingredient.dart';
import 'package:sheff_andrew/models/nutrients.dart';

class RecipeFormModel {
  String recipeImageLink;
  String recipeName;
  String category;
  String mealType;
  double timeToCook;
  String calories;
  List<Ingredient> ingredients;
  List<String> steps;
  List<String>? dietLabels;
  List<String>? healthLabels;
  List<String>? tags;
  List<String>? cautions;
  List<Nutrients>? totalNutrients;

  RecipeFormModel(
      {required this.recipeImageLink,
      required this.recipeName,
      required this.category,
      required this.mealType,
      required this.timeToCook,
      required this.calories,
      required this.ingredients,
      required this.steps,
      required this.dietLabels,
      required this.healthLabels,
      required this.tags,
      required this.cautions,
      required this.totalNutrients});
}
