import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sheff_andrew/dialogs/image_picker_dialog.dart';

class ImagePick extends StatefulWidget {
  final String imageType;
  final File? image;
  const ImagePick({super.key, required this.image, required this.imageType});

  @override
  _ImagePickState createState() => _ImagePickState();
}

class _ImagePickState extends State<ImagePick> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.center,
          child: GestureDetector(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return ImagePickerDialog(
                        imageType: widget.imageType,
                      );
                    });
              },
              child: CircleAvatar(
                radius: 50,
                backgroundImage: widget.image != null
                    ? FileImage(widget.image!)
                    : null, // No background if recipeImage is null
                child: widget.image == null
                    ? const Icon(Icons.add_photo_alternate_outlined)
                    : null, // Add the icon if no image is loaded
              )),
        ),
        const SizedBox(height: 5),
        Align(
          alignment: Alignment.center,
          child: TextButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return ImagePickerDialog(
                      imageType: widget.imageType,
                    );
                  });
            },
            child: Text(
              'Add Image',
              style: GoogleFonts.poppins(),
            ),
          ),
        )
      ],
    );
  }
}
