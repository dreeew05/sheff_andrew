import 'package:flutter/material.dart';
import 'package:sheff_andrew/screens/community_page/community_page.dart';
import 'package:sheff_andrew/screens/community_page/anotherpage.dart';

class CommunityNavigator extends StatefulWidget {
  const CommunityNavigator({super.key});

  @override
  CommunityNavigatorState createState() => CommunityNavigatorState();
}

GlobalKey<NavigatorState> communityNavigatorKey = GlobalKey<NavigatorState>();

class CommunityNavigatorState extends State<CommunityNavigator> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: communityNavigatorKey,
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/another':
            return MaterialPageRoute(
              builder: (context) => const AnotherPage(postKey: '',),
            );
          case '/':
          default:
            return MaterialPageRoute(
              builder: (context) => const CommunityPage(),
            );
        }
      },
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: CommunityNavigator(),
  ));
}