/*
  Author: Carl Benedict Elipan
  Purpose of this file: Recipe Information
*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sheff_andrew/screens/recipe_view/components/ingredient_card.dart';

final Map<String, String> infoDescriptionMap = {
  'calories': 'Calories',
  'cautions': 'Cautions',
  'health_labels': 'Health Labels',
  'diet_labels': 'Diet Labels'
};

final Map<String, Widget> infoIconMap = {
  'calories': const Icon(Icons.electric_bolt_outlined),
  'cautions': const Icon(Icons.warning_outlined),
  'health_labels': const Icon(Icons.local_hospital_outlined),
  'diet_labels': const Icon(Icons.food_bank_outlined)
};

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
      child: Column(children: [
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
            child: TabBarView(controller: _tabController, children: [
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
                  final image = ingredient['image'];
                  final label = ingredient['label'];
                  final quantity = ingredient['quantity'];
                  final unit = ingredient['unit'];

                  return Card(
                    margin: const EdgeInsets.only(
                      left: 10,
                      right: 10,
                      top: 5,
                      bottom: 5,
                    ),
                    // child: ListTile(
                    //   leading: image.isNotEmpty
                    //       ? Image.network(image)
                    //       : const Icon(Icons.image),
                    //   title: Text(
                    //     label,
                    //     style: GoogleFonts.poppins(),
                    //   ),
                    //   subtitle: Text(
                    //     '$quantity $unit',
                    //     style: GoogleFonts.poppins(),
                    //   ),
                    // ),
                    child: IngredientCard(
                      image: image,
                      name: label,
                      quantity: quantity.toString(),
                      unit: unit,
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
              // Get the list of documents in the snapshot
              final documents = snapshot.data!.docs.first;
              final docData = documents.data() as Map<String, dynamic>;

              // Check if there are no documents

              return ListView(
                scrollDirection: Axis.vertical,
                children: docData.entries.map((entry) {
                  if (infoDescriptionMap.containsKey(entry.key) &&
                      entry.value.toString() != '[]') {
                    return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                infoIconMap[entry.key] ?? Container(),
                                Padding(
                                  padding: const EdgeInsets.only(left: 4.0),
                                  child: Text(
                                      '${infoDescriptionMap[entry.key]}',
                                      style: GoogleFonts.poppins(fontSize: 16)),
                                ),
                              ],
                            ),
                          ),
                          if (entry.value is List<dynamic>)
                            Wrap(
                              children: entry.value.map<Widget>((label) {
                                return Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Chip(
                                    label: Text(
                                      label.toString(),
                                      style: GoogleFonts.poppins(),
                                    ),
                                    backgroundColor: Theme.of(context)
                                        .colorScheme
                                        .secondaryContainer,
                                  ),
                                );
                              }).toList(),
                            ),
                          if (entry.value is String)
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 16.0, bottom: 8.0),
                              child: Text('Amount: ${entry.value}',
                                  style: GoogleFonts.poppins()),
                            )
                        ]);
                  }
                  return const SizedBox.shrink();
                }).toList(),
              );
            },
          )
        ]))
      ]),
    );
  }
}
