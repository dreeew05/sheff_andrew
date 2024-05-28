import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sheff_andrew/common/components/image_pick.dart';
import 'package:sheff_andrew/providers/recipe_form_provider.dart';

final _mealTypeEntries = <String>[
  'Breakfast',
  'Lunch',
  'Dinner',
  'Snack',
  'Breakfast/Lunch',
  'Lunch/Dinner'
];

class RecipeDetails extends StatefulWidget {
  const RecipeDetails({super.key});

  @override
  _RecipeDetailsState createState() => _RecipeDetailsState();
}

class _RecipeDetailsState extends State<RecipeDetails> {
  @override
  void dispose() {
    super.dispose();
    context.read<RecipeFormProvider>().disposeRecipeDetailsControllers();
  }

  @override
  Widget build(BuildContext context) {
    final providerWatcher = context.watch<RecipeFormProvider>();
    final recipeImage = providerWatcher.recipeImage;
    return Container(
        margin: const EdgeInsets.only(left: 3, right: 3),
        child: Form(
          key: providerWatcher.formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Recipe Details",
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                ImagePick(image: recipeImage, imageType: 'recipe'),
                const SizedBox(height: 10),
                TextFormField(
                  controller: providerWatcher.recipeNameController,
                  style: GoogleFonts.poppins(),
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    errorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                      color: Color.fromARGB(255, 214, 44, 32),
                      width: 1.0,
                    )),
                    labelText: 'Recipe Name',
                    labelStyle: GoogleFonts.poppins(),
                    icon: const Icon(Icons.local_dining),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the recipe name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                Container(
                  margin: const EdgeInsets.only(left: 40),
                  // Fucking Dropdown is bugged.
                  // This is not our fault.
                  // Shit moves the tabView when clicked
                  child: DropdownMenu<String>(
                    controller: providerWatcher.mealTypeController,
                    textStyle: GoogleFonts.poppins(),
                    label: Text(
                      "Meal Type",
                      style: GoogleFonts.poppins(fontSize: 15),
                    ),
                    initialSelection: _mealTypeEntries[0],
                    dropdownMenuEntries: _mealTypeEntries
                        .map<DropdownMenuEntry<String>>((String value) {
                      return DropdownMenuEntry(
                        value: value,
                        label: value,
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: providerWatcher.categoryController,
                  style: GoogleFonts.poppins(),
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    errorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                      color: Color.fromARGB(255, 214, 44, 32),
                      width: 1.0,
                    )),
                    labelText: 'Category',
                    labelStyle: GoogleFonts.poppins(),
                    icon: const Icon(Icons.category),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the category';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: providerWatcher.timeToCookController,
                  style: GoogleFonts.poppins(),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    errorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                      color: Color.fromARGB(255, 214, 44, 32),
                      width: 1.0,
                    )),
                    labelText: 'Time to Cook (in minutes)',
                    labelStyle: GoogleFonts.poppins(),
                    icon: const Icon(Icons.alarm),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the time to cook the recipe';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ));
  }
}
