import 'package:flutter/material.dart';
import 'package:sheff_andrew/screens/profile/profile_page.dart';
import 'package:sheff_andrew/screens/add_recipe/add_recipe_page.dart';

class ProfileNavigator extends StatefulWidget {
  const ProfileNavigator({super.key});

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
            // Use this to navigate certain pages inside this page
            switch (settings.name) {
              case '/addrecipe':
                return const AddRecipePage();
              default:
                break;
            }
            return const ProfilePage();
          },
        );
      },
    );
  }
}
