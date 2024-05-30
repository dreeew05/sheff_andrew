import 'package:flutter/material.dart';
import '../../recipe_view/recipe_view_page.dart';
import 'package:sheff_andrew/backend/firestore_service.dart';

class RecipeCard extends StatefulWidget {
  const RecipeCard({
    super.key,
    required this.recipe,
  });

  final Map<String, dynamic> recipe;

  @override
  State<RecipeCard> createState() => _RecipeCardState();
}

class _RecipeCardState extends State<RecipeCard> {
  
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      clipBehavior: Clip.antiAlias,
      child: Ink.image(
          image: NetworkImage(widget.recipe['image']),
        fit: BoxFit.cover,
        child: InkWell(
          onTap: () {
            // Add your onTap logic here
            Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    RecipeViewPage(postKey: widget.recipe['post_key'])
                )
              );
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.recipe['name'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                //author/chef, remove const if done
                RecipeUserNameWidget(userKey: widget.recipe['user']),
              ],
          ),
        ),                          
      ),
      ),
    );
  }
}


class RecipeUserNameWidget extends StatelessWidget {
  final String? userKey;
  final FirestoreService firestoreService = FirestoreService();

  RecipeUserNameWidget({required this.userKey});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: firestoreService.getRecipeUserName(userKey),
      builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('');
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data == null) {
          return const Text('User not found');
        } else {
          return Text('By Chef: ${snapshot.data}', 
            style: const TextStyle(
            color: Colors.white,
            fontSize: 12.0,
            fontWeight: FontWeight.bold,));
        }
      },
    );
  }
}