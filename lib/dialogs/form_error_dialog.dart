import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FormErrorDialog extends StatelessWidget {
  final String labelType;
  const FormErrorDialog({super.key, required this.labelType});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Transaction Error',
        style: GoogleFonts.poppins(
          fontSize: 24,
        ),
      ),
      content: Text(
        "$labelType should not be empty",
        style: GoogleFonts.poppins(),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            'Okay',
            style: GoogleFonts.poppins(),
          ),
        )
      ],
    );
  }
}
