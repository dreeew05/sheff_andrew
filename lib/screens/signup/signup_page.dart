import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _acceptTerms = false;
  String _selectedProfileImage = '';

  void _signUp() async {
    if (_formKey.currentState!.validate() && _acceptTerms) {
      try {
        final newUser = await _auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        if (newUser != null) {
          // Add user information to Firestore
          await FirebaseFirestore.instance.collection('users').doc(newUser.user!.uid).set({
            'name': _nameController.text.trim(),
            'email': _emailController.text.trim(),
            'userKey': newUser.user!.uid,
            'bookmarks': [],
            'profileImage': _selectedProfileImage,
          });

          // Navigate to the next page or show a success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Sign up successful!')),
          );
          Navigator.pushNamed(context, '/');
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } else if (!_acceptTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You need to accept terms & conditions')),
      );
    }
  }

  void _chooseProfilePicture() async {
    final selectedImage = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Choose Profile Picture'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context, 'https://firebasestorage.googleapis.com/v0/b/sheff-andrew-e1613.appspot.com/o/profileicons%2Fchef_icon_4.png?alt=media&token=4519230f-bb80-4e41-aab7-49004217cd5b'),
                child: Image.network('https://firebasestorage.googleapis.com/v0/b/sheff-andrew-e1613.appspot.com/o/profileicons%2Fchef_icon_4.png?alt=media&token=4519230f-bb80-4e41-aab7-49004217cd5b', height: 50),
              ),
              SizedBox(height: 10),
              GestureDetector(
                onTap: () => Navigator.pop(context, 'https://firebasestorage.googleapis.com/v0/b/sheff-andrew-e1613.appspot.com/o/profileicons%2Fchef_icon_3.png?alt=media&token=7df54d3f-ec20-4362-9a88-8f3e03aa0ce7'),
                child: Image.network('https://firebasestorage.googleapis.com/v0/b/sheff-andrew-e1613.appspot.com/o/profileicons%2Fchef_icon_3.png?alt=media&token=7df54d3f-ec20-4362-9a88-8f3e03aa0ce7', height: 50),
              ),
              SizedBox(height: 10),
              GestureDetector(
                onTap: () => Navigator.pop(context, 'https://firebasestorage.googleapis.com/v0/b/sheff-andrew-e1613.appspot.com/o/profileicons%2Fchef_icon_2.png?alt=media&token=bca831b3-4c6e-4c23-95ed-c7ba98181756'),
                child: Image.network('https://firebasestorage.googleapis.com/v0/b/sheff-andrew-e1613.appspot.com/o/profileicons%2Fchef_icon_2.png?alt=media&token=bca831b3-4c6e-4c23-95ed-c7ba98181756', height: 50),
              ),
              SizedBox(height: 10),
              GestureDetector(
                onTap: () => Navigator.pop(context, 'https://firebasestorage.googleapis.com/v0/b/sheff-andrew-e1613.appspot.com/o/profileicons%2Fchef_icon_1.png?alt=media&token=77e2c6ba-b2bb-454b-9427-f96326964564'),
                child: Image.network('https://firebasestorage.googleapis.com/v0/b/sheff-andrew-e1613.appspot.com/o/profileicons%2Fchef_icon_1.png?alt=media&token=77e2c6ba-b2bb-454b-9427-f96326964564', height: 50),
              ),
            ],
          ),
        );
      },
    );

    if (selectedImage != null) {
      setState(() {
        _selectedProfileImage = selectedImage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Create an account',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Let's help you set up your account,\nit won't take long.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _confirmPasswordController,
                    decoration: const InputDecoration(
                      labelText: 'Confirm Password',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please confirm your password';
                      }
                      if (value != _passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  CheckboxListTile(
                    title: const Text("Accept terms & Condition"),
                    value: _acceptTerms,
                    onChanged: (newValue) {
                      setState(() {
                        _acceptTerms = newValue!;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _chooseProfilePicture,
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Text('Choose Profile Picture'),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                      onPressed: _signUp,
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: Text('Sign Up')),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context); // Go back to sign in page
                      },
                      child: const Text.rich(
                        TextSpan(
                          text: "Already a member? ",
                          children: [
                            TextSpan(
                              text: 'Sign In',
                              style: TextStyle(
                                color: Colors.orange,
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
