import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'anotherpage.dart';

class CommunityPage extends StatelessWidget {
  const CommunityPage({super.key});

  Future<Map<String, dynamic>?> fetchPostData(String postKey) async {
    // Fetch the post data from the 'posts' collection based on the post_key
    DocumentSnapshot postSnapshot = await FirebaseFirestore.instance.collection('posts').doc(postKey).get();

    if (postSnapshot.exists) {
      return postSnapshot.data() as Map<String, dynamic>;
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
                stream: FirebaseFirestore.instance.collection('recipes').snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  if (!snapshot.hasData) {
                    return const Text('No data available');
                  }

                  return ListView(
                    children: snapshot.data!.docs.map((doc) {
                      return FutureBuilder(
                        future: fetchPostData(doc['post_key']),
                        builder: (context, AsyncSnapshot<Map<String, dynamic>?> postSnapshot) {
                          if (postSnapshot.connectionState == ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          }
                          if (!postSnapshot.hasData || postSnapshot.data == null) {
                            return const Text('Post data not available');
                          }

                          final postData = postSnapshot.data!;
                          return ListTile(
                            title: Text(doc['name']),
                            subtitle: Text('${doc['meal_type']} - ${doc['time_to_cook']} mins'),
                            leading: Image.network(doc['image']),
                            trailing: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(doc['category']),
                                Text('Posted by: ${postData['user']}'),
                                Text('Date: ${postData['date_posted']}'),
                              ],
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AnotherPage(postKey: doc['post_key']),
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
