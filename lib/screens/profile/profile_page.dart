/*
  Author: Carl Benedict Elipan
  Purpose of this file: Profile Page
*/
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  Future<List<Map<String, dynamic>>> _fetchUserRecipes() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return [];
    }

    String uid = user.uid;
    QuerySnapshot recipesSnapshot = await FirebaseFirestore.instance
        .collection('recipes')
        .where('user', isEqualTo: uid)
        .get();

    return recipesSnapshot.docs.map((doc) {
      var data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;
      return data;
    }).toList();
  }

  Future<void> _deleteRecipe(BuildContext context, String recipeId) async {
    try {
      await FirebaseFirestore.instance.collection('recipes').doc(recipeId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Recipe deleted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete the recipe: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/addrecipe');
        },
        label: const Text('Add recipe'),
        icon: const Icon(Icons.add),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Profile Page',
              style: TextStyle(fontSize: 24),
            ),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: _fetchUserRecipes(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return const Text('Error fetching recipes');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('No recipes found');
                } else {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        var recipe = snapshot.data![index];
                        return Card(
                          child: ListTile(
                            leading: recipe['image'] != null
                                ? Image.network(recipe['image'])
                                : null,
                            title: Text(recipe['name'] ?? 'No name'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Category: ${recipe['category'] ?? 'No category'}'),
                                Text('Meal Type: ${recipe['meal_type'] ?? 'No meal type'}'),
                                Text('Time to Cook: ${recipe['time_to_cook'] ?? 'No time to cook'}'),
                              ],
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                bool? confirm = await showDialog<bool>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Delete Recipe'),
                                      content: Text('Are you sure you want to delete this recipe?'),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop(false);
                                          },
                                          child: Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop(true);
                                          },
                                          child: Text('Delete'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                                if (confirm == true) {
                                  _deleteRecipe(context, recipe['id']);
                                }
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
