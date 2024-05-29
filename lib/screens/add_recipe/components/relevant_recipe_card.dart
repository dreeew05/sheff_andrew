/*
  Author: Glen Andrew C. Bulaong
  Purpose of this file: Card for relevant recipes
*/

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sheff_andrew/common/utils/capitalize_string.dart';
import 'package:sheff_andrew/models/ingredient.dart';
import 'package:sheff_andrew/models/nutrients.dart';
import 'package:sheff_andrew/providers/generative_search_provider.dart';
import 'package:sheff_andrew/providers/recipe_form_provider.dart';

class RelevantRecipeCard extends StatelessWidget {
  final int index;
  final String label;
  final String image;
  final double totalTime;
  const RelevantRecipeCard({
    super.key,
    required this.index,
    required this.label,
    required this.image,
    required this.totalTime,
  });

  @override
  Widget build(BuildContext context) {
    final providerWatcherGS = context.watch<GenerativeSearchProvider>();
    final providerReaderRF = context.read<RecipeFormProvider>();
    final cap = CapitalizeString();
    return Card(
      child: Container(
        height: 200,
        width: MediaQuery.of(context).size.width * 1,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(image: NetworkImage(image), fit: BoxFit.cover),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Stack(
            children: [
              // Gradient overlay
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: <Color>[
                        Colors.transparent,
                        Colors.black.withOpacity(0.8),
                      ],
                    ),
                  ),
                ),
              ),
              // Text
              Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  padding:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        label,
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "Time to cook: ${totalTime.toInt().toString()} minutes",
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Button
              Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    margin: const EdgeInsets.only(top: 5, right: 10),
                    child: ElevatedButton(
                        onPressed: () {
                          // Clear Form First
                          providerReaderRF.clearWholeForm();

                          List<dynamic> ingredientRawFormat = providerWatcherGS
                              .recipeList[index]['ingredients'];
                          Map<String, dynamic> nutrientsRawFormat =
                              providerWatcherGS.recipeList[index]
                                  ['totalNutrients'];
                          List<dynamic> dietLabelsRawFormat =
                              providerWatcherGS.recipeList[index]['dietLabels'];
                          List<dynamic> healthLabelsRawFormat =
                              providerWatcherGS.recipeList[index]
                                  ['healthLabels'];
                          List<dynamic>? tagsRawFormat =
                              providerWatcherGS.recipeList[index]['tags'];
                          List<dynamic> cautionsRawFormat =
                              providerWatcherGS.recipeList[index]['cautions'];
                          List<Ingredient> ingredients = [];
                          List<Nutrients> nutrients = [];
                          List<String> dietLabels = [];
                          List<String> healthLabels = [];
                          List<String> tags = [];
                          List<String> cautions = [];

                          // Put the contents of the selected recipe to form
                          // Recipe Details
                          providerReaderRF.recipeNameController.text =
                              cap.capitalize(
                            providerWatcherGS.recipeList[index]['label'],
                          );
                          providerReaderRF.setRecipeImageFromSearch(
                              providerWatcherGS.recipeList[index]['image']);
                          providerReaderRF.categoryController.text =
                              cap.capitalize(providerWatcherGS.recipeList[index]
                                  ['cuisineType'][0]);
                          providerReaderRF.mealTypeController.text =
                              cap.capitalize(providerWatcherGS.recipeList[index]
                                  ['mealType'][0]);
                          providerReaderRF.timeToCookController.text =
                              providerWatcherGS.recipeList[index]['totalTime']
                                  .toString();

                          // Recipe Ingredients
                          for (var ingredient in ingredientRawFormat) {
                            ingredients.add(Ingredient(
                              label: cap.capitalize(
                                ingredient['food'] as String,
                              ),
                              quantity: ingredient['quantity'] as double,
                              unit: cap.capitalize(
                                ingredient['measure'] as String,
                              ),
                              image:
                                  cap.capitalize(ingredient['image'] as String),
                            ));
                          }
                          providerReaderRF.setIngredients(ingredients);

                          // Additional Information
                          providerReaderRF.caloriesController.text =
                              providerWatcherGS.recipeList[index]['calories']
                                  .toString();
                          nutrientsRawFormat.forEach((key, value) {
                            nutrients.add(Nutrients(
                                label: value['label'],
                                quantity: value['quantity'],
                                unit: value['unit']));
                          });
                          providerReaderRF
                              .setTotalNutrientsFromSearch(nutrients);

                          for (String label in dietLabelsRawFormat) {
                            dietLabels.add(cap.capitalize(label.toString()));
                          }
                          providerReaderRF.setDietLabelsFromSearch(dietLabels);

                          for (String label in healthLabelsRawFormat) {
                            healthLabels.add(cap.capitalize(label.toString()));
                          }
                          providerReaderRF
                              .setHealthLabelsFromSearch(healthLabels);

                          if (tagsRawFormat != null) {
                            for (String label in tagsRawFormat) {
                              tags.add(cap.capitalize(label.toString()));
                            }
                          }
                          providerReaderRF.setTagsFromSearch(tags);

                          for (String label in cautionsRawFormat) {
                            cautions.add(cap.capitalize(label.toString()));
                          }
                          providerReaderRF.setCautionsFromSearch(cautions);
                        },
                        child: Text(
                          'Use this recipe',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.black,
                          ),
                        )),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
