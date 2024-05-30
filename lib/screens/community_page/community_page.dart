import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sheff_andrew/screens/recipe_view/recipe_view_page.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  Stream<List<String>> getAllCategories() {
    CollectionReference collectionRef = FirebaseFirestore.instance.collection('recipes');
    return collectionRef.snapshots().map((querySnapshot) {
      List<String> categories = querySnapshot.docs.map((doc) => doc['category'] as String).toList();
      return categories.toSet().toList();
    });
  }

  bool showFilterChips = false;
  List<String> selectedCategories = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Community Recipes')),
        leading: const Icon(Icons.food_bank),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list_alt),
            onPressed: () {
              setState(() {
                if (showFilterChips) {
                  selectedCategories.clear();
                }
                showFilterChips = !showFilterChips;
              });
            }
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            categoryChips(),
            Expanded(
              child: StreamBuilder(
                stream: (selectedCategories.isEmpty)
                    ? FirebaseFirestore.instance.collection('recipes').snapshots()
                    : FirebaseFirestore.instance
                        .collection('recipes')
                        .where('category', whereIn: selectedCategories)
                        .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return SizedBox(
                        height: MediaQuery.of(context).size.height * 2,
                        child: const CircularProgressIndicator());
                  }
                  if (!snapshot.hasData) {
                    return const Text('No data available');
                  }

                  return ListView(
                    padding: const EdgeInsets.all(8.0),
                    children: snapshot.data!.docs.map((doc) {
                      return StreamBuilder<DocumentSnapshot>(
                        stream: FirebaseFirestore.instance.collection('posts').doc(doc['post_key']).snapshots(),
                        builder: (context, postSnapshot) {
                          if (postSnapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          }
                          if (!postSnapshot.hasData || !postSnapshot.data!.exists) {
                            return const Center(child: Text('Post data not available'));
                          }

                          final postData = postSnapshot.data!.data() as Map<String, dynamic>;

                          return StreamBuilder<DocumentSnapshot>(
                            stream: FirebaseFirestore.instance.collection('users').doc(postData['user']).snapshots(),
                            builder: (context, userSnapshot) {
                              if (userSnapshot.connectionState == ConnectionState.waiting) {
                                return const Center(child: CircularProgressIndicator());
                              }
                              if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
                                return const Center(child: Text('User data not available'));
                              }

                              final userName = userSnapshot.data!['name'];

                              return Card(
                                margin: const EdgeInsets.symmetric(vertical: 10.0),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ListTile(
                                        contentPadding: EdgeInsets.zero,
                                        title: Text(doc['name'],
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18)),
                                        subtitle: Text(
                                            '${doc['meal_type']} - ${doc['time_to_cook']} mins'),
                                        leading: ClipRRect(
                                          borderRadius: BorderRadius.circular(8.0),
                                          child: Image.network(
                                            doc['image'],
                                            width: 80,
                                            height: 80,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        doc['category'],
                                        style: TextStyle(
                                            color: const Color.fromARGB(255, 0, 0, 0)),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        'Posted by: $userName',
                                        style: TextStyle(
                                            color: const Color.fromARGB(255, 0, 0, 0)),
                                      ),
                                      const SizedBox(height: 10),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => RecipeViewPage(
                                                  postKey: doc['post_key']
                                                ),
                                              ),
                                            );
                                          },
                                          child: const Text('View Post'),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  StreamBuilder<List<String>> categoryChips() {
    return StreamBuilder<List<String>>(
      stream: getAllCategories(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No categories found.'));
        } else if (!showFilterChips) {
          return SizedBox.shrink();
        } else {
          List<String> categories = snapshot.data!;
          return Container(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: categories.map((category) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: FilterChip(
                    selected: selectedCategories.contains(category),
                    onSelected: (bool selected) {
                      setState(() {
                        if (selected) {
                          selectedCategories.add(category);
                        } else {
                          selectedCategories.remove(category);
                        }
                      });
                    },
                    label: Text(category),
                  ),
                );
              }).toList(),
            ),
          );
        }
      },
    );
  }
}
