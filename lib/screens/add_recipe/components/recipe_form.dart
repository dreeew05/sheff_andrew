/*
  Author: Glen Andrew C. Bulaong
  Purpose of this file: Instantiatable class that creates a form for adding/modifying a recipe
*/

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sheff_andrew/dialogs/image_picker_dialog.dart';
import 'package:sheff_andrew/providers/image_picker_provider.dart';

class RecipeForm extends StatefulWidget {
  const RecipeForm({super.key});

  @override
  RecipeFormState createState() => RecipeFormState();
}

class RecipeFormState extends State<RecipeForm>
    with SingleTickerProviderStateMixin {
  // Form and Attributes
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _mealType = 'Breakfast'; // Dropdown default value

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    File? recipeImage = context.watch<ImagePickerProvider>().selectedImage;
    return Container(
        margin: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Form(
          key: _formKey,
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
                  children: [
                    // Recipe Details
                    Container(
                        margin:
                            const EdgeInsets.only(top: 20, left: 20, right: 20),
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
                                          ? FileImage(recipeImage)
                                          : const NetworkImage(
                                                  'https://media.cnn.com/api/v1/images/stellar/prod/140430115517-06-comfort-foods.jpg?q=w_1110,c_fill')
                                              as ImageProvider<Object>?,
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
                                  initialSelection: _mealType,
                                  onSelected: (String? value) {
                                    setState(() {
                                      _mealType = value!;
                                    });
                                  },
                                  dropdownMenuEntries: <String>[
                                    'Breakfast',
                                    'Lunch',
                                    'Dinner',
                                    'Snack',
                                    'Breakfast/Lunch',
                                    'Lunch/Dinner'
                                  ].map<DropdownMenuEntry<String>>(
                                      (String value) {
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
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
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
                        )),
                    // Center(child: Text('Recipe Details')),
                    const Center(child: Text('Ingredients')),
                    const Center(child: Text('Procedure')),
                    const Center(child: Text('Additional Facts')),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (_currentIndex == _tabController.length - 1) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Processing Data')));
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
        ));
  }
}
