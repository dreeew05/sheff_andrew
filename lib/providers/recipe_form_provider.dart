/*
  Author: Glen Andrew C. Bulaong
  Purpose of this file: Provider for Recipe Form
*/

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sheff_andrew/backend/firebase_storage_service.dart';
import 'package:sheff_andrew/backend/firestore_service.dart';
import 'package:sheff_andrew/models/ingredient.dart';
import 'package:sheff_andrew/models/nutrients.dart';
import 'package:sheff_andrew/models/recipe_form_model.dart';

const String recipeImagesFolder = 'recipes';
const String ingredientsImagesFolder = 'ingredients';
const String defaultRecipeImage =
    'https://firebasestorage.googleapis.com/v0/b/sheff-andrew-e1613.appspot.com/o/recipes%2Frecipe-default-image.png?alt=media&token=ac225653-981f-46f8-b028-12533e0e89bc';
const String defaultIngredientImage =
    'https://firebasestorage.googleapis.com/v0/b/sheff-andrew-e1613.appspot.com/o/ingredients%2Fdefault-ingredient-image.png?alt=media&token=520960ad-ee08-410e-b98a-3818f61122d9';

class RecipeFormProvider extends ChangeNotifier {
  dynamic _recipeImage;
  File? _ingredientImage;
  List<Ingredient> _ingredients = [];
  List<String> _steps = [];
  List<String> _dietLabels = [];
  List<String> _healthLabels = [];
  List<String> _tags = [];
  List<String> _cautions = [];
  List<Nutrients> _totalNutrients = [];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _recipeNameController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _timeToCookController = TextEditingController();
  final TextEditingController _mealTypeController = TextEditingController();
  final TextEditingController _caloriesController = TextEditingController();
  late String _recipeImageLink;

  // Getters
  dynamic get recipeImage => _recipeImage;
  File? get ingredientImage => _ingredientImage;
  List<Ingredient> get ingredients => _ingredients;
  List<String> get steps => _steps;
  List<String> get dietLabels => _dietLabels;
  List<String> get healthLabels => _healthLabels;
  List<String> get tags => _tags;
  List<String> get cautions => _cautions;
  List<Nutrients> get totalNutrients => _totalNutrients;
  GlobalKey<FormState> get formKey => _formKey;
  TextEditingController get recipeNameController => _recipeNameController;
  TextEditingController get categoryController => _categoryController;
  TextEditingController get timeToCookController => _timeToCookController;
  TextEditingController get mealTypeController => _mealTypeController;
  TextEditingController get caloriesController => _caloriesController;

  void disposeRecipeDetailsControllers() {
    _recipeNameController.dispose();
    _categoryController.dispose();
    _timeToCookController.dispose();
    _mealTypeController.dispose();
    notifyListeners();
  }

  void disposeAdditionalInfoController() {
    _caloriesController.dispose();
  }

  void clearWholeForm() {
    _recipeImage = null;
    _recipeNameController.clear();
    _categoryController.clear();
    _timeToCookController.clear();
    _mealTypeController.clear();
    _caloriesController.clear();
    _ingredients = [];
    _steps = [];
    _dietLabels = [];
    _healthLabels = [];
    _tags = [];
    _cautions = [];
    _totalNutrients = [];
    // notifyListeners();
  }

  Future<void> uploadImages() async {
    final fStorageService = FirebaseStorageService();

    // Upload Recipe Image
    if (_recipeImage is File) {
      _recipeImageLink = await fStorageService.uploadImageAngGetLink(
          _recipeImage, recipeImagesFolder);
    } else if (_recipeImage is String) {
      _recipeImageLink = _recipeImage;
    } else if (_recipeImage == null) {
      _recipeImageLink = defaultRecipeImage;
    }

    // Upload each Ingredient Image
    for (Ingredient ingredient in _ingredients) {
      if (ingredient is File) {
        String ingredientImageLink = await fStorageService
            .uploadImageAngGetLink(ingredient.image, ingredientsImagesFolder);
        ingredient.replaceToLink(ingredientImageLink);
      } else {
        ingredient.replaceToLink(defaultIngredientImage);
      }
    }
  }

  void submitForm(BuildContext context) {
    uploadImages().then((result) {
      RecipeFormModel rfm = RecipeFormModel(
          recipeImageLink: _recipeImageLink,
          recipeName: _recipeNameController.text,
          category: _categoryController.text,
          mealType: _mealTypeController.text,
          timeToCook: double.parse(_timeToCookController.text),
          calories: _caloriesController.text,
          ingredients: ingredients,
          steps: steps,
          dietLabels: dietLabels,
          healthLabels: healthLabels,
          tags: tags,
          cautions: cautions,
          totalNutrients: totalNutrients);

      // print(rfm.recipeImageLink);
      final FirestoreService firestoreService = FirestoreService();
      firestoreService.insertData(rfm);

      clearWholeForm();
      Navigator.pop(context);
      notifyListeners();
    });
  }

  Future setRecipePickedImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      _recipeImage = File(pickedFile.path);
      notifyListeners();
    }
  }

  void setRecipeImageFromSearch(String imageLink) {
    _recipeImage = imageLink;
    notifyListeners();
  }

  // Recipe Ingredients
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

  void setIngredients(List<Ingredient> searchedIngredients) {
    _ingredients = searchedIngredients;
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

  void setDietLabelsFromSearch(List<String> searchedDietLabels) {
    _dietLabels = searchedDietLabels;
    notifyListeners();
  }

  void setHealthLabelsFromSearch(List<String> searchedHealthLabels) {
    _healthLabels = searchedHealthLabels;
    notifyListeners();
  }

  void setTagsFromSearch(List<String> searchedTags) {
    _tags = searchedTags;
    notifyListeners();
  }

  void setCautionsFromSearch(List<String> searchedCautions) {
    _cautions = searchedCautions;
    notifyListeners();
  }

  void setTotalNutrientsFromSearch(List<Nutrients> searchedNutrients) {
    _totalNutrients = searchedNutrients;
    notifyListeners();
  }
}
