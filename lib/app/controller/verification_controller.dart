import 'dart:convert';
import 'dart:io';
import 'package:echodate/app/controller/storage_controller.dart';
import 'package:echodate/app/modules/bottom_navigation/views/bottom_navigation_screen.dart';
import 'package:echodate/app/services/verification_service.dart';
import 'package:echodate/app/widget/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VerificationController extends GetxController {
  RxBool isloading = false.obs;
  final _verificationService = VerificationService();

  Future<void> uploadVerificationFiles({
    required File idFront,
    required File idBack,
    required File selfie,
  }) async {
    isloading.value = true;
    try {
      final storageController = Get.find<StorageController>();
      String? token = await storageController.getToken();
      if (token == null) return;

      final response = await _verificationService.uploadVerificationFiles(
        token: token,
        idFront: idFront,
        idBack: idBack,
        selfie: selfie,
      );

      if (response == null) return;
      final decoded = json.decode(response.body);
      final message = decoded["message"] ?? "";
      if (response.statusCode != 200) {
        CustomSnackbar.showErrorSnackBar(message);
        return;
      }
      Get.offAll(() => BottomNavigationScreen());
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isloading.value = false;
    }
  }
}
