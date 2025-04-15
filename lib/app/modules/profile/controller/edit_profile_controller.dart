import 'dart:io';
import 'package:echodate/app/controller/user_controller.dart';
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
  RxString gender = ''.obs;

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
  }

  Future<void> selectImage(
    int index, {
    bool isProfile = false,
  }) async {
    print("Selected index: $index");
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
          print("Deleting index: $index");
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
      if (nameController.text.trim() != currentUser.fullName?.trim() ||
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
          gender: gender.value,
        );
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
}
