/*
  Author: Glen Andrew C. Bulaong
  Purpose of this file: Instantiatable class that creates a form for adding/modifying a recipe
*/

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sheff_andrew/dialogs/form_error_dialog.dart';
import 'package:sheff_andrew/providers/recipe_form_provider.dart';
import 'package:sheff_andrew/screens/add_recipe/components/recipe_additional_information.dart';
import 'package:sheff_andrew/screens/add_recipe/components/recipe_details.dart';
import 'package:sheff_andrew/screens/add_recipe/components/recipe_ingredients.dart';
import 'package:sheff_andrew/screens/add_recipe/components/recipe_procedure.dart';

class RecipeForm extends StatefulWidget {
  const RecipeForm({super.key});

  @override
  RecipeFormState createState() => RecipeFormState();
}

class RecipeFormState extends State<RecipeForm>
    with SingleTickerProviderStateMixin {
  // Form and Attributes
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late TabController _tabController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _currentIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    context.read<RecipeFormProvider>().disposeControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Provi
    final providerWatcher = context.watch<RecipeFormProvider>();
    final providerReader = context.read<RecipeFormProvider>();
    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          TabBar(controller: _tabController, tabs: const [
            Tab(
              icon: Icon(Icons.description),
            ),
            Tab(
              icon: Icon(Icons.local_offer),
            ),
            Tab(
              icon: Icon(Icons.format_list_numbered),
            ),
            Tab(
              icon: Icon(Icons.info),
            ),
          ]),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                RecipeDetails(),
                RecipeIngredients(),
                RecipeProcedure(),
                RecipeAdditionalInformation(),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                if (_currentIndex == _tabController.length - 1) {
                  // ScaffoldMessenger.of(context).showSnackBar(
                  //     const SnackBar(content: Text('Processing Data')));

                  bool isIngredientsAndStepFilled =
                      providerWatcher.ingredients.isNotEmpty &&
                          providerWatcher.steps.isNotEmpty;

                  // Guard clauses
                  if (providerWatcher.ingredients.isEmpty) {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return const FormErrorDialog(
                              labelType: 'Ingredients');
                        });
                  }
                  if (providerWatcher.steps.isEmpty) {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return const FormErrorDialog(labelType: 'Steps');
                        });
                  }

                  // Todo: Implement Validator Error Border[Bugged]
                  providerReader.submitForm(
                      context, isIngredientsAndStepFilled);
                } else {
                  if (_currentIndex < _tabController.length - 1) {
                    _tabController.animateTo(_currentIndex + 1);
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(5.0), // Small border radius
                ),
              ),
              child: _currentIndex == _tabController.length - 1
                  ? Text(
                      'Submit',
                      style: GoogleFonts.poppins(),
                    )
                  : Text(
                      'Next',
                      style: GoogleFonts.poppins(),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
