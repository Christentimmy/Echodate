import 'dart:convert';
import 'dart:io';
import 'package:echodate/app/controller/message_controller.dart';
import 'package:echodate/app/controller/socket_controller.dart';
import 'package:echodate/app/controller/storage_controller.dart';
import 'package:echodate/app/controller/story_controller.dart';
import 'package:echodate/app/controller/user_controller.dart';
import 'package:echodate/app/models/user_model.dart';
import 'package:echodate/app/modules/auth/views/create_new_password.dart';
import 'package:echodate/app/modules/auth/views/otp_verify_screen.dart';
import 'package:echodate/app/modules/auth/views/signup_screen.dart';
import 'package:echodate/app/modules/auth/views/verification_status_screen.dart';
import 'package:echodate/app/modules/bottom_navigation/views/bottom_navigation_screen.dart';
import 'package:echodate/app/modules/gender/views/gender_screen.dart';
import 'package:echodate/app/modules/profile/views/complete_profile_screen.dart';
import 'package:echodate/app/services/auth_service.dart';
import 'package:echodate/app/widget/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxBool isOtpVerifyLoading = false.obs;
  final RxBool isSignUpOtpLoading = false.obs;
  final AuthService _authService = AuthService();
  final _storageController = Get.find<StorageController>();

  Future<void> signUpUSer({
    required UserModel userModel,
  }) async {
    isLoading.value = true;
    try {
      final response = await _authService.signUpUser(userModel: userModel);
      if (response == null) return;
      final decoded = json.decode(response.body);
      var message = decoded["message"] ?? "";
      if (response.statusCode != 201) {
        CustomSnackbar.showErrorSnackBar(message);
        return;
      }
      final userController = Get.find<UserController>();
      String token = decoded["token"];
      await _storageController.storeToken(token);
      final socketController = Get.find<SocketController>();
      socketController.initializeSocket();
      await userController.getUserDetails();
      Get.to(() => CompleteProfileScreen());
    } catch (e) {
      debugPrint("Error From Auth Controller: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sendOtp() async {
    isLoading.value = true;
    try {
      final storageController = Get.find<StorageController>();
      String? token = await storageController.getToken();
      if (token == null) return;
      final response = await _authService.sendOtp(token: token);
      if (response == null) return;
      final decoded = json.decode(response.body);
      if (response.statusCode != 200) {
        CustomSnackbar.showErrorSnackBar(
          "Failed to get OTP, ${decoded["message"]}",
        );
        return;
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sendSignUpOtp({
    required String email,
  }) async {
    isSignUpOtpLoading.value = true;
    try {
      final response = await _authService.sendSignUpOtp(email: email);
      if (response == null) return;
      final decoded = json.decode(response.body);
      if (response.statusCode != 200) {
        CustomSnackbar.showErrorSnackBar(decoded["message"].toString());
        return;
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isSignUpOtpLoading.value = false;
    }
  }

  Future<void> changeAuthDetails({
    String? email,
    String? phoneNumber,
  }) async {
    isLoading.value = true;
    try {
      final storageController = Get.find<StorageController>();
      String? token = await storageController.getToken();
      if (token == null) return;
      final response = await _authService.changeAuthDetails(
        token: token,
        email: email,
        phoneNumber: phoneNumber,
      );
      if (response == null) return;
      final decoded = json.decode(response.body);
      if (response.statusCode != 200) {
        CustomSnackbar.showErrorSnackBar(
          decoded["message"].toString(),
        );
        return;
      }

      final usercontroller = Get.find<UserController>();
      await usercontroller.getUserDetails();
      CustomSnackbar.showSuccessSnackBar(
        decoded["message"].toString(),
      );
      Navigator.pop(Get.context!);
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sendNumberOTP({
    String? phoneNumber,
    VoidCallback? callback,
  }) async {
    isLoading.value = true;
    try {
      final storageController = Get.find<StorageController>();
      String? token = await storageController.getToken();
      if (token == null) return;
      final response = await _authService.sendNumberOTP(
        token: token,
        phoneNumber: phoneNumber,
      );
      if (response == null) return;
      final decoded = json.decode(response.body);
      if (response.statusCode != 200) {
        CustomSnackbar.showErrorSnackBar(decoded["message"].toString());
        return;
      }
      if (callback != null) {
        callback();
        return;
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> verifyOtp({
    required String otpCode,
    String? email,
    String? phoneNumber,
    VoidCallback? whatNext,
  }) async {
    isOtpVerifyLoading.value = true;
    try {
      final storageController = Get.find<StorageController>();
      String? token = await storageController.getToken();
      if (token == null || token.isEmpty) return;
      final response = await _authService.verifyOtp(
        otpCode: otpCode,
        email: email,
        phoneNumber: phoneNumber,
        token: token,
      );
      if (response == null) return;
      final decoded = json.decode(response.body);
      String message = decoded["message"] ?? "";
      if (response.statusCode != 200) {
        CustomSnackbar.showErrorSnackBar(message);
        return;
      }

      if (whatNext != null) {
        whatNext();
        return;
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isOtpVerifyLoading.value = false;
    }
  }

  Future<void> completeProfileScreen({
    required UserModel userModel,
    required File imageFile,
    Function()? nextScreen,
  }) async {
    isLoading.value = true;
    try {
      final storageController = Get.find<StorageController>();
      final String? token = await storageController.getToken();
      if (token == null) return;
      final response = await _authService.completeProfile(
        userModel: userModel,
        token: token,
        imageFile: imageFile,
      );
      if (response == null) return;
      final responseBody = await response.stream.bytesToString();
      final decoded = json.decode(responseBody);
      String message = decoded["message"] ?? "";
      if (response.statusCode != 200) {
        CustomSnackbar.showErrorSnackBar(message);
        return;
      }
      final userController = Get.find<UserController>();
      await userController.getUserDetails();
      if (nextScreen != null) {
        await nextScreen();
        return;
      }
      Get.offAll(() => const GenderSelectionScreen());
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loginUser({
    required String identifier,
    required String password,
  }) async {
    isLoading.value = true;
    try {
      final response = await _authService.loginUser(
        identifier: identifier,
        password: password,
      );
      if (response == null) return;
      final decoded = json.decode(response.body);
      String message = decoded["message"] ?? "";
      String token = decoded["token"] ?? "";
      print("Token:$token");
      final storageController = Get.find<StorageController>();
      await storageController.storeToken(token);
      if (response.statusCode == 404) {
        CustomSnackbar.showErrorSnackBar(message);
        return;
      }
      if (response.statusCode == 402) {
        CustomSnackbar.showErrorSnackBar(message);
        Get.offAll(() => RegisterScreen());
        return;
      }
      final socketController = Get.find<SocketController>();
      await socketController.initializeSocket();
      if (response.statusCode == 401) {
        CustomSnackbar.showErrorSnackBar(message);
        Get.offAll(
          () => VerificationStatusScreen(
            callback: () => Get.offAll(
              () => BottomNavigationScreen(),
            ),
          ),
        );
        return;
      }
      if (response.statusCode == 400) {
        CustomSnackbar.showErrorSnackBar(message);
        Get.offAll(() => CompleteProfileScreen());
        return;
      }
      if (response.statusCode != 200) {
        CustomSnackbar.showErrorSnackBar(message);
        return;
      }
      final userController = Get.find<UserController>();
      final storyController = Get.find<StoryController>();
      await userController.getUserDetails();
      await userController.getPotentialMatches();
      await storyController.getAllStories();
      await storyController.getUserPostedStories();
      Get.offAll(() => BottomNavigationScreen());
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      final storageController = Get.find<StorageController>();
      String? token = await storageController.getToken();
      if (token == null || token.isEmpty) return;
      final response = await _authService.changePassword(
        oldPassword: oldPassword,
        newPassword: newPassword,
        token: token,
      );
      if (response == null) return;
      final data = json.decode(response.body);
      String message = data["message"];
      if (response.statusCode != 200) {
        CustomSnackbar.showErrorSnackBar(message);
        return;
      }
      CustomSnackbar.showSuccessSnackBar(message);
      Get.offAll(() => RegisterScreen());
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> logout() async {
    isLoading.value = true;
    try {
      String? token = await StorageController().getToken();
      if (token == null) {
        CustomSnackbar.showErrorSnackBar("No user session found.");
        return;
      }

      final response = await _authService.logout(token: token);
      if (response == null) return;
      final data = jsonDecode(response.body);
      if (response.statusCode != 200) {
        debugPrint(data["message"].toString());
        return;
      }
      final userController = Get.find<UserController>();
      final storyController = Get.find<StoryController>();
      final storage = Get.find<StorageController>();
      final messageController = Get.find<MessageController>();
      final socketController = Get.find<SocketController>();
      socketController.disconnectSocket();
      messageController.clearChatHistory();
      await storage.deleteToken();
      userController.clearUserData();
      storyController.clearUserData();
      Get.offAll(() => RegisterScreen());
    } catch (error) {
      debugPrint(error.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteAccount() async {
    isLoading.value = true;
    try {
      String? token = await StorageController().getToken();
      if (token == null) {
        CustomSnackbar.showErrorSnackBar("No user session found.");
        return;
      }

      final response = await _authService.deleteAccount(token: token);
      if (response == null) return;
      final data = jsonDecode(response.body);
      if (response.statusCode != 200) {
        debugPrint(data["message"].toString());
        return;
      }
      final userController = Get.find<UserController>();
      final storage = Get.find<StorageController>();
      await storage.deleteToken();
      userController.clearUserData();
      Get.offAll(() => RegisterScreen());
    } catch (error) {
      debugPrint(error.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sendOtpForgotPassword({
    required String email,
  }) async {
    isLoading.value = true;
    try {
      final response = await _authService.sendOtpForgotPassword(
        email: email,
      );
      if (response == null) return;
      final data = jsonDecode(response.body);
      final StorageController storageController = Get.find<StorageController>();
      String token = data["token"] ?? "";
      // String message = data["message"] ?? "";
      await storageController.storeToken(token);
      // if (response.statusCode != 200) {
      //   debugPrint(data["message"].toString());
      //   CustomSnackbar.showErrorSnackBar(message);
      //   return;
      // }
      CustomSnackbar.showSuccessSnackBar(
          "Please check your inbox. If the email is linked to an account, an OTP has been sent.");
      Get.to(
        () => OTPVerificationScreen(
          email: email,
          onVerifiedCallBack: () {
            Get.to(
              () => CreateNewPasswordScreen(
                email: email,
              ),
            );
          },
        ),
      );
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<String?> forgotPassword({
    required String email,
    required String password,
  }) async {
    isLoading.value = true;
    try {
      final response = await _authService.forgotPassword(
        email: email,
        password: password,
      );
      if (response == null) return null;
      final data = jsonDecode(response.body);
      if (response.statusCode != 200) {
        debugPrint(data["message"].toString());
        return null;
      }
      return data["message"].toString();
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isLoading.value = false;
    }
    return null;
  }

  Future<void> verifyFace(
    VoidCallback? callback,
  ) async {
    isLoading.value = true;
    try {
      final storageController = Get.find<StorageController>();
      final String? token = await storageController.getToken();
      if (token == null) return;

      final response = await _authService.verifyFace(token: token);
      if (response == null) return;
      final data = jsonDecode(response.body);
      if (response.statusCode != 200) {
        debugPrint(data["message"].toString());
        return;
      }
      if (callback != null) {
        debugPrint("statement");
        callback();
        return;
      }
      Get.offAll(() => BottomNavigationScreen());
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
