import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sheff_andrew/providers/interfaces/image_picker_provider_interface.dart';

class RecipeFormProvider extends ChangeNotifier
    implements ImagePickerProviderInterface {
  File? _selectedImage;
  String _mealType = 'Breakfast';
  final TextEditingController _recipeNameController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _timeToCookController = TextEditingController();

  // Getters
  @override
  File? get selectedImage => _selectedImage;
  String get mealType => _mealType;
  TextEditingController get recipeNameController => _recipeNameController;
  TextEditingController get category => _categoryController;
  TextEditingController get timeToCook => _timeToCookController;

  void disposeControllers() {
    _recipeNameController.dispose();
    _categoryController.dispose();
    _timeToCookController.dispose();
  }

  void clearForm() {
    _selectedImage = null;
    _mealType = 'Breakfast';
    _recipeNameController.clear();
    _categoryController.clear();
    _timeToCookController.clear();
    notifyListeners();
  }

  @override
  Future setPickedImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      _selectedImage = File(pickedFile.path);
      notifyListeners();
    }
  }
}
