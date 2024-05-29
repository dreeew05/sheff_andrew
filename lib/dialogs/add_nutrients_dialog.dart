/*
  Author: Glen Andrew C. Bulaong
  Purpose of this file: Dialog for adding nutrients
*/

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sheff_andrew/models/nutrients.dart';
import 'package:sheff_andrew/providers/recipe_form_provider.dart';

class AddNutrientsDialog extends StatefulWidget {
  const AddNutrientsDialog({super.key});

  @override
  _AddNutrientsDialogState createState() => _AddNutrientsDialogState();
}

class _AddNutrientsDialogState extends State<AddNutrientsDialog> {
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
  }

  @override
  Widget build(BuildContext context) {
    final providerReader = context.read<RecipeFormProvider>();
    return Form(
      key: _formKey,
      child: AlertDialog(
        title: Text(
          'Add Nutrient',
          style: GoogleFonts.poppins(
            fontSize: 24,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
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
                    return 'Please enter a label';
                  }
                  return null;
                },
              ),
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
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: _unitController,
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
                  icon: const Icon(Icons.straighten),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a label';
                  }
                  return null;
                },
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
                final Nutrients nutrients = Nutrients(
                    label: _labelController.text,
                    quantity: double.parse(_quantityController.text),
                    unit: _unitController.text);
                providerReader.addNutrients(nutrients);
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
      ),
    );
  }
}
