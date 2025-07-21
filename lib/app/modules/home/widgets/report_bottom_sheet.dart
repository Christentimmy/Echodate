import 'package:echodate/app/controller/user_controller.dart';
import 'package:echodate/app/resources/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReportType {
  static const profile = ReportType._('profile');
  static const story = ReportType._('story');
  static const message = ReportType._('message');
  static const other = ReportType._('other');

  final String value;

  const ReportType._(this.value);

  @override
  String toString() => value;
}



class ReportBottomSheet extends StatefulWidget {
  final String reporteeId;
  final ReportType type;
  const ReportBottomSheet({
    super.key,
    required this.reporteeId,
    required this.type,
  });

  @override
  State<ReportBottomSheet> createState() => _ReportBottomSheetState();
}

class _ReportBottomSheetState extends State<ReportBottomSheet> {
  final _userController = Get.find<UserController>();

  final List<String> _reportReasons = [
    "No reason",
    "I'm not interested in this person",
    "Profile isDisliking fake, spam, or scammer",
    "Inappropriate content",
    "Underage or minor",
    "Off-Hinge behavior",
    "Someone is in danger",
    "Other"
  ];

  void _reportUser(String reason) async {
    await _userController.reportUser(
      type: widget.type.value,
      reason: reason,
      reporteeId: widget.reporteeId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Obx(
        () => _userController.isloading.value
            ? Center(
                child: CircularProgressIndicator(
                  color: AppColors.primaryColor,
                ),
              )
            : ListView.builder(
                itemCount: _reportReasons.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      _reportReasons[index],
                      style: Get.textTheme.labelMedium,
                    ),
                    onTap: () => _reportUser(_reportReasons[index]),
                    contentPadding: EdgeInsets.zero,
                  );
                },
              ),
      ),
    );
  }
}
