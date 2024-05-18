import 'package:flutter/material.dart';
import 'package:sheff_andrew/screens/profile/profile_page.dart';
import 'package:sheff_andrew/screens/recipe_form/recipe_form_page.dart';

class ProfileNavigator extends StatefulWidget {
  const ProfileNavigator({Key? key});

  @override
  ProfileNavigatorState createState() => ProfileNavigatorState();
}

GlobalKey<NavigatorState> profileNavigatorKey = GlobalKey<NavigatorState>();

class ProfileNavigatorState extends State<ProfileNavigator> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: profileNavigatorKey,
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (context) {
            if (settings.name == '/recipeform') {
              return RecipeFormPage();
            }
            return const ProfilePage();
          },
        );
      },
    );
  }
}
