
// widgets/tinder_card_details/user_basic_info_section.dart
import 'package:echodate/app/modules/home/controller/tinder_card_controller.dart';
import 'package:echodate/app/utils/age_calculator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserBasicInfoSection extends StatelessWidget {
  final TinderCardController tinderCardController;

  const UserBasicInfoSection({
    super.key,
    required this.tinderCardController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Basic Information",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 10),
        Obx(
          () => BasicInfoTile(
            leading: "Gender: ",
            title: tinderCardController.userModel.value?.gender?.toUpperCase() ?? "",
          ),
        ),
        Obx(() {
          final userModel = tinderCardController.userModel;
          String dob = userModel.value?.dob ?? "";
          if (dob.isEmpty) return const SizedBox.shrink();
          int age = calculateAge(dob);
          return BasicInfoTile(
            leading: "Age: ",
            title: "${age.toString()} Years Old",
          );
        }),
      ],
    );
  }
}

class BasicInfoTile extends StatelessWidget {
  final String leading;
  final String title;

  const BasicInfoTile({
    super.key,
    required this.leading,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: leading,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          TextSpan(
            text: title,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}