import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sheff_andrew/screens/home-page/home_page.dart';
import 'package:sheff_andrew/screens/signup/signin_page.dart';
import 'package:sheff_andrew/screens/signup/signup_page.dart'; // Import the SignUpPage

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) => SignInPage(),
      '/signup': (context) => SignUpPage(),
      // Add other routes here
    },
  ));
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
