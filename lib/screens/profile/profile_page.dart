import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sheff_andrew/backend/firestore_service.dart';
import 'package:sheff_andrew/providers/user_provider.dart';
import 'package:sheff_andrew/screens/profile/components/profile_recipes.dart';
import 'theming.dart';

// Alert Dialogue for signing out
Future<void> _signOutDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Sign out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              signOut();
              Navigator.of(context).pop();
            },
            child: const Text('Sign out'),
          ),
        ],
      );
    },
  );
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirestoreService firestoreService = FirestoreService();
  double? scrolledUnderElevation = 10.0;
  Color selectedColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    final userKey = context.watch<UserProvider>().userKey;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Profile',
          style: GoogleFonts.poppins(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        scrolledUnderElevation: scrolledUnderElevation,
        shadowColor: Theme.of(context).colorScheme.shadow,
        actions: [
          PopupMenuButton<String>(
            onSelected: (String result) {
              switch (result) {
                case 'choose_theme':
                  chooseTheme(context);
                  break;
                case 'sign_out':
                  _signOutDialog(context);
                  break;
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'choose_theme',
                child: Text(
                  'Choose Theme',
                  style: GoogleFonts.poppins(),
                ),
              ),
              PopupMenuItem<String>(
                value: 'sign_out',
                child: Text(
                  'Sign Out',
                  style: GoogleFonts.poppins(),
                ),
              ),
            ],
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/addrecipe');
        },
        label: Text(
          'Add recipe',
          style: GoogleFonts.poppins(),
        ),
        icon: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
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
                    final String profileImage =
                        profileData['profileImage'] ?? '';
                    return Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: profileImage.isNotEmpty
                              ? NetworkImage(profileImage)
                              : null,
                          child: profileImage.isEmpty
                              ? const Icon(Icons.person, size: 50)
                              : null,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          name,
                          style: GoogleFonts.poppins(
                              fontSize: 28, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        const Divider(),
                        const SizedBox(height: 10),
                      ],
                    );
                  }
                },
              ),
              const SizedBox(height: 10),
              StreamBuilder<QuerySnapshot>(
                stream: firestoreService.fetchRecipesByCurrentUser(userKey),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error: ${snapshot.error}',
                        style: GoogleFonts.poppins(),
                      ),
                    );
                  } else if (snapshot.hasData) {
                    final List recipeList = snapshot.data!.docs;
                    return Column(
                      children: recipeList.map((recipe) {
                        final postKey = recipe.data()['post_key'] as String;
                        final name = recipe.data()['name'] as String;
                        final image = recipe.data()['image'] as String;
                        final timeToCook =
                            recipe.data()['time_to_cook'].toString();

                        return ProfileRecipes(
                          postKey: postKey,
                          name: name,
                          image: image,
                          timeToCook: timeToCook,
                          onDelete: () async {
                            await firestoreService.deleteRecipe(postKey);
                          },
                        );
                      }).toList(),
                    );
                  } else {
                    return Center(
                      child: Text(
                        'No uploaded recipes yet',
                        style: GoogleFonts.poppins(fontSize: 20),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
