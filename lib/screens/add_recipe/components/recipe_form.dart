import 'package:flutter/material.dart';

class RecipeForm extends StatefulWidget {
  const RecipeForm({super.key});

  @override
  RecipeFormState createState() => RecipeFormState();
}

class RecipeFormState extends State<RecipeForm>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late TabController _tabController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _currentIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          TabBar(controller: _tabController, tabs: const [
            Tab(
              icon: Icon(Icons.description),
            ),
            Tab(
              icon: Icon(Icons.local_offer),
            ),
            Tab(
              icon: Icon(Icons.format_list_numbered),
            ),
            Tab(
              icon: Icon(Icons.info),
            ),
          ]),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                Center(child: Text('Recipe Details')),
                Center(child: Text('Ingredients')),
                Center(child: Text('Procedure')),
                Center(child: Text('Additional Facts')),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                if (_currentIndex == _tabController.length - 1) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Processing Data')));
                } else {
                  if (_currentIndex < _tabController.length - 1) {
                    _tabController.animateTo(_currentIndex + 1);
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(5.0), // Small border radius
                ),
              ),
              child: _currentIndex == _tabController.length - 1
                  ? const Text('Submit')
                  : const Text('Next'),
            ),
          ),
        ],
      ),
    );
  }
}
