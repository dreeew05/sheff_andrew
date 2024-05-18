import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RecipeFormPage extends StatefulWidget {
  RecipeFormPage({super.key});

  @override
  RecipeFormPageState createState() => RecipeFormPageState();
}

class RecipeFormPageState extends State<RecipeFormPage> {
  final TextEditingController recipeNameController = TextEditingController();
  final TextEditingController recipeProcedureController =
      TextEditingController();
  final List<TextEditingController> ingredientControllers = [];

  @override
  void dispose() {
    recipeNameController.dispose();
    recipeProcedureController.dispose();
    for (var controller in ingredientControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void addIngredientField() {
    setState(() {
      ingredientControllers.add(TextEditingController());
    });
  }

  void removeIngredientField(int index) {
    setState(() {
      ingredientControllers[index].dispose();
      ingredientControllers.removeAt(index);
    });
  }

  Future<void> submitRecipe() async {
    final recipeName = recipeNameController.text;
    final recipeProcedure = recipeProcedureController.text;
    final ingredients =
        ingredientControllers.map((controller) => controller.text).toList();

    if (recipeName.isEmpty ||
        recipeProcedure.isEmpty ||
        ingredients.any((ingredient) => ingredient.isEmpty)) {
      // Show an error message if any field is empty
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('All fields must be filled out'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    // Generate a unique ID for the new document
    final docId = FirebaseFirestore.instance.collection('community').doc().id;

    CollectionReference community =
        FirebaseFirestore.instance.collection('community');
    await community.doc(docId).set({
      'Primary Key:': docId,
      'recipeName': recipeName,
      'procedure': recipeProcedure,
      'ingredients': ingredients,
    });

    // Navigate to Community Page
    // Navigator.pushNamed(context, '/recipeform');
  }

  void clearFields() {
    setState(() {
      recipeNameController.clear();
      recipeProcedureController.clear();
      for (var controller in ingredientControllers) {
        controller.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a New Recipe'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: recipeNameController,
                decoration: const InputDecoration(
                  labelText: 'Recipe Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: recipeProcedureController,
                decoration: const InputDecoration(
                  labelText: 'Recipe Procedure',
                  border: OutlineInputBorder(),
                ),
                maxLines: 10,
              ),
              const SizedBox(height: 16),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: ingredientControllers.length + 1,
                itemBuilder: (context, index) {
                  if (index == ingredientControllers.length) {
                    return ElevatedButton(
                      onPressed: addIngredientField,
                      child: const Text('Add Ingredient'),
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: ingredientControllers[index],
                              decoration: InputDecoration(
                                labelText: 'Ingredient ${index + 1}',
                                border: const OutlineInputBorder(),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.remove_circle),
                            onPressed: () => removeIngredientField(index),
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: submitRecipe,
                child: const Text('Submit'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: clearFields,
                child: const Text('Clear'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
