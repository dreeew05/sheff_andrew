import 'package:flutter/material.dart';
import 'package:sheff_andrew/models/recipe_form_model.dart';

class GenerativeSearchProvider extends ChangeNotifier {
  late int _selectedIndex;
  List<Map<String, dynamic>> _recipeList = [];
  final RecipeFormModel? _resultFromSearch = null;

  // Getters
  int get selectedIndex => _selectedIndex;
  List<Map<String, dynamic>> get recipeList => _recipeList;
  RecipeFormModel? get resultFromSearch => _resultFromSearch;

  void setSelectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  void setRecipeList(List<Map<String, dynamic>> recipeList) {
    _recipeList = recipeList;
    notifyListeners();
  }
}
