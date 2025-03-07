import 'dart:convert';

import 'package:echodate/app/controller/storage_controller.dart';
import 'package:echodate/app/models/transaction_model.dart';
import 'package:echodate/app/models/user_model.dart';
import 'package:echodate/app/modules/auth/views/otp_verify_screen.dart';
import 'package:echodate/app/modules/auth/views/signup_screen.dart';
import 'package:echodate/app/modules/bottom_navigation/views/bottom_navigation_screen.dart';
import 'package:echodate/app/modules/profile/views/profile_details_screen.dart';
import 'package:echodate/app/services/user_service.dart';
import 'package:echodate/app/utils/url_launcher.dart';
import 'package:echodate/app/widget/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  final UserService _userService = UserService();
  Rxn<UserModel> userModel = Rxn<UserModel>();
  RxList<TransactionModel> userTransactionHistory = <TransactionModel>[].obs;
  RxBool isloading = false.obs;
  RxBool isPaymentProcessing = false.obs;
  RxBool isPaymentHistoryFetched = false.obs;

  Future<void> getUserDetails() async {
    isloading.value = true;
    try {
      final storageController = Get.find<StorageController>();
      String? token = await storageController.getToken();
      if (token == null || token.isEmpty) return;

      final response = await _userService.getUserDetails(token: token);
      if (response == null) return;
      final decoded = json.decode(response.body);
      String message = decoded["message"];

      if (message == "Token has expired.") {
        Get.offAll(() => RegisterScreen());
        return;
      }

      if (response.statusCode != 200) {
        debugPrint(message);
        return;
      }

      var userData = decoded["data"];
      userModel.value = UserModel.fromJson(userData);
      userModel.refresh();
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isloading.value = false;
    }
  }

  Future<bool> getUserStatus() async {
    try {
      final storageController = Get.find<StorageController>();
      String? token = await storageController.getToken();
      if (token == null || token.isEmpty) return false;
      final response = await _userService.getUserStatus(token: token);
      if (response == null) {
        Get.offAll(() => RegisterScreen());
        return true;
      }
      final decoded = json.decode(response.body);
      String message = decoded["message"] ?? "";
      if (response.statusCode != 200) {
        Get.offAll(() => RegisterScreen());
        debugPrint(message);
        return true;
      }
      String status = decoded["data"]["status"];
      String email = decoded["data"]["email"];
      bool isEmailVerified = decoded["data"]["is_email_verified"] ?? false;
      bool isProfileCompleted = decoded["data"]["profile_completed"] ?? false;
      bool isPhoneNumberVerified =
          decoded["data"]["is_phone_number_verified"] ?? false;
      if (status == "banned" || status == "blocked") {
        CustomSnackbar.showErrorSnackBar("Your account has been banned.");
        Get.offAll(() => RegisterScreen());
        return true;
      }
      if (!isEmailVerified && !isPhoneNumberVerified) {
        CustomSnackbar.showErrorSnackBar("Your account email is not verified.");
        Get.offAll(() => OTPVerificationScreen(
            email: email,
            onVerifiedCallBack: () {
              Get.offAll(() => BottomNavigationScreen());
            }));
        return true;
      }
      if (!isProfileCompleted) {
        CustomSnackbar.showErrorSnackBar("Your profile is not completed.");
        Get.offAll(() => CompleteProfileScreen());
        return true;
      }
      return false;
    } catch (e) {
      debugPrint(e.toString());
    }
    return false;
  }

  Future<void> saveUserOneSignalId({
    required String oneSignalId,
  }) async {
    try {
      final storageController = Get.find<StorageController>();
      String? token = await storageController.getToken();
      if (token == null || token.isEmpty) return;
      final response = await _userService.saveUserOneSignalId(
        token: token,
        id: oneSignalId,
      );
      if (response == null) return;
      print(response.body);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> buyCoin({
    required String coinPackageId,
  }) async {
    isPaymentProcessing.value = true;
    try {
      final storageController = Get.find<StorageController>();
      String? token = await storageController.getToken();
      if (token == null || token.isEmpty) {
        CustomSnackbar.showErrorSnackBar("Authentication required");
        return;
      }
      final response = await _userService.initiateStripePayment(
        token: token,
        coinPackageId: coinPackageId,
      );

      if (response == null) return;
      final decoded = json.decode(response.body);
      if (response.statusCode != 200) {
        CustomSnackbar.showErrorSnackBar(decoded["message"]);
        return;
      }

      String? authorizationUrl = decoded["data"]["authorization_url"];
      if (authorizationUrl != null) {
        CustomSnackbar.showErrorSnackBar("Failed to initiate payment");
        urlLauncher(authorizationUrl);
        return;
      }
      await getUserPaymentHistory();
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isPaymentProcessing.value = false;
    }
  }

  Future<void> getUserPaymentHistory({
    String? type,
    int? limit = 10,
    String? status,
    String? startDate,
    String? endDate,
  }) async {
    if (isloading.value) return;
    isloading.value = true;
    try {
      final storageController = Get.find<StorageController>();
      String? token = await storageController.getToken();
      if (token == null || token.isEmpty) return;

      final response = await _userService.getUserPaymentHistory(
        token: token,
        type: type,
        limit: limit,
        startDate: startDate,
        endDate: endDate,
        status: status,
      );

      if (response == null) return;
      final decoded = json.decode(response.body);
      String message = decoded["message"];
      if (response.statusCode != 200) {
        debugPrint(message);
        return;
      }

      final payments = decoded["payments"] as List;
      // final totalPages = decoded["totalPages"];
      // final currentPage = decoded["page"];
      userTransactionHistory.addAll(
        payments.map((payment) => TransactionModel.fromJson(payment)).toList(),
      );
      if (response.statusCode == 200) isPaymentHistoryFetched.value = true;
    } catch (e) {
      debugPrint("❌ Error fetching payments: $e");
    } finally {
      isloading.value = false;
    }
  }

  void clearUserData() {
    userModel.value = null;
  }
}
