import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AnotherPage extends StatelessWidget {
  final String postKey;

  const AnotherPage({super.key, required this.postKey});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Another Page'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Ingredients'),
              Tab(text: 'Procedure'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            IngredientsTab(postKey: postKey),
            ProcedureTab(postKey: postKey),
          ],
        ),
      ),
    );
  }
}

class IngredientsTab extends StatelessWidget {
  final String postKey;

  const IngredientsTab({super.key, required this.postKey});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('ingredients')
          .where('post_key', isEqualTo: postKey)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No ingredients found.'));
        }

        final ingredients = snapshot.data!.docs;

        return ListView.builder(
          itemCount: ingredients.length,
          itemBuilder: (context, index) {
            final ingredient = ingredients[index];
            final image = ingredient['image'] as String? ?? '';
            final label = ingredient['label'] as String? ?? 'Unknown';
            final quantity = ingredient['quantity'] as double? ?? 0;
            final unit = ingredient['unit'] as String? ?? '';

            return ListTile(
              leading: image.isNotEmpty
                  ? Image.network(image)
                  : const Icon(Icons.image),
              title: Text(label),
              subtitle: Text('$quantity $unit'),
            );
          },
        );
      },
    );
  }
}

class ProcedureTab extends StatelessWidget {
  final String postKey;

  const ProcedureTab({super.key, required this.postKey});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('recipe_info')
          .where('post_key', isEqualTo: postKey)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No procedure steps found.'));
        }

        final recipeInfo = snapshot.data!.docs.first;
        final steps = List<String>.from(recipeInfo['steps'] as List<dynamic>? ?? []);

        return ListView.builder(
          itemCount: steps.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: CircleAvatar(
                child: Text('${index + 1}'),
              ),
              title: Text(steps[index]),
            );
          },
        );
      },
    );
  }
}
