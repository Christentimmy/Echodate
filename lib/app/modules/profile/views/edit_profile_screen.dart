import 'dart:io';
import 'package:echodate/app/controller/user_controller.dart';
import 'package:echodate/app/modules/Interest/views/pick_hobbies_screen.dart';
import 'package:echodate/app/modules/Interest/widgets/interest_widgets.dart';
import 'package:echodate/app/modules/profile/widgets/profile_widgets.dart';
import 'package:echodate/app/resources/colors.dart';
import 'package:echodate/app/utils/date_converter.dart';
import 'package:echodate/app/widget/custom_button.dart';
import 'package:echodate/app/widget/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _userController = Get.find<UserController>();
  final _nameController = TextEditingController();
  final _bioController = TextEditingController();
  RxString gender = ''.obs;

  File? profileImage;
  List<File?> images = List.filled(5, null);

  double screenWidth = Get.width;
  double screenHeight = Get.height;

  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    gender.value =
        _userController.userModel.value?.gender?.capitalizeFirst ?? 'Male';
    _nameController.text = _userController.userModel.value?.fullName ?? "";
    _bioController.text = _userController.userModel.value?.bio ?? "";
  }

  // Image picker function
  Future<void> pickImage(int index, {bool isProfile = false}) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File image = File(pickedFile.path);
      setState(() {
        if (isProfile) {
          profileImage = image;
        } else {
          images[index] = image;
        }
      });
      // Optionally: You can call the upload functions here if you want immediate upload.
      // For now, we handle upload in the saveProfile() function.
    }
  }

  // Remove image function
  void removeImage(int index, {bool isProfile = false}) {
    setState(() {
      if (isProfile) {
        profileImage = null;
      } else {
        images[index] = null;
      }
    });
  }

  Future<void> saveProfile() async {
    final currentUser = _userController.userModel.value;
    bool hasGeneralChanges = false;

    if (currentUser != null) {
      if (_nameController.text.trim() != currentUser.fullName?.trim() ||
          _bioController.text.trim() != currentUser.bio?.trim() ||
          gender.value != (currentUser.gender?.capitalizeFirst ?? 'Male')) {
        hasGeneralChanges = true;
      }
    } else {
      hasGeneralChanges = true;
    }

    isSaving = true;
    setState(() {});

    try {
      if (hasGeneralChanges) {
        await _userController.editProfile(
          fullName: _nameController.text,
          bio: _bioController.text,
          gender: gender.value,
        );
      }

      if (profileImage != null) {
        await _userController.updateProfilePicture(
          imageFile: profileImage!,
        );
      }

      List<File> photosToUpload =
          images.where((element) => element != null).cast<File>().toList();
      if (photosToUpload.isNotEmpty) {
        await _userController.uploadPhotos(
          photos: photosToUpload,
        );
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isSaving = false;
      setState(() {}); // Refresh UI when done
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Profile Pictures',
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10.0),
              // Photo section: Avatar and additional photos
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      // Display avatar/profile image from user model (or local file if new)
                      ProfileImage(
                        imageUrl: _userController.userModel.value?.avatar,
                        imageFile: profileImage,
                        isLarge: true,
                        index: "1",
                        onPickImage: () => pickImage(0, isProfile: true),
                        onRemove: () => removeImage(0, isProfile: true),
                      ),
                      SizedBox(width: screenWidth * 0.02),
                      Column(
                        children: [
                          // Display first two additional images safely
                          for (int i = 0; i < 2; i++)
                            Padding(
                              padding:
                                  EdgeInsets.only(bottom: screenHeight * 0.01),
                              child: ProfileImage(
                                imageUrl: (_userController.userModel.value
                                                ?.photos?.length ??
                                            0) >
                                        i
                                    ? _userController
                                        .userModel.value!.photos![i]
                                    : null,
                                imageFile: images.length > i ? images[i] : null,
                                index: "${i + 2}",
                                onPickImage: () => pickImage(i),
                                onRemove: () => removeImage(i),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                  // Display remaining three additional photos safely
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (index) {
                      int imgIndex = index + 2;
                      return Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.01),
                        child: ProfileImage(
                          imageUrl: (_userController
                                          .userModel.value?.photos?.length ??
                                      0) >
                                  imgIndex
                              ? _userController
                                  .userModel.value!.photos![imgIndex]
                              : null,
                          imageFile: images.length > imgIndex
                              ? images[imgIndex]
                              : null,
                          index: "${imgIndex + 1}",
                          onPickImage: () => pickImage(imgIndex),
                          onRemove: () => removeImage(imgIndex),
                        ),
                      );
                    }),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              const Text(
                'General Info',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10.0),
              CustomTextField(
                hintText: "Name",
                controller: _nameController,
              ),
              const SizedBox(height: 10.0),
              Obx(
                () => DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Gender',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.primaryColor,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.primaryColor,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  value: gender.value,
                  onChanged: (value) {
                    gender.value = value!;
                  },
                  items: ['Male', 'Female', 'Other'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 10.0),
              Obx(
                () => CustomTextField(
                  hintText: convertDateToNormal(
                    _userController.userModel.value?.dob ?? "",
                  ),
                  readOnly: true,
                ),
              ),
              const SizedBox(height: 10.0),
              CustomTextField(
                hintText: "Bio",
                controller: _bioController,
                maxLines: 3,
              ),
              SizedBox(height: Get.height * 0.04),
              // Interests section (left as is)
              Row(
                children: [
                  const Text(
                    'Interests',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      Get.to(
                        () => PickHobbiesScreen(
                          callback: () {
                            Navigator.pop(context);
                          },
                        ),
                      );
                    },
                    child: const Text(
                      "Edit",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              Obx(() {
                if (_userController.userModel.value == null) {
                  return const SizedBox.shrink();
                }
                return Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _userController.userModel.value!.hobbies!
                      .map((interest) => buildInterestCards(interest: interest))
                      .toList(),
                );
              }),
              const SizedBox(height: 20.0),
              CustomButton(
                ontap: isSaving
                    ? () {}
                    : () async {
                        await saveProfile();
                      },
                child: isSaving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text(
                        "Save",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
