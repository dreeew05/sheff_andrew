import 'package:flutter/material.dart';
import 'package:sheff_andrew/screens/recipes/recipes_page.dart';

class RecipesNavigator extends StatefulWidget {
  const RecipesNavigator({super.key});

  @override
  RecipesNavigatorState createState() => RecipesNavigatorState();
}

GlobalKey<NavigatorState> recipesNavigatorKey = GlobalKey<NavigatorState>();

class RecipesNavigatorState extends State<RecipesNavigator> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: recipesNavigatorKey,
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) {
            return const RecipesPage();
          },
        );
      },
    );
  }
}
