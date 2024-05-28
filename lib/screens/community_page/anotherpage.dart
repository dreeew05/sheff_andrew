import 'package:flutter/material.dart';

// Define the new page
class AnotherPage extends StatelessWidget {
  const AnotherPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Another Page'),
      ),
      body: const Center(
        child: Text(
          'Welcome to Another Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}