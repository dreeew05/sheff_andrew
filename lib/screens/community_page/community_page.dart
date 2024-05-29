import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sheff_andrew/screens/recipes/recipe_view_page.dart';

class CommunityPage extends StatelessWidget {
  const CommunityPage({super.key});

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Community'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Community Info',
              style: TextStyle(fontSize: 24),
            ),
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('recipes')
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
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
}
