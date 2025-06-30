import 'dart:io';
import 'package:echodate/app/controller/auth_controller.dart';
import 'package:echodate/app/controller/timer_controller.dart';
import 'package:echodate/app/controller/user_controller.dart';
import 'package:echodate/app/modules/profile/widgets/edit_profile_widgets.dart';
import 'package:echodate/app/utils/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditProfileController extends GetxController {
  var deletedIndex = (-1).obs;
  var profileImage = Rx<File?>(null);
  RxList<File?> images = RxList<File?>.filled(5, null);

  final _userController = Get.find<UserController>();
  RxBool isSaving = false.obs;
  final nameController = TextEditingController();
  final bioController = TextEditingController();
  final emailController = TextEditingController();
  final phoneNumberController = TextEditingController();
  RxString gender = ''.obs;

  final TextEditingController pinController = TextEditingController();
  final _authController = Get.find<AuthController>();
  final FocusNode pinFocusNode = FocusNode();
  RxBool isSubmitting = false.obs;
  RxBool isEmailEditDisAllowed = true.obs;
  RxBool isPhoneNumberEditDisAllowed = true.obs;

  @override
  void onInit() {
    init();
    super.onInit();
  }

  void init() {
    gender.value =
        _userController.userModel.value?.gender?.capitalizeFirst ?? 'Male';
    nameController.text = _userController.userModel.value?.fullName ?? "";
    bioController.text = _userController.userModel.value?.bio ?? "";
    emailController.text = _userController.userModel.value?.email ?? "";
    phoneNumberController.text =
        _userController.userModel.value?.phoneNumber ?? "";
  }

  Future<void> selectImage(
    int index, {
    bool isProfile = false,
  }) async {
    File? pickedFile = await pickImage();
    if (pickedFile == null) return;
    if (isProfile) {
      profileImage.value = pickedFile;
    } else {
      images[index] = pickedFile;
    }
  }

  void removeImage(int index, {bool isProfile = false}) async {
    if (isProfile) {
      profileImage.value = null;
    } else {
      if (index < images.length) {
        if (images[index] == null) {
          deletedIndex.value = index;
          await _userController.deletePhoto(index);
          deletedIndex.value = (-1);
        } else {
          images[index] = null;
        }
      }
    }
  }

  Future<void> saveProfile() async {
    final currentUser = _userController.userModel.value;
    bool hasGeneralChanges = false;

    if (currentUser != null) {
      if (phoneNumberController.text.trim() !=
              currentUser.phoneNumber?.trim() ||
          emailController.text.trim() != currentUser.email?.trim() ||
          nameController.text.trim() != currentUser.fullName?.trim() ||
          bioController.text.trim() != currentUser.bio?.trim() ||
          gender.value != (currentUser.gender?.capitalizeFirst ?? 'Male')) {
        hasGeneralChanges = true;
      }
    } else {
      hasGeneralChanges = true;
    }

    isSaving.value = true;

    try {
      if (hasGeneralChanges) {
        await _userController.editProfile(
          fullName: nameController.text,
          bio: bioController.text,
          gender: gender.value.toLowerCase(),
          email: emailController.text,
          phoneNumber: phoneNumberController.text,
        );
        isEmailEditDisAllowed.value = true;
        isPhoneNumberEditDisAllowed.value = true;
      }

      if (profileImage.value != null) {
        await _userController.updateProfilePicture(
          imageFile: profileImage.value!,
        );
      }

      for (int i = 0; i < images.length; i++) {
        if (images[i] != null) {
          await _userController.uploadPhotos(
            photos: [images[i]!],
            index: i,
          );
          images[i] = null;
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isSaving.value = false;
    }
  }

  void submitOtp({
    required Function(String) onOtpSubmitted,
  }) {
    if (pinController.text.length != 4) return;
    isSubmitting.value = true;
    onOtpSubmitted(pinController.text);
  }

  void handleResendOtp({
    required TimerController controller,
    required VoidCallback onResendOtp,
  }) {
    controller.startTimer();
    onResendOtp();
  }

  String getMaskedContact(
    bool isEmail,
    String contactValue,
  ) {
    if (isEmail) {
      final parts = contactValue.split('@');
      if (parts.length == 2) {
        String name = parts[0];
        String domain = parts[1];
        if (name.length > 3) {
          return '${name.substring(0, 3)}***@$domain';
        } else {
          return '$name***@$domain';
        }
      }
      return contactValue;
    } else {
      if (contactValue.length > 4) {
        return '***${contactValue.substring(contactValue.length - 4)}';
      }
      return contactValue;
    }
  }

  void showEmailEditBottomSheet(BuildContext context) async {
    OtpVerificationBottomSheet.show(
      context: context,
      contactType: 'email',
      contactValue: _userController.userModel.value?.email ?? "",
      onOtpSubmitted: (otp) async {
        await _authController.verifyOtp(
            otpCode: otp,
            whatNext: () {
              isSubmitting.value = false;
              isEmailEditDisAllowed.value = false;
            });
        pinController.clear();
        isSubmitting.value = false;
        Navigator.of(Get.context!).pop();
      },
      onResendOtp: () async {
        await _authController.sendOtp();
      },
    );
    await _authController.sendOtp();
  }

  void showPhoneNumberEditBottomSheet(BuildContext context) async {
    OtpVerificationBottomSheet.show(
      context: context,
      contactType: 'phone',
      contactValue: _userController.userModel.value?.phoneNumber ?? "",
      onOtpSubmitted: (otp) async {
        await _authController.verifyOtp(
            otpCode: otp,
            whatNext: () {
              isSubmitting.value = false;
              isPhoneNumberEditDisAllowed.value = false;
            });
        pinController.clear();
        isSubmitting.value = false;
        Navigator.of(Get.context!).pop();
      },
      onResendOtp: () async {
        await _authController.sendNumberOTP();
      },
    );
    await _authController.sendNumberOTP();
  }
}
