import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:sheff_andrew/app_navigator.dart';
import 'package:sheff_andrew/providers/generative_search_provider.dart';
import 'package:sheff_andrew/providers/recipe_form_provider.dart';
import 'package:sheff_andrew/providers/user_provider.dart';
import 'package:sheff_andrew/screens/signup/signin_page.dart';
import 'package:sheff_andrew/screens/signup/signup_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: ((context) => RecipeFormProvider())),
      ChangeNotifierProvider(create: ((context) => GenerativeSearchProvider())),
      ChangeNotifierProvider(create: ((context) => UserProvider()))
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final providerReader = context.read<UserProvider>();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final userData = snapshot.data!;
                  providerReader.setUserKey(userData.uid);
                  return const AppNavigator();
                } else {
                  // User is not signed in
                  return SignInPage();
                }
              },
            ),
        '/signup': (context) => SignUpPage(),
      },
    );
  }
}
