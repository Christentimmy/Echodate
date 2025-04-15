
// widgets/tinder_card_details/user_hobbies_section.dart
import 'package:echodate/app/controller/user_controller.dart';
import 'package:echodate/app/modules/Interest/widgets/interest_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserHobbiesSection extends StatelessWidget {
  final UserController userController;

  const UserHobbiesSection({
    super.key,
    required this.userController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Hobbies",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: Colors.black,
          ),
        ),
        Obx(() {
          List? hobbies = userController.userModel.value?.hobbies;
          if (hobbies == null || hobbies.isEmpty) {
            return const SizedBox.shrink();
          }
          return Wrap(
            spacing: 8,
            runSpacing: 8,
            children: hobbies.map((interest) {
              return buildInterestCards(interest: interest);
            }).toList(),
          );
        }),
      ],
    );
  }
}