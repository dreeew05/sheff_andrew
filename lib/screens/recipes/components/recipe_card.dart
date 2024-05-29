import 'package:flutter/material.dart';
import '../recipe_view_page.dart';

class RecipeCard extends StatelessWidget {
  const RecipeCard({
    super.key,
    required this.recipe,
  });

  final Map<String, dynamic> recipe;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      clipBehavior: Clip.antiAlias,
      child: Ink.image(
          image: NetworkImage(recipe['image']),
        fit: BoxFit.cover,
        child: InkWell(
          onTap: () {
            // Add your onTap logic here
            Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    RecipeViewPage(postKey: recipe['post_key'])
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
                  recipe['name'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                //author/chef, remove const if done
                const Text("By Chef: Gwapo", 
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                )),
              ],
          ),
        ),                          ),
      ),
    );
  }
}
