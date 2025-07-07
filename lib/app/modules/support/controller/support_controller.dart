import 'dart:io';
import 'package:echodate/app/controller/user_controller.dart';
import 'package:echodate/app/utils/image_picker.dart';
import 'package:echodate/app/widget/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SupportController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final subjectController = TextEditingController();
  final messageController = TextEditingController();
  final userController = Get.find<UserController>();

  RxString selectedCategory = "".obs;
  final RxList<String> categories =
      ['booking', 'payment', 'technical', 'other'].obs;
  RxList<File> attachments = <File>[].obs;

  Future<void> sendMessage() async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    if (selectedCategory.isEmpty) {
      CustomSnackbar.showErrorSnackBar(
        "Please select a category for your message.",
      );
      return;
    }
    // await userController.createTicket(
    //   description: messageController.text,
    //   subject: subjectController.text,
    //   category: selectedCategory.value,
    //   attachments: attachments,
    // );
    subjectController.clear();
    messageController.clear();
    selectedCategory.value = "";
    attachments.clear();
  }

  Future<void> addAttachment() async {
    final files = await pickFile();
    if (files == null || files.isEmpty) {
      CustomSnackbar.showErrorSnackBar("No files selected.");
      return;
    }
    if (files.length > 5) {
      CustomSnackbar.showErrorSnackBar("You can only attach up to 5 files.");
      return;
    }
    attachments.addAll(files);
    attachments.refresh();
  }
}
