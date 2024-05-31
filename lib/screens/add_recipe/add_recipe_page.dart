/*
  Author: Glen Andrew C. Bulaong
  Purpose of this file: Add Recipe Page
*/

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sheff_andrew/providers/tab_controller_provider.dart';
import 'package:sheff_andrew/screens/add_recipe/components/generative_search.dart';
import 'package:sheff_andrew/screens/add_recipe/components/recipe_form.dart';

class AddRecipePage extends StatefulWidget {
  const AddRecipePage({super.key});

  @override
  AddRecipePageState createState() => AddRecipePageState();
}

class AddRecipePageState extends State<AddRecipePage>
    with TickerProviderStateMixin {
  // late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    // _tabController = TabController(length: 2, vsync: this);
    final providerReader = context.read<TabControllerProvider>();
    providerReader.initTabController(2, this);
  }

  @override
  void dispose() {
    final providerReader = context.read<TabControllerProvider>();
    // _tabController.dispose();
    providerReader.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final providerReader = context.read<TabControllerProvider>();
    return Scaffold(
        appBar: AppBar(
            title: Text(
              'Add Recipe',
              style: GoogleFonts.poppins(
                  fontSize: 22, fontWeight: FontWeight.bold),
            ),
            bottom: TabBar(
                controller: providerReader.tabController,
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
          controller: providerReader.tabController,
          children: const <Widget>[
            RecipeForm(),
            GenerativeSearch(),
          ],
        ));
  }
}
