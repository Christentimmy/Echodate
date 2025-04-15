import 'package:echodate/app/models/user_model.dart';
import 'package:echodate/app/modules/home/controller/tinder_card_controller.dart';
import 'package:echodate/app/utils/age_calculator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserHeaderInfo extends StatelessWidget {
  final UserModel userModel;
  final TinderCardController tinderCardController;

  const UserHeaderInfo({
    super.key,
    required this.userModel,
    required this.tinderCardController,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final detailedUser = tinderCardController.userModel.value;
      String age = calculateAge(detailedUser?.dob ?? "").toString();
      
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${userModel.fullName} ($age)",
            style: const TextStyle(
              fontSize: 18,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(detailedUser?.location?.address ?? ""),
        ],
      );
    });
  }
}