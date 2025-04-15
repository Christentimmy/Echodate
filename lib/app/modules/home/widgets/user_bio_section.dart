
import 'package:echodate/app/modules/home/controller/tinder_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserBioSection extends StatelessWidget {
  final TinderCardController tinderCardController;

  const UserBioSection({
    super.key,
    required this.tinderCardController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "About",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 5),
        Obx(() {
          final userModel = tinderCardController.userModel.value;
          final maxBioLength = tinderCardController.maxBioLength;
          bool isExpanded = tinderCardController.isExpanded.value;
          
          if (userModel == null || userModel.bio == null) {
            return const SizedBox.shrink();
          }
          
          bool shouldTruncate = userModel.bio!.length > maxBioLength;
          String displayBio = shouldTruncate && !isExpanded
              ? "${userModel.bio!.substring(0, maxBioLength)}..."
              : userModel.bio!;
              
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                displayBio,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
              if (shouldTruncate)
                GestureDetector(
                  onTap: () {
                    tinderCardController.toggleShowFullBio();
                  },
                  child: Text(
                    isExpanded ? "Show less" : "Show more",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.orange,
                    ),
                  ),
                ),
            ],
          );
        }),
      ],
    );
  }
}