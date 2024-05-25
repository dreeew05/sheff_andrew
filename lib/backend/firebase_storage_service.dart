import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

const String defaultRecipeImageLink =
    'https://firebasestorage.googleapis.com/v0/b/sheff-andrew-e1613.appspot.com/o/recipes%2Frecipe-default-image.png?alt=media&token=ac225653-981f-46f8-b028-12533e0e89bc';

const String defaultIngredientImageLink =
    'https://firebasestorage.googleapis.com/v0/b/sheff-andrew-e1613.appspot.com/o/ingredients%2Fdefault-ingredient-image.png?alt=media&token=520960ad-ee08-410e-b98a-3818f61122d9';

class FirebaseStorageService {
  Future<String> uploadImageAngGetLink(File? image, String imageFolder) async {
    String defaultImageLink;
    if (imageFolder == 'recipes') {
      defaultImageLink = defaultRecipeImageLink;
    } else {
      defaultImageLink = defaultIngredientImageLink;
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
      await imagesRef.putFile(File(image!.path));
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
