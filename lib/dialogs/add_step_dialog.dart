import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sheff_andrew/providers/recipe_form_provider.dart';

class AddStepDialog extends StatefulWidget {
  const AddStepDialog({super.key});

  @override
  _AddStepDialogState createState() => _AddStepDialogState();
}

class _AddStepDialogState extends State<AddStepDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _stepController = TextEditingController();

  @override
  void dispose() {
    _stepController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final providerReader = context.read<RecipeFormProvider>();

    return Form(
        key: _formKey,
        child: AlertDialog(
          title: Text(
            'Add Step',
            style: GoogleFonts.poppins(fontSize: 24),
          ),
          content: SingleChildScrollView(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: TextFormField(
                controller: _stepController,
                keyboardType: TextInputType.multiline,
                maxLines: 5,
                style: GoogleFonts.poppins(),
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  errorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                    color: Color.fromARGB(255, 214, 44, 32),
                    width: 1.0,
                  )),
                  labelStyle: GoogleFonts.poppins(),
                  icon: const Icon(Icons.label),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a step';
                  }
                  return null;
                },
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Cancel',
                style: GoogleFonts.poppins(),
              ),
            ),
            TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  providerReader.addStep(_stepController.text);
                  // Clear form and exit dialog
                  _stepController.clear();
                  Navigator.pop(context);
                }
              },
              child: Text(
                'Add',
                style: GoogleFonts.poppins(),
              ),
            )
          ],
        ));
  }
}
