import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sheff_andrew/backend/firestore_service.dart';

class RecipesPage extends StatefulWidget {
  const RecipesPage({super.key});

  @override
  _RecipesPageState createState() => _RecipesPageState();
}

class _RecipesPageState extends State<RecipesPage> {
  final FirestoreService firestoreService = FirestoreService();
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // Invisible AppBar
      appBar: null,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          // Position of the each component is at start
          // Change this to desired position
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // To have a space between the notification bar and the app
            // since there is no appBar
            const SizedBox(height: 40),
            TextField(
              decoration: InputDecoration(
                hintText: 'Search Recipe',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
                hintStyle: GoogleFonts.poppins(),
              ),
              style: GoogleFonts.poppins(),
              onChanged: (text) {
                setState(() {
                  _searchQuery = text;
                });
              },
            ),
            const SizedBox(height: 10),
            Expanded(
                child: StreamBuilder<QuerySnapshot>(
              stream: _searchQuery.isEmpty
                  ? firestoreService.getRecipeStream()
                  : firestoreService.getSearchedRecipeStream(_searchQuery),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Something went wrong',
                      style: GoogleFonts.poppins(),
                    ),
                  );
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasData) {
                  final List recipeList = snapshot.data!.docs;

                  return ListView.builder(
                      itemCount: recipeList.length,
                      itemBuilder: (context, index) {
                        final recipe =
                            recipeList[index].data() as Map<String, dynamic>;
                        return Text(recipe['name']);
                      });
                } else {
                  return Center(
                    child: Text(
                      'No data',
                      style: GoogleFonts.poppins(),
                    ),
                  );
                }
              },
            ))
          ],
        ),
      ),
    );
  }
}
