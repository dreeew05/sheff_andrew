import 'package:flutter/material.dart';
import 'package:sheff_andrew/common/utils/app_navigation_bar.dart';
import 'package:sheff_andrew/screens/home-page/components/recipe_carousel.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: RecipeCarousel(),
      ),
      bottomNavigationBar: const AppNavigationBar(),
    );
  }
}
