import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sheff_andrew/dialogs/image_picker_dialog.dart';
import 'package:sheff_andrew/providers/recipe_form_provider.dart';

class RecipeDetails extends StatefulWidget {
  const RecipeDetails({super.key});

  @override
  RecipeDetailsState createState() => RecipeDetailsState();
}

class RecipeDetailsState extends State<RecipeDetails> {
  @override
  Widget build(BuildContext context) {
    final providerWatcher = context.watch<RecipeFormProvider>();
    final providerReader = context.read<RecipeFormProvider>();
    final recipeImage = providerWatcher.selectedImage;
    String mealType = providerReader.mealType;
    return Container(
        margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
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
              Align(
                alignment: Alignment.center,
                child: GestureDetector(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return const ImagePickerDialog();
                          });
                    },
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: recipeImage != null
                          ? FileImage(recipeImage!)
                          : null, // No background if recipeImage is null
                      child: recipeImage == null
                          ? const Icon(Icons.add_photo_alternate_outlined)
                          : null, // Add the icon if no image is loaded
                    )),
              ),
              const SizedBox(height: 5),
              Align(
                alignment: Alignment.center,
                child: TextButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return const ImagePickerDialog();
                        });
                  },
                  child: Text(
                    'Add Image',
                    style: GoogleFonts.poppins(),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: providerReader.recipeNameController,
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
              ),
              const SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.only(left: 40),
                // Fucking Dropdown is bugged.
                // This is not our fault.
                // Shit moves the tabView when clicked
                child: DropdownMenu<String>(
                  textStyle: GoogleFonts.poppins(),
                  label: Text(
                    "Meal Type",
                    style: GoogleFonts.poppins(fontSize: 15),
                  ),
                  initialSelection: mealType,
                  onSelected: (String? value) {
                    setState(() {
                      mealType = value!;
                    });
                  },
                  dropdownMenuEntries: <String>[
                    'Breakfast',
                    'Lunch',
                    'Dinner',
                    'Snack',
                    'Breakfast/Lunch',
                    'Lunch/Dinner'
                  ].map<DropdownMenuEntry<String>>((String value) {
                    return DropdownMenuEntry(
                      value: value,
                      label: value,
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 15),
              TextFormField(
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
              ),
              const SizedBox(height: 15),
              TextFormField(
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
              ),
            ],
          ),
        ));
  }
}

class _mealType {}
