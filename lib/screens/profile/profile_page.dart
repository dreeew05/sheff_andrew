/*
  Author: Carl Benedict Elipan
  Purpose of this file: Profile Page
*/
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// For sign out
Future<void> signOut() async {
  await FirebaseAuth.instance.signOut();
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
      await FirebaseFirestore.instance
          .collection('recipes')
          .doc(recipeId)
          .delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Recipe deleted successfully')),
      );
      setState(() {}); // Trigger a rebuild to refresh the list
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
        actions: [
          GestureDetector(
            onTap: () => signOut(),
            child: Row(
              children: [
                const Text("Sign out"),
                IconButton(
                    onPressed: () => signOut(), icon: const Icon(Icons.logout)),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/addrecipe')
              .then((_) => setState(() {}));
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
                                Text(
                                    'Category: ${recipe['category'] ?? 'No category'}'),
                                Text(
                                    'Meal Type: ${recipe['meal_type'] ?? 'No meal type'}'),
                                Text(
                                    'Time to Cook: ${recipe['time_to_cook'] ?? 'No time to cook'}'),
                              ],
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                bool? confirm = await showDialog<bool>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Delete Recipe'),
                                      content: const Text(
                                          'Are you sure you want to delete this recipe?'),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop(false);
                                          },
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop(true);
                                          },
                                          child: const Text('Delete'),
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
