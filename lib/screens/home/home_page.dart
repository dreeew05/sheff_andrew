/*
  Author: Glen Andrew C. Bulaong
  Purpose of this file: Home Page
*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sheff_andrew/backend/firestore_service.dart';
import 'package:sheff_andrew/screens/home/components/hello_profile.dart';
import 'package:sheff_andrew/screens/home/components/new_recipes.dart';
import 'package:sheff_andrew/screens/home/components/recipe_carousel.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final FirestoreService firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Invisible AppBar
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.025),
        child: AppBar(
          backgroundColor: Colors.transparent,
        ),
      ),
      body: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                      return HelloProfile(name: name);
                    }
                  },
                ),
                const SizedBox(height: 20),
                const Divider(),
                const SizedBox(height: 20),
                const RecipeCarousel(),
                Text(
                  "New Recipes",
                  textAlign: TextAlign.left,
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                NewRecipes(),
              ],
            ),
          )),
    );
  }
}
