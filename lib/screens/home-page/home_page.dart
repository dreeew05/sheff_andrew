import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatelessWidget {
  Future<List<Map<String, String>>> _fetchRecipes() async {
    List<Map<String, String>> recipes = [];
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('community').get();
      for (var doc in querySnapshot.docs) {
        recipes.add({
          'recipeName': doc['recipeName'] ?? 'Unnamed Recipe',
          'primaryKey': doc['Primary Key:'],  // Fetching the Primary Key
        });
      }
    } catch (e) {
      print('Error fetching recipes: $e');
    }
    return recipes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Recipes'),
      ),
      body: FutureBuilder<List<Map<String, String>>>(
        future: _fetchRecipes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error fetching data'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No recipes found'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var recipe = snapshot.data![index];
                return ListTile(
                  title: Text(recipe['recipeName']!),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      'recipe_carousel/community', 
                      arguments: recipe['primaryKey'],
                    );
                  },
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/recipe_carousel');
        },
        child: Icon(Icons.add),
        tooltip: 'Add Recipe',
      ),
    );
  }
}
