import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileImage extends StatelessWidget {
  final File? imageFile;
  final String? imageUrl;
  final String index;
  final bool isLarge;
  final VoidCallback onPickImage;
  final VoidCallback onRemove;

  const ProfileImage({
    super.key,
    required this.imageFile,
    required this.imageUrl,
    required this.index,
    required this.onPickImage,
    required this.onRemove,
    this.isLarge = false,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = Get.width;
    double screenHeight = Get.height;

    return GestureDetector(
      onTap: onPickImage, // Tap to pick an image
      child: Container(
        margin: EdgeInsets.only(bottom: screenHeight * 0.01),
        width: isLarge ? screenWidth * 0.585 : screenWidth * 0.28,
        height: isLarge ? screenHeight * 0.319 : screenHeight * 0.147,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey,
          border: isLarge ? Border.all(color: Colors.blue, width: 2) : null,
          image: imageFile != null
              ? DecorationImage(image: FileImage(imageFile!), fit: BoxFit.cover)
              : (imageUrl != null &&
                      imageUrl!.isNotEmpty) // Use imageUrl if available
                  ? DecorationImage(
                      image: NetworkImage(imageUrl!), fit: BoxFit.cover)
                  : const DecorationImage(
                      image: AssetImage("assets/images/placeholder1.png"),
                      fit: BoxFit.cover,
                    ),
        ),
        child: Stack(
          children: [
            // Close Button (Only show if image exists)
            if (imageFile != null || (imageUrl != null && imageUrl!.isNotEmpty))
              Positioned(
                top: 5,
                right: 5,
                child: GestureDetector(
                  onTap: onRemove,
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red,
                    ),
                    padding: const EdgeInsets.all(4),
                    child: const Icon(
                      Icons.close,
                      size: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

            // Index Label
            Positioned(
              bottom: 5,
              right: 5,
              child: CircleAvatar(
                radius: screenWidth * 0.03,
                backgroundColor: Colors.white,
                child: Text(
                  index,
                  style: TextStyle(
                    fontSize: screenWidth * 0.03,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            // "+" Icon for empty upload slots
            if (imageFile == null && (imageUrl == null || imageUrl!.isEmpty))
              Center(
                child: Icon(Icons.add_a_photo,
                    size: screenWidth * 0.07, color: Colors.white70),
              ),
          ],
        ),
      ),
    );
  }
}
