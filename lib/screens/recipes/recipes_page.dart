// Starter Code for Recipes Page

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RecipesPage extends StatefulWidget {
  const RecipesPage({super.key});

  @override
  RecipesPageState createState() => RecipesPageState();
}

class RecipesPageState extends State<RecipesPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String recipeName = '';
  String ingredients = '';
  String procedure = '';
  String primaryKey = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)!.settings.arguments as String;
      setState(() {
        primaryKey = args;
      });
      _fetchRecipeData(args);
    });
  }

  Future<void> _fetchRecipeData(String $primaryKey) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('community')
          .where('Primary Key:', isEqualTo: $primaryKey)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Fetching the recipe name from the document
        setState(() {
          recipeName =
              querySnapshot.docs.first['recipeName'] ?? 'No Recipe Name';
          ingredients =
              querySnapshot.docs.first['ingredients'] ?? 'No Ingredients';
          procedure = querySnapshot.docs.first['procedure'] ?? 'No Procedure';
        });
      } else {
        setState(() {
          recipeName = 'No Recipe Name';
          ingredients = 'No Ingredients';
          procedure = 'No Procedure';
        });
      }
    } catch (e) {
      print('Error fetching recipe data: $e');
    }
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
        title: const Text('Community'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              recipeName,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Primary Key: $primaryKey',
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
          ),
          Spacer(),
          TabBar(
            controller: _tabController,
            tabs: [
              Tab(text: 'Ingredients'),
              Tab(text: 'Procedure'),
            ],
            indicator: BoxDecoration(
              color: Colors.green, // Selected tab background color
              borderRadius: BorderRadius.circular(5),
            ),
            unselectedLabelColor: Colors.black,
            labelColor: Colors.white,
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                Center(
                  child: Text(ingredients),
                ),
                Center(
                  child: Text(procedure),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
