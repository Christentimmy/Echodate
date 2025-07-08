import 'package:echodate/app/controller/user_controller.dart';
import 'package:echodate/app/models/user_model.dart';
import 'package:echodate/app/modules/home/controller/tinder_card_controller.dart';
import 'package:echodate/app/modules/home/widgets/home_widgets.dart';
import 'package:echodate/app/modules/home/widgets/report_bottom_sheet.dart';
import 'package:echodate/app/modules/home/widgets/tinder_photo_gallery.dart';
import 'package:echodate/app/modules/home/widgets/user_basic_info_section.dart';
import 'package:echodate/app/modules/home/widgets/user_bio_section.dart';
import 'package:echodate/app/modules/home/widgets/user_header_info.dart';
import 'package:echodate/app/modules/home/widgets/user_hobbies_section.dart';
import 'package:echodate/app/resources/colors.dart';
import 'package:echodate/app/widget/animations.dart';
import 'package:echodate/app/widget/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TinderCardDetails extends StatefulWidget {
  final UserModel userModel;

  const TinderCardDetails({
    super.key,
    required this.userModel,
  });

  @override
  State<TinderCardDetails> createState() => _TinderCardDetailsState();
}

class _TinderCardDetailsState extends State<TinderCardDetails> {
  final _userController = Get.find<UserController>();
  final _tinderCardController = Get.put(TinderCardController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _tinderCardController.getUserDetails(id: widget.userModel.id ?? "");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Obx(
            () => Opacity(
              opacity: _userController.isloading.value ? 0.4 : 1,
              child: SingleChildScrollView(
                child: AnimatedListWrapper(
                  children: [
                    TinderPhotoGallery(fallbackUser: widget.userModel),
                    _buildMatchPercentage(),
                    const SizedBox(height: 10),
                    _buildTinderContent()
                  ],
                ),
              ),
            ),
          ),
          _buildOverlay(),
        ],
      ),
    );
  }

  void _showReportBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return const ReportBottomSheet();
      },
    );
  }

  Widget _buildTinderContent() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UserHeaderInfo(
            userModel: widget.userModel,
            tinderCardController: _tinderCardController,
          ),
          const SizedBox(height: 20),
          UserBioSection(tinderCardController: _tinderCardController),
          const SizedBox(height: 20),
          UserBasicInfoSection(tinderCardController: _tinderCardController),
          const SizedBox(height: 30),
          UserHobbiesSection(userController: _userController),
          const SizedBox(height: 20),
          TinderCardDetailsButton(userId: widget.userModel.id ?? ""),
          const SizedBox(height: 20),
          // ReportButton(onTap: () => _showReportBottomSheet(context)),
          CustomButton(
            bgColor: Colors.red,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.flag,
                  color: Colors.white,
                ),
                Text(
                  "Report",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            ontap: () {
              _showReportBottomSheet(context);
            },
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildOverlay() {
    return Obx(() {
      if (_userController.isloading.value) {
        return SizedBox(
          height: Get.height,
          width: Get.width,
          child: Center(
            child: CircularProgressIndicator(
              color: AppColors.primaryColor,
            ),
          ),
        );
      } else {
        return const SizedBox.shrink();
      }
    });
  }

  Widget _buildMatchPercentage() {
    int? percentage = widget.userModel.matchPercentage;
    if (percentage == null || percentage == 0) {
      return const SizedBox.shrink();
    }

    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 25,
          vertical: 5,
        ),
        decoration: const BoxDecoration(
          color: Colors.orange,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        child: Text(
          "$percentage% match",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
