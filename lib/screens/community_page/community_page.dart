import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sheff_andrew/screens/recipe_view/recipe_view_page.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  
  Future<Map<String, dynamic>?> fetchPostData(String postKey) async {
    // Fetch the post data from the 'posts' collection based on the post_key
    DocumentSnapshot postSnapshot =
        await FirebaseFirestore.instance.collection('posts').doc(postKey).get();

    if (postSnapshot.exists) {
      return postSnapshot.data() as Map<String, dynamic>;
    }
    return null;
  }

  Future<String?> fetchUserName(String userKey) async {
    // Fetch the user data from the 'users' collection based on the userKey
    DocumentSnapshot userSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(userKey).get();

    if (userSnapshot.exists) {
      return userSnapshot['name'];
    }
    return null;
  }
  Future<List<String>> getAllCategories() async {
    // Reference to your Firestore collection
    CollectionReference collectionRef = FirebaseFirestore.instance.collection('recipes');

    // Get all documents in the collection
    QuerySnapshot querySnapshot = await collectionRef.get();

    // Extract the 'category' field from each document
    List<String> categories = querySnapshot.docs.map((doc) => doc['category'] as String).toList();

    // Get unique categories
    List<String> uniqueCategories = categories.toSet().toList();

    return uniqueCategories;
  }

  bool showFilterChips = false;
  Future<List<String>>? _categoriesFuture;
  List<String> selectedCategories = [];

    @override
  void initState() {
    super.initState();
    _categoriesFuture = getAllCategories();
  }

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
                  selectedCategories.clear(); // Clear the selected categories
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
            catergoryChips(),
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
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: CircularProgressIndicator()));
                  }
                  if (!snapshot.hasData) {
                    return const Text('No data available');
                  }

                  return ListView(
                    padding: const EdgeInsets.all(8.0),
                    children: snapshot.data!.docs.map((doc) {
                      return FutureBuilder(
                        future: fetchPostData(doc['post_key']),
                        builder: (context,
                            AsyncSnapshot<Map<String, dynamic>?> postSnapshot) {
                          if (postSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          if (!postSnapshot.hasData ||
                              postSnapshot.data == null) {
                            return const Center(
                                child: Text('Post data not available'));
                          }

                          final postData = postSnapshot.data!;
                          return FutureBuilder(
                            future: fetchUserName(postData['user']),
                            builder:
                                (context, AsyncSnapshot<String?> userSnapshot) {
                              if (userSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                              if (!userSnapshot.hasData ||
                                  userSnapshot.data == null) {
                                return const Center(
                                    child: Text('User data not available'));
                              }

                              final userName = userSnapshot.data!;
                              return Card(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10.0),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          child: Image.network(
                                            doc['image'],
                                            width: 60,
                                            height: 60,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        doc['category'],
                                        style: TextStyle(
                                            color: const Color.fromARGB(
                                                255, 0, 0, 0)),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        'Posted by: $userName',
                                        style: TextStyle(
                                            color: const Color.fromARGB(
                                                255, 0, 0, 0)),
                                      ),
                                      const SizedBox(height: 10),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    RecipeViewPage(
                                                        postKey:
                                                            doc['post_key']),
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

  FutureBuilder<List<String>> catergoryChips() {
    return FutureBuilder<List<String>>(
            future: _categoriesFuture,
            builder: (context, snapshot){
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
                        ));
                    }).toList(),
                  ),
                );
              }
            },
          );
  }
}
