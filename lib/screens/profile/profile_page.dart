/*
  Author: Carl Benedict Elipan
  Purpose of this file: Profile Page
*/
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sheff_andrew/backend/firestore_service.dart';
import 'package:sheff_andrew/providers/user_provider.dart';
import 'package:sheff_andrew/screens/profile/components/profile_details.dart';
import 'package:sheff_andrew/screens/profile/components/profile_recipes.dart';
import 'theming.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirestoreService firestoreService = FirestoreService();
  double? scrolledUnderElevation = 10.0;
  Color selectedColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    final userKey = context.watch<UserProvider>().userKey;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Profile',
          style: GoogleFonts.poppins(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        scrolledUnderElevation: scrolledUnderElevation,
        shadowColor: Theme.of(context).colorScheme.shadow,
        actions: [
          PopupMenuButton<String>(
            onSelected: (String result) {
              switch (result) {
                case 'choose_theme':
                  chooseTheme(context);
                  break;
                case 'sign_out':
                  signOut();
                  break;
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'choose_theme',
                child: Text('Choose Theme'),
              ),
              const PopupMenuItem<String>(
                value: 'sign_out',
                child: Text('Sign Out'),
              ),
            ],
          )
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
      body: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                FutureBuilder<DocumentSnapshot>(
                  future: firestoreService.fetchUserDetails(),
                  builder: (BuildContext context,
                      AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || !snapshot.data!.exists) {
                      return Center(
                        child: Text(
                          'Document does not exist',
                          style: GoogleFonts.poppins(
                              fontSize: 28, fontWeight: FontWeight.bold),
                        ),
                      );
                    } else {
                      final Map<String, dynamic> profileData =
                          snapshot.data!.data()! as Map<String, dynamic>;
                      final String name = profileData['name'];
                      // Todo: Add Image
                      return ProfileDetails(name: name);
                    }
                  },
                ),
                const SizedBox(height: 10),
                StreamBuilder<QuerySnapshot>(
                  stream: firestoreService.fetchRecipesByCurrentUser(userKey),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Error: ${snapshot.error}',
                          style: GoogleFonts.poppins(),
                        ),
                      );
                    } else if (snapshot.hasData) {
                      final List recipeList = snapshot.data!.docs;
                      return Column(
                        children: recipeList.map((recipe) {
                          final postKey = recipe.data()['post_key'] as String;
                          final name = recipe.data()['name'] as String;
                          final image = recipe.data()['image'] as String;
                          final timeToCook =
                              recipe.data()['time_to_cook'].toString();

                          return ProfileRecipes(
                            postKey: postKey,
                            name: name,
                            image: image,
                            timeToCook: timeToCook,
                            onDelete: () async {
                              await firestoreService.deleteRecipe(postKey);
                            },
                          );
                        }).toList(),
                      );
                    } else {
                      return Center(
                          child: Text(
                        'No uploaded recipes yet',
                        style: GoogleFonts.poppins(fontSize: 20),
                      ));
                    }
                  },
                ),
              ],
            ),
          )),
    );
  }
}
