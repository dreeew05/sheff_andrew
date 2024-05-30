import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ThemeNotifier with ChangeNotifier {
  ThemeData _currentTheme = ThemeData.light();

  ThemeData get currentTheme => _currentTheme;

  void setTheme(ThemeData theme) {
    _currentTheme = theme;
    notifyListeners();
  }
}

final List<Color> colors = [
  Colors.red,
  Colors.green,
  Colors.blue,
  Colors.yellow,
  Colors.orange,
  Colors.purple,
  Colors.cyan,
  Colors.pink,
  Colors.lime,
  Colors.teal,
  Colors.indigo,
  Colors.amber,
];

// For sign out
Future<void> signOut() async {
  await FirebaseAuth.instance.signOut();
}

Future<dynamic> chooseTheme(BuildContext context) {
    return showDialog(context: context, builder: (BuildContext context){
      return ThemeChooserDialog(onColorSelected: (color) {
        ThemeData newTheme = ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: color,
          ),
        );
      Provider.of<ThemeNotifier>(context, listen: false).setTheme(newTheme);
      },);
    });
  }

class ThemeChooserDialog extends StatelessWidget {
  final Function(Color) onColorSelected;

  const ThemeChooserDialog({super.key, required this.onColorSelected});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
          title: const Text('Choose Theme'),
          content: Container(
            width: double.maxFinite,
            height: 200,
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
              ), 
              itemCount: colors.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: (){
                    onColorSelected(colors[index]);
                    Navigator.pop(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colors[index],
                    ),
                    margin: const EdgeInsets.all(10.0),
                  ),
                );
              }
              ),
          ),  
      );  
  }
}