/*
  Author: Glen Andrew C. Bulaong
  Purpose of this file: Clickable Part of the ImagePickerDialog
*/

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sheff_andrew/common/utils/app_painter.dart';
import 'package:sheff_andrew/providers/recipe_form_provider.dart';

class ClickableOption extends StatelessWidget {
  final String optionText;
  final String orientation;
  final String imageType;

  const ClickableOption({
    super.key,
    required this.optionText,
    required this.orientation,
    required this.imageType,
  });

  RoundedRectangleBorder getOrientation() {
    switch (orientation) {
      case 'top':
        return const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.0),
            topRight: Radius.circular(16.0),
          ),
        );
      case 'bottom':
        return const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(16.0),
            bottomRight: Radius.circular(16.0),
          ),
        );
      default:
        // Middle
        return const RoundedRectangleBorder();
    }
  }

  void _setPickedImage(BuildContext context, ImageSource source) {
    final providerReader = context.read<RecipeFormProvider>();
    imageType == 'recipe'
        ? providerReader.setRecipePickedImage(source)
        : providerReader.setIngredientPickedImage(source);
  }

  @override
  Widget build(BuildContext context) {
    final appPainter = AppPainter();

    return SizedBox(
      height: 70,
      width: MediaQuery.of(context).size.width,
      child: ElevatedButton(
        onPressed: () {
          final source =
              optionText == 'Camera' ? ImageSource.camera : ImageSource.gallery;
          _setPickedImage(context, source);
          Navigator.pop(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: appPainter.getDialogOptionColor(),
          textStyle: GoogleFonts.poppins(fontSize: 16),
          shape: getOrientation(),
        ),
        child: Text(
          optionText,
          style: const TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
