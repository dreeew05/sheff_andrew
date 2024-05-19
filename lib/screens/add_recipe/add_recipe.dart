import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sheff_andrew/screens/add_recipe/components/generative_search.dart';
import 'package:sheff_andrew/screens/add_recipe/components/recipe_form.dart';

class AddRecipePage extends StatefulWidget {
  const AddRecipePage({super.key});

  @override
  AddRecipePageState createState() => AddRecipePageState();
}

class AddRecipePageState extends State<AddRecipePage>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(
              'Add Recipe',
              style: GoogleFonts.poppins(
                  fontSize: 22, fontWeight: FontWeight.bold),
            ),
            bottom: TabBar(
                controller: _tabController,
                labelStyle: GoogleFonts.poppins(
                  fontSize: 14,
                ),
                tabs: const <Widget>[
                  Tab(
                    text: 'Manual Entry',
                    icon: Icon(Icons.touch_app),
                  ),
                  Tab(
                    text: 'Generative Search',
                    icon: Icon(Icons.find_in_page),
                  ),
                ])),
        body: TabBarView(
          controller: _tabController,
          children: const <Widget>[
            RecipeForm(),
            GenerativeSearch(),
          ],
        ));
  }
}
