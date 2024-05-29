/*
  Author: Carl Benedict Elipan
  Purpose of this file: Profile Page
*/
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// For sign out
Future<void> _signOut() async {
  await FirebaseAuth.instance.signOut();
}

//Alert Dialogue for signing out
Future<void> _signOutDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Sign out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0xff006A4E),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.white),
                )),
          ),
          TextButton(
            onPressed: () {
              _signOut();
              Navigator.of(context).pop();
            },
            child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 201, 200, 200),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'Sign out',
                  style: TextStyle(color: Colors.white),
                )),
          ),
        ],
      );
    },
  );
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
        backgroundColor: Color(0xff006A4E), // white or colored
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          GestureDetector(
            onTap: () => _signOutDialog(context),
            child: Row(
              children: [
                const Text(
                  "Sign out",
                  style: TextStyle(color: Color(0xFFFFFFE0)),
                ),
                IconButton(
                  onPressed: () => _signOutDialog(context),
                  icon: const Icon(Icons.logout),
                  color: Color(0xFFFFFFE0),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Color(0xff006A4E),
        onPressed: () {
          Navigator.pushNamed(context, '/addrecipe')
              .then((_) => setState(() {}));
        },
        label: const Text(
          'Add recipe',
          style: TextStyle(color: Colors.white),
        ),
        icon: const Icon(Icons.add, color: Colors.white),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              children: [
                Expanded(
                  child: Container(
                    color: const Color(0xffffffff), // white or colored
                    padding: const EdgeInsets.all(10),
                    child: Center(
                      child: const Text(
                        'Personal Recipes',
                        style: TextStyle(
                            fontSize: 24,
                            color: Colors
                                .black), // can't decide on what to color so left it here in case background color is changed
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
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
