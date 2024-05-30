/*
  Author: Glen Andrew C. Bulaong
  Purpose of this file: Generates relevan recipes based on user input
*/

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sheff_andrew/backend/fetch_from_api.dart';
import 'package:sheff_andrew/models/ingredient.dart';
import 'package:sheff_andrew/models/nutrients.dart';
import 'package:sheff_andrew/models/recipe_form_model.dart';
import 'package:sheff_andrew/providers/generative_search_provider.dart';
import 'package:sheff_andrew/screens/add_recipe/components/relevant_recipe_card.dart';

class GenerativeSearch extends StatefulWidget {
  const GenerativeSearch({super.key});

  @override
  GenerativeSearchState createState() => GenerativeSearchState();
}

class GenerativeSearchState extends State<GenerativeSearch> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _searchController = TextEditingController();

  bool _showResultsFromApi = false;
  bool _showNoResultFound = false;
  // List<Map<String, dynamic>> _recipeList = [];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void fetchRelevantRecipes() async {
    final providerReader = context.read<GenerativeSearchProvider>();
    final apiClient = FetchFromApi();
    final response = await apiClient.fetchRecipes(_searchController.text);
    setState(() {
      switch (response["status"]) {
        case "success":
          _showResultsFromApi = true;
          _showNoResultFound = false;
          // _recipeList = response["recipeList"];
          providerReader.setRecipeList(response['recipeList']);
          break;
        case "no_results":
          _showNoResultFound = true;
          _showResultsFromApi = false;
          // _recipeList = [];
          providerReader.setRecipeList([]);
          break;
        case "error":
          _showResultsFromApi = false;
          // _recipeList = [];
          providerReader.setRecipeList([]);
          break;
        default:
          break;
      }
    });
  }

  RecipeFormModel transformToModel(Map<String, dynamic> recipe) {
    List<dynamic> ingredientRawFormat = recipe['ingredients'];
    Map<String, dynamic> nutrientsRawFormat = recipe['totalNutrients'];
    List<Ingredient> ingredients = [];
    List<Nutrients> nutrients = [];

    // Transform to Specific Models
    for (var ingredient in ingredientRawFormat) {
      ingredients.add(Ingredient(
          label: ingredient['food'] as String,
          quantity: ingredient['quantity'] as double,
          unit: ingredient['measure'] as String,
          image: ingredient['image'] as String));
    }

    nutrientsRawFormat.forEach((key, value) {
      nutrients.add(Nutrients(
          label: value['label'],
          quantity: value['quantity'],
          unit: value['unit']));
    });

    return RecipeFormModel(
        recipeImageLink: recipe['image'],
        recipeName: recipe['label'],
        category: recipe['cuisineType'],
        mealType: recipe['mealType'],
        timeToCook: recipe['totalTime'],
        calories: recipe['calories'],
        ingredients: ingredients,
        steps: [],
        dietLabels: recipe['dietLabels'] ?? [],
        healthLabels: recipe['healthLabels'] ?? [],
        tags: recipe['tags'] ?? [],
        cautions: recipe['cautions'] ?? [],
        totalNutrients: nutrients);
  }

  @override
  Widget build(BuildContext context) {
    final providerWatcher = context.watch<GenerativeSearchProvider>();
    return Form(
        key: _formKey,
        child: Container(
            margin: const EdgeInsets.only(
              top: 20,
              bottom: 30,
              left: 20,
              right: 20,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          style: GoogleFonts.poppins(),
                          controller: _searchController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a recipe name';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              errorBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                width: 1.0,
                              )),
                              labelStyle: GoogleFonts.poppins(),
                              labelText: "Enter Recipe Name"),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.search,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              fetchRelevantRecipes();
                            }
                          },
                        ),
                      )
                    ],
                  ),
                  const Padding(padding: EdgeInsets.only(top: 20)),
                  Visibility(
                    visible: _showResultsFromApi,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Relevant Recipes',
                            style: GoogleFonts.poppins(
                                fontSize: 24, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 20),
                        CarouselSlider(
                          options: CarouselOptions(
                            height: 200,
                            aspectRatio: 16 / 9,
                            viewportFraction: 1,
                            initialPage: 0,
                            enableInfiniteScroll: false,
                            scrollDirection: Axis.horizontal,
                          ),
                          items: providerWatcher.recipeList
                              .asMap()
                              .entries
                              .map((entry) {
                            int index = entry.key;
                            var recipe = entry.value;
                            return RelevantRecipeCard(
                              index: index,
                              label: recipe['label'] as String,
                              image: recipe['image'] as String,
                              totalTime: recipe['totalTime'] as double,
                            );
                          }).toList(),
                        )
                      ],
                    ),
                  ),
                  Visibility(
                    visible: _showNoResultFound,
                    child: const Text('No results found'),
                  ),
                ],
              ),
            )));
  }
}
