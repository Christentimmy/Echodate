import 'dart:io';
import 'package:image_picker/image_picker.dart';

Future<File?> pickImage({ImageSource? imageSource}) async {
  final pickedFile = await ImagePicker().pickImage(
    source: imageSource ?? ImageSource.gallery,
  );
  if (pickedFile != null) {
    return File(pickedFile.path);
  }
  return null;
}

Future<File?> pickVideo() async {
  final pickedFile = await ImagePicker().pickVideo(source: ImageSource.gallery);
  if (pickedFile != null) {
    return File(pickedFile.path);
  }
  return null;
}
