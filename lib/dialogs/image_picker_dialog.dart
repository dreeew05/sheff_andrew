import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sheff_andrew/dialogs/components/clickable_option.dart';

class ImagePickerDialog extends StatelessWidget {
  const ImagePickerDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Choose an image source',
        style: GoogleFonts.poppins(fontSize: 24),
      ),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClickableOption(optionText: 'Camera', orientation: 'top'),
          SizedBox(height: 7.5),
          ClickableOption(optionText: 'Gallery', orientation: 'bottom')
        ],
      ),
      actions: <Widget>[
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'Close',
              style: GoogleFonts.poppins(),
            ))
      ],
    );
  }
}
