import 'dart:io';

class Ingredient {
  String label;
  double quantity;
  String unit;
  dynamic image;

  Ingredient(
      {required this.label,
      required this.quantity,
      required this.unit,
      required this.image});

  bool isImageFile() {
    if (image is File) {
      return true;
    }
    return false;
  }

  void replaceToLink(String imageLink) {
    image = imageLink;
  }
}
