import 'package:echodate/app/modules/settings/controller/badge_controller.dart';
import 'package:echodate/app/modules/settings/widgets/verification_badge_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VerificationFlow extends StatefulWidget {
  const VerificationFlow({super.key});

  @override
  State<VerificationFlow> createState() => _VerificationFlowState();
}

class _VerificationFlowState extends State<VerificationFlow> {
  final _badgeController = Get.put(BadgeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Obx(() => _buildCurrentStep()),
        ),
      ),
    );
  }

  Widget _buildCurrentStep() {
    final currentStep = _badgeController.currentStep.value;
    switch (currentStep) {
      case 0:
        return BuildIdSelectionStep();
      case 1:
        return BuildFrontIdUploadStep();
      case 2:
        return BuildBackIdUploadStep();
      case 3:
        return BuildSelfieStep();
      case 4:
        return BuildReviewStep();
      default:
        return BuildIdSelectionStep();
    }
  }
}
