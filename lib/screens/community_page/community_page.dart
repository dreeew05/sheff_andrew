import 'package:flutter/material.dart';
import 'package:sheff_andrew/screens/community_page/anotherpage.dart';


class CommunityPage extends StatelessWidget {
  const CommunityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Community'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Community Page',
              style: TextStyle(fontSize: 24),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AnotherPage(),
                  ),
                );
              },
              child: const Text('Go to Another Page'),
            ),
          ],
        ),
      ),
    );
  }
}