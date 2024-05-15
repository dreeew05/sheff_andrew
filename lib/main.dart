import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sheff_andrew/screens/home-page/home_page.dart';

void main() async {
  // runApp(const MainApp()); // Uncomment this line in the future
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MaterialApp(home: HomePage()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Hello World!'),
        ),
      ),
    );
  }
}
