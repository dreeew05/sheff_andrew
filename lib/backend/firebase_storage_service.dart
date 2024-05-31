/*
  Author: Glen Andrew C. Bulaong
  Purpose of this file: Allowing the user to upload images to Firebase Storage
*/

import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:sheff_andrew/common/utils/constants.dart';
import 'package:uuid/uuid.dart';

class FirebaseStorageService {
  final Constants constants = Constants();
  Future<String> uploadImageAngGetLink(File? image, String imageFolder) async {
    String defaultImageLink;
    if (imageFolder == 'recipes') {
      defaultImageLink = constants.defaultRecipeImageLink;
    } else {
      defaultImageLink = constants.defaultIngredientImageLink;
    }

    // Guard clause if file is null
    if (image == null) {
      return defaultImageLink;
    }

    const uuid = Uuid();
    final storageRef = FirebaseStorage.instance.ref();
    final uniqueID = uuid.v4();
    final imagesRef =
        storageRef.child("$imageFolder/$uniqueID.${getFileExtension(image)}");

    // Upload the file to the bucket
    try {
      await imagesRef.putFile(File(image.path));
      String downloadURL = await imagesRef.getDownloadURL();
      return downloadURL;
    } catch (e) {
      return defaultImageLink;
    }
  }

  String getFileExtension(File? imageFile) {
    String filePath = imageFile!.path;
    int lastIndex = filePath.lastIndexOf('.');
    if (lastIndex != -1 && lastIndex != 0 && lastIndex != filePath.length - 1) {
      String extension = filePath.substring(lastIndex + 1).toLowerCase();
      return extension;
    }
    return '.jpg';
  }
}
