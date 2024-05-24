/*
  Author: Glen Andrew C. Bulaong
  Purpose of this file: Dialog for ImagePicker
*/

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sheff_andrew/dialogs/components/clickable_option.dart';

class ImagePickerDialog extends StatelessWidget {
  final String imageType;
  const ImagePickerDialog({super.key, required this.imageType});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Choose an image source',
        style: GoogleFonts.poppins(fontSize: 24),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClickableOption(
            optionText: 'Camera',
            orientation: 'top',
            imageType: imageType,
          ),
          const SizedBox(height: 7.5),
          ClickableOption(
            optionText: 'Gallery',
            orientation: 'bottom',
            imageType: imageType,
          )
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
