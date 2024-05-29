/*
  Author: Carl Benedict Elipan
  Purpose of this file: Recipe Information
*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RecipeTabView extends StatefulWidget {
  final String postKey;
  const RecipeTabView({super.key, required this.postKey});

  @override
  _RecipeTabViewState createState() => _RecipeTabViewState();
}

class _RecipeTabViewState extends State<RecipeTabView>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          TabBar(
            controller: _tabController,
            labelStyle: GoogleFonts.poppins(),
            tabs: const <Widget>[
              Tab(
                text: 'Ingredients',
              ),
              Tab(
                text: 'Steps',
              ),
              Tab(
                text: 'Other info',
              )
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('ingredients')
                      .where('post_key', isEqualTo: widget.postKey)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(
                          child: Text(
                        'No ingredients found.',
                        style: GoogleFonts.poppins(),
                      ));
                    }

                    final ingredients = snapshot.data!.docs;

                    return ListView.builder(
                      itemCount: ingredients.length,
                      itemBuilder: (context, index) {
                        final ingredient = ingredients[index];
                        final image = ingredient['image'] as String? ?? '';
                        final label =
                            ingredient['label'] as String? ?? 'Unknown';
                        final quantity = ingredient['quantity'] as double? ?? 0;
                        final unit = ingredient['unit'] as String? ?? '';

                        return Card(
                          margin: const EdgeInsets.only(
                            left: 10,
                            right: 10,
                            top: 5,
                            bottom: 5,
                          ),
                          child: ListTile(
                            leading: image.isNotEmpty
                                ? Image.network(image)
                                : const Icon(Icons.image),
                            title: Text(
                              label,
                              style: GoogleFonts.poppins(),
                            ),
                            subtitle: Text(
                              '$quantity $unit',
                              style: GoogleFonts.poppins(),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('recipe_info')
                      .where('post_key', isEqualTo: widget.postKey)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(
                          child: Text(
                        'No procedure steps found.',
                        style: GoogleFonts.poppins(),
                      ));
                    }

                    final recipeInfo = snapshot.data!.docs.first;
                    final steps = List<String>.from(
                        recipeInfo['steps'] as List<dynamic>? ?? []);

                    return ListView.builder(
                      itemCount: steps.length,
                      itemBuilder: (context, index) {
                        return Card(
                          margin: const EdgeInsets.only(
                            left: 10,
                            right: 10,
                            top: 5,
                            bottom: 5,
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              child: Text(
                                '${index + 1}',
                                style: GoogleFonts.poppins(),
                              ),
                            ),
                            title: Text(
                              steps[index],
                              style: GoogleFonts.poppins(),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
                // Todo: Put additonal information here
                Text('data'),
              ],
            ),
          )
        ],
      ),
    );
  }
}
