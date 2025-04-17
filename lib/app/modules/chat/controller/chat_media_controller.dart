

import 'dart:io';
import 'package:get/get.dart';
import 'dart:typed_data';
import 'package:echodate/app/utils/image_picker.dart';
import 'package:video_compress/video_compress.dart';

class ChatMediaController extends GetxController {
  final Rxn<File> selectedFile = Rxn<File>(null);
  final Rxn<Uint8List> thumbnailData = Rxn<Uint8List>();
  final RxBool showMediaPreview = false.obs;

  // Check if file is a video
  bool isVideoFile(String path) {
    return path.toLowerCase().endsWith('.mp4') ||
        path.toLowerCase().endsWith('.mov') ||
        path.toLowerCase().endsWith('.avi') ||
        path.toLowerCase().endsWith('.wmv') ||
        path.toLowerCase().endsWith('.mkv');
  }
  
  // Get file type based on extension
  String? getFileType(String path) {
    if (isVideoFile(path)) {
      return "video";
    } else if (!path.toLowerCase().endsWith('.aac') &&
               !path.toLowerCase().endsWith('.mp3') &&
               !path.toLowerCase().endsWith('.wav')) {
      return "image";
    }
    return null;
  }

  // Pick image from gallery
  Future<void> pickImageFromGallery() async {
    final file = await pickImage();
    if (file != null) {
      selectedFile.value = file;
      showMediaPreview.value = true;
    }
  }

  // Pick video from gallery
  Future<void> pickVideoFromGallery() async {
    final file = await pickVideo();
    if (file != null) {
      selectedFile.value = file;
      showMediaPreview.value = true;
      
      // Generate thumbnail
      thumbnailData.value = await VideoCompress.getByteThumbnail(
        file.path,
        quality: 50,
        position: -1,
      );
    }
  }
  
  // Reset state
  void resetState() {
    selectedFile.value = null;
    thumbnailData.value = null;
    showMediaPreview.value = false;
  }
}