
// widgets/tinder_card_details/tinder_card_details_content.dart
import 'package:echodate/app/controller/user_controller.dart';
import 'package:echodate/app/models/user_model.dart';
import 'package:echodate/app/modules/home/controller/tinder_card_controller.dart';
import 'package:echodate/app/modules/home/widgets/home_widgets.dart';
import 'package:echodate/app/modules/home/widgets/report_button.dart';
import 'package:echodate/app/modules/home/widgets/user_basic_info_section.dart';
import 'package:echodate/app/modules/home/widgets/user_bio_section.dart';
import 'package:echodate/app/modules/home/widgets/user_header_info.dart';
import 'package:echodate/app/modules/home/widgets/user_hobbies_section.dart';
import 'package:flutter/material.dart';

class TinderCardDetailsContent extends StatelessWidget {
  final UserModel userModel;
  final TinderCardController tinderCardController;
  final UserController userController;
  final VoidCallback onReportTap;

  const TinderCardDetailsContent({
    super.key,
    required this.userModel,
    required this.tinderCardController,
    required this.userController,
    required this.onReportTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        UserHeaderInfo(
          userModel: userModel,
          tinderCardController: tinderCardController,
        ),
        const SizedBox(height: 20),
        UserBioSection(tinderCardController: tinderCardController),
        const SizedBox(height: 20),
        UserBasicInfoSection(tinderCardController: tinderCardController),
        const SizedBox(height: 30),
        UserHobbiesSection(userController: userController),
        const SizedBox(height: 20),
        TinderCardDetailsButton(userId: userModel.id ?? ""),
        const SizedBox(height: 20),
        ReportButton(onTap: onReportTap),
        const SizedBox(height: 10),
      ],
    );
  }
}