import 'package:flutter/material.dart';
import 'package:sheff_andrew/screens/community_page/community_page.dart';

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
        return MaterialPageRoute(
          builder: (context) => const CommunityPage(),
        );
      },
    );
  }
}
