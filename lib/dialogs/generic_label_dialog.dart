import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sheff_andrew/providers/recipe_form_provider.dart';

class GenericLabelDialog extends StatefulWidget {
  final String topic;
  const GenericLabelDialog({super.key, required this.topic});

  @override
  _GenericLabelDialogState createState() => _GenericLabelDialogState();
}

class _GenericLabelDialogState extends State<GenericLabelDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _labelController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _labelController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final providerReader = context.read<RecipeFormProvider>();

    return Form(
      key: _formKey,
      child: AlertDialog(
        title: Text(
          'Add ${widget.topic} label',
          style: GoogleFonts.poppins(fontSize: 24),
        ),
        content: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: TextFormField(
            controller: _labelController,
            keyboardType: TextInputType.multiline,
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
                return 'Please enter a label';
              }
              return null;
            },
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
                switch (widget.topic) {
                  case 'diet':
                    providerReader.addDietLabel(_labelController.text);
                    break;
                  case 'health':
                    providerReader.addHealthLabel(_labelController.text);
                    break;
                  case 'tag':
                    providerReader.addTag(_labelController.text);
                    break;
                  case 'caution':
                    providerReader.addCaution(_labelController.text);
                    break;
                  default:
                    break;
                }
                // Clear form and exit dialog
                _labelController.clear();
                Navigator.pop(context);
              }
            },
            child: Text(
              'Add',
              style: GoogleFonts.poppins(),
            ),
          )
        ],
      ),
    );
  }
}
