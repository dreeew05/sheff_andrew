/*
  Author: Glen Andrew C. Bulaong
  Purpose of this file: Persistent Navigation Bar Implementation
*/

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sheff_andrew/screens/community_page/community_navigator.dart';
import 'package:sheff_andrew/screens/home/home_navigator.dart';
import 'package:sheff_andrew/screens/profile/profile_navigator.dart';
import 'package:sheff_andrew/screens/recipes/recipes_navigator.dart';

class AppNavigator extends StatefulWidget {
  const AppNavigator({super.key});

  @override
  AppNavigatorState createState() => AppNavigatorState();
}

class AppNavigatorState extends State<AppNavigator> {
  int _selectedIndex = 0;

  // For Popping the Navigator [Phone Back Button]
  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    homeNavigatorKey,
    recipesNavigatorKey,
    communityNavigatorKey,
    profileNavigatorKey
  ];

  @override
  Widget build(BuildContext context) {
    bool hasUnsavedChanges = true;
    return PopScope(
      canPop: !hasUnsavedChanges,
      onPopInvoked: (didPop) async {
        bool shouldPop =
            _navigatorKeys[_selectedIndex].currentState?.canPop() ?? false;
        if (!didPop && shouldPop) {
          _navigatorKeys[_selectedIndex]
              .currentState
              ?.pop(_navigatorKeys[_selectedIndex].currentContext);
        } else {
          SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop');
        }
      },
      child: Scaffold(
        bottomNavigationBar: NavigationBar(
          onDestinationSelected: (int index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          selectedIndex: _selectedIndex,
          indicatorColor: Colors.amber,
          destinations: const <Widget>[
            NavigationDestination(
              selectedIcon: Icon(Icons.home),
              icon: Icon(Icons.home_outlined),
              label: 'Home',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.food_bank),
              icon: Icon(Icons.food_bank_outlined),
              label: 'Recipes',
            ),
            NavigationDestination(
              icon: Icon(Icons.groups_outlined),
              selectedIcon: Icon(Icons.groups),
              label: 'Community',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
        body: SafeArea(
          top: false,
          child: IndexedStack(
            index: _selectedIndex,
            children: const <Widget>[
              HomeNavigator(),
              RecipesNavigator(),
              CommunityNavigator(),
              ProfileNavigator()
            ],
          ),
        ),
      ),
    );
  }
}
