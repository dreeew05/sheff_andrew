/*
  Author: Carl Benedict Elipan
  Purpose of this file: Profile Page
*/
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sheff_andrew/backend/firestore_service.dart';
import 'package:sheff_andrew/providers/user_provider.dart';
import 'package:sheff_andrew/screens/profile/components/profile_details.dart';
import 'package:sheff_andrew/screens/profile/components/profile_recipes.dart';

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
  final FirestoreService firestoreService = FirestoreService();
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
