import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sheff_andrew/screens/recipe_view/recipe_view_page.dart';

class CommunityPage extends StatelessWidget {
  const CommunityPage({super.key});

  Stream<Map<String, dynamic>?> fetchPostData(String postKey) {
    return FirebaseFirestore.instance
        .collection('posts')
        .doc(postKey)
        .snapshots()
        .map((snapshot) => snapshot.data());
  }

  Stream<String?> fetchUserName(String userKey) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userKey)
        .snapshots()
        .map((snapshot) => snapshot.data()?['name']);
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
                      return StreamBuilder(
                        stream: fetchPostData(doc['post_key']),
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
                          return StreamBuilder(
                            stream: fetchUserName(postData['user']),
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
                                      Text(doc['name'],
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18)),
                                      const SizedBox(height: 10),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8.0),
                                        child: Image.network(
                                          doc['image'],
                                          width: double.infinity,
                                          height: 200,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        '${doc['meal_type']} - ${doc['time_to_cook']} mins',
                                        style: const TextStyle(
                                            color: Color.fromARGB(255, 0, 0, 0)),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        doc['category'],
                                        style: const TextStyle(
                                            color: Color.fromARGB(255, 0, 0, 0)),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        'Posted by: $userName',
                                        style: const TextStyle(
                                            color: Color.fromARGB(255, 0, 0, 0)),
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
