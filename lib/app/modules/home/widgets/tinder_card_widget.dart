import 'package:echodate/app/controller/user_controller.dart';
import 'package:echodate/app/models/user_model.dart';
import 'package:echodate/app/modules/home/controller/tinder_card_controller.dart';
import 'package:echodate/app/modules/home/widgets/home_widgets.dart';
import 'package:echodate/app/modules/home/widgets/loading_overlay.dart';
import 'package:echodate/app/modules/home/widgets/match_percentage_banner.dart';
import 'package:echodate/app/modules/home/widgets/tinder_card_details_content.dart';
import 'package:echodate/app/modules/home/widgets/tinder_photo_gallery.dart';
import 'package:echodate/app/widget/animations.dart';
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
                    MatchPercentageWidget(percentage: widget.userModel.matchPercentage),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: TinderCardDetailsContent(
                        userModel: widget.userModel,
                        tinderCardController: _tinderCardController,
                        userController: _userController,
                        onReportTap: () => _showReportBottomSheet(context),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          LoadingOverlay(isLoading: _userController.isloading),
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
}