import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Future<File?> pickImage({ImageSource? imageSource}) async {
  final pickedFile = await ImagePicker().pickImage(
    source: imageSource ?? ImageSource.gallery,
    imageQuality: 100,
  );
  if (pickedFile != null) {
    return File(pickedFile.path);
  }
  return null;
}

Future<List<File>?> pickMultipleImages() async {
  try {
    List<XFile> pickedFiles = await ImagePicker().pickMultiImage(
      limit: 10,
      imageQuality: 100,
    );
    if (pickedFiles.isNotEmpty) {
      return pickedFiles.map((file) => File(file.path)).toList();
    }
    return null;
  } catch (e) {
    print('Error picking multiple images: $e');
    return null;
  }
}

Future<File?> pickVideo() async {
  final pickedFile = await ImagePicker().pickVideo(source: ImageSource.gallery);
  if (pickedFile != null) {
    return File(pickedFile.path);
  }
  return null;
}

Future<List<File>?> pickFile() async {
  try {
    final ImagePicker imagePicker = ImagePicker();
    List<XFile?>? file = await imagePicker.pickMultipleMedia(
      limit: 5,
      imageQuality: 100,
    );
    if (file.isNotEmpty) {
      return file.map((e) => File(e!.path)).toList();
    }
    return null;
  } catch (e) {
    debugPrint(e.toString());
  }
  return null;
}
