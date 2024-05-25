import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sheff_andrew/models/ingredient.dart';
import 'package:sheff_andrew/models/nutrients.dart';

class RecipeFormProvider extends ChangeNotifier {
  File? _recipeImage;
  File? _ingredientImage;
  List<Ingredient> _ingredients = [];
  List<String> _steps = [];
  List<String> _dietLabels = [];
  List<String> _healthLabels = [];
  List<String> _tags = [];
  List<String> _cautions = [];
  List<Nutrients> _totalNutrients = [];
  final TextEditingController _recipeNameController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _timeToCookController = TextEditingController();
  final TextEditingController _mealTypeController = TextEditingController();
  final TextEditingController _caloriesController = TextEditingController();

  // Getters
  File? get recipeImage => _recipeImage;
  File? get ingredientImage => _ingredientImage;
  List<Ingredient> get ingredients => _ingredients;
  List<String> get steps => _steps;
  List<String> get dietLabels => _dietLabels;
  List<String> get healthLabels => _healthLabels;
  List<String> get tags => _tags;
  List<String> get cautions => _cautions;
  List<Nutrients> get totalNutrients => _totalNutrients;
  TextEditingController get recipeNameController => _recipeNameController;
  TextEditingController get category => _categoryController;
  TextEditingController get timeToCook => _timeToCookController;
  TextEditingController get mealTypeController => _mealTypeController;
  TextEditingController get caloriesController => _caloriesController;

  void disposeControllers() {
    // Details
    _recipeNameController.dispose();
    _categoryController.dispose();
    _timeToCookController.dispose();
    _mealTypeController.dispose();
    // Additional Information
    _caloriesController.dispose();
  }

  void clearWholeForm() {
    _recipeImage = null;
    _recipeNameController.clear();
    _categoryController.clear();
    _timeToCookController.clear();
    notifyListeners();
  }

  Future setRecipePickedImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      _recipeImage = File(pickedFile.path);
      notifyListeners();
    }
  }

  // Ingredients Dialog
  void clearIngredientImage() {
    _ingredientImage = null;
    notifyListeners();
  }

  void addIngredient(Ingredient ingredient) {
    _ingredients.add(ingredient);
    notifyListeners();
  }

  void removeIngredient(int index) {
    _ingredients = List.from(_ingredients)..removeAt(index);
    notifyListeners();
  }

  Future setIngredientPickedImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      _ingredientImage = File(pickedFile.path);
      notifyListeners();
    }
  }

  // Recipe Procedure
  void addStep(String step) {
    _steps.add(step);
    notifyListeners();
  }

  void removeStep(int index) {
    _steps = List.from(_steps)..removeAt(index);
    notifyListeners();
  }

  // Recipe Additional Information
  void addDietLabel(String label) {
    _dietLabels.add(label);
    notifyListeners();
  }

  void removeDietLabel(int index) {
    _dietLabels = List.from(_dietLabels)..removeAt(index);
    notifyListeners();
  }

  void addHealthLabel(String label) {
    _healthLabels.add(label);
    notifyListeners();
  }

  void removeHealthLabel(int index) {
    _healthLabels = List.from(_healthLabels)..removeAt(index);
    notifyListeners();
  }

  void addNutrients(Nutrients nutrients) {
    _totalNutrients.add(nutrients);
    notifyListeners();
  }

  void removeNutrients(int index) {
    _totalNutrients = List.from(_totalNutrients)..removeAt(index);
    notifyListeners();
  }

  void addTag(String tag) {
    _tags.add(tag);
    notifyListeners();
  }

  void removeTag(int index) {
    _tags = List.from(_tags)..removeAt(index);
    notifyListeners();
  }

  void addCaution(String caution) {
    _cautions.add(caution);
    notifyListeners();
  }

  void removeCaution(int index) {
    _cautions = List.from(_cautions)..removeAt(index);
    notifyListeners();
  }
}
