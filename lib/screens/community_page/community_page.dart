import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sheff_andrew/screens/recipe_view/recipe_view_page.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({Key? key}) : super(key: key);

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  Stream<List<String>> getAllCategories() {
    CollectionReference collectionRef =
        FirebaseFirestore.instance.collection('recipes');
    return collectionRef.snapshots().map((querySnapshot) {
      List<String> categories =
          querySnapshot.docs.map((doc) => doc['category'] as String).toList();
      return categories.toSet().toList();
    });
  }

  bool showFilterChips = false;
  List<String> selectedCategories = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Community Recipes',
            style: GoogleFonts.poppins(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.filter_list_alt),
              onPressed: () {
                setState(() {
                  if (showFilterChips) {
                    selectedCategories.clear();
                  }
                  showFilterChips = !showFilterChips;
                });
              },
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              categoryChips(),
              Expanded(
                child: StreamBuilder(
                  stream: (selectedCategories.isEmpty)
                      ? FirebaseFirestore.instance
                          .collection('recipes')
                          .snapshots()
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
                      return Text(
                        'No data available',
                        style: GoogleFonts.poppins(),
                      );
                    }

                    return ListView(
                      // padding: const EdgeInsets.all(8.0),
                      children: snapshot.data!.docs.map((doc) {
                        return StreamBuilder<DocumentSnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('posts')
                              .doc(doc['post_key'])
                              .snapshots(),
                          builder: (context, postSnapshot) {
                            if (postSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                            if (!postSnapshot.hasData ||
                                !postSnapshot.data!.exists) {
                              return Center(
                                  child: Text(
                                'Post data not available',
                                style: GoogleFonts.poppins(),
                              ));
                            }

                            final postData = postSnapshot.data!.data()
                                as Map<String, dynamic>;
                            Timestamp datePosted =
                                postData['date_posted'] as Timestamp;
                            DateTime date = datePosted.toDate();
                            String formattedDate =
                                DateFormat('MMMM dd, yyyy').format(date);

                            return StreamBuilder<DocumentSnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(postData['user'])
                                  .snapshots(),
                              builder: (context, userSnapshot) {
                                if (userSnapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                }
                                if (!userSnapshot.hasData ||
                                    !userSnapshot.data!.exists) {
                                  return Center(
                                      child: Text(
                                    'User data not available',
                                    style: GoogleFonts.poppins(),
                                  ));
                                }

                                final userData = userSnapshot.data!.data()
                                    as Map<String, dynamic>;
                                final userName = userData['name'];
                                final profileImage = userData['profileImage'];

                                return Card(
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 10.0),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            CircleAvatar(
                                              backgroundImage:
                                                  NetworkImage(profileImage),
                                              radius: 20,
                                            ),
                                            const SizedBox(width: 10),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  userName,
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  formattedDate,
                                                  style: GoogleFonts.poppins(
                                                    color: Colors.grey[600],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          child: Image.network(
                                            doc['image'],
                                            width: double.infinity,
                                            height: 200,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          doc['name'],
                                          style: GoogleFonts.poppins(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          '${doc['meal_type']} - ${doc['time_to_cook']} mins',
                                          style: GoogleFonts.poppins(
                                            color: Colors.grey[700],
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          doc['category'],
                                          style: GoogleFonts.poppins(
                                            color: Colors.grey[700],
                                          ),
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
                                                    postKey: doc['post_key'],
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Text(
                                              'View Post',
                                              style: GoogleFonts.poppins(),
                                            ),
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
        ));
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
            margin: const EdgeInsets.only(top: 10, bottom: 10),
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
                    label: Text(
                      category,
                      style: GoogleFonts.poppins(),
                    ),
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
