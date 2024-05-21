import 'dart:io';

import 'package:image_picker/image_picker.dart';

abstract class ImagePickerProviderInterface {
  File? get selectedImage;
  Future setPickedImage(ImageSource source);
}
