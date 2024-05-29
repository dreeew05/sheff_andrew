/*
  Author: Glen Andrew C. Bulaong
  Purpose of this file: Dialog for adding ingredients
*/

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sheff_andrew/common/components/image_pick.dart';
import 'package:sheff_andrew/models/ingredient.dart';
import 'package:sheff_andrew/providers/recipe_form_provider.dart';

final _quantityEntries = <String>[
  'Teaspoon',
  'Tablespoon',
  'Ounce',
  'Cup',
  'Pint',
  'Quart',
  'Gallon',
  'Milliliter',
  'Liter',
  'Pound',
  'Gram',
  'Kilogram',
  'Inch',
  'Centimeter',
  'Piece',
  'Slice',
  'Bottle',
  'Pack'
];

class AddIngredientDialog extends StatefulWidget {
  const AddIngredientDialog({super.key});

  @override
  _AddIngredientDialogState createState() => _AddIngredientDialogState();
}

class _AddIngredientDialogState extends State<AddIngredientDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _labelController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _unitController = TextEditingController();

  @override
  void dispose() {
    _labelController.dispose();
    _quantityController.dispose();
    _unitController.dispose();
    super.dispose();
  }

  void clearForm() {
    _labelController.clear();
    _quantityController.clear();
    _unitController.clear();
    context.read<RecipeFormProvider>().clearIngredientImage();
  }

  @override
  Widget build(BuildContext context) {
    final providerWatcher = context.watch<RecipeFormProvider>();
    final providerReader = context.read<RecipeFormProvider>();
    final ingredientImage = providerWatcher.ingredientImage;
    return Form(
        key: _formKey,
        child: AlertDialog(
          title: Text(
            'Add Ingredient',
            style: GoogleFonts.poppins(
              fontSize: 24,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ImagePick(
                  image: ingredientImage,
                  imageType: 'ingredient',
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _labelController,
                  style: GoogleFonts.poppins(),
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    errorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                      color: Color.fromARGB(255, 214, 44, 32),
                      width: 1.0,
                    )),
                    labelText: 'Label',
                    labelStyle: GoogleFonts.poppins(),
                    icon: const Icon(Icons.label),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter ingredient name';
                    }
                    return null;
                  },
                ),
                // Increase the width of the first SizedBox to increase
                // the width of the dialog
                SizedBox(
                  height: 15,
                  width: MediaQuery.of(context).size.width,
                ),
                TextFormField(
                  controller: _quantityController,
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
                    labelText: 'Quantity',
                    labelStyle: GoogleFonts.poppins(),
                    icon: const Icon(Icons.format_list_numbered),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter quantity';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    const Icon(Icons.straighten),
                    const SizedBox(width: 15),
                    DropdownMenu<String>(
                        controller: _unitController,
                        enableFilter: true,
                        menuHeight: MediaQuery.of(context).size.height * 0.4,
                        requestFocusOnTap: true,
                        textStyle: GoogleFonts.poppins(),
                        label: Text(
                          "Unit",
                          style: GoogleFonts.poppins(fontSize: 15),
                        ),
                        initialSelection: _quantityEntries[0],
                        dropdownMenuEntries: _quantityEntries
                            .map<DropdownMenuEntry<String>>((String value) {
                          return DropdownMenuEntry(value: value, label: value);
                        }).toList())
                  ],
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Cancel',
                style: GoogleFonts.poppins(),
              ),
            ),
            TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final Ingredient ingredient = Ingredient(
                      label: _labelController.text,
                      quantity: double.parse(_quantityController.text),
                      unit: _unitController.text,
                      image: providerWatcher.ingredientImage);
                  providerReader.addIngredient(ingredient);
                  clearForm();
                  Navigator.pop(context);
                }
              },
              child: Text(
                'Add',
                style: GoogleFonts.poppins(),
              ),
            ),
          ],
        ));
  }
}
