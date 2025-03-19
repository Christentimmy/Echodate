import 'dart:io';
import 'package:echodate/app/controller/auth_controller.dart';
import 'package:echodate/app/models/user_model.dart';
import 'package:echodate/app/resources/colors.dart';
import 'package:echodate/app/utils/image_picker.dart';
import 'package:echodate/app/widget/custom_button.dart';
import 'package:echodate/app/widget/custom_textfield.dart';
import 'package:echodate/app/widget/loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CompleteProfileScreen extends StatelessWidget {
  final VoidCallback? nextScreen;
  CompleteProfileScreen({super.key, this.nextScreen});

  final _fullNameController = TextEditingController();
  final _bioController = TextEditingController();
  final Rxn<DateTime> _selectedTime = Rxn<DateTime>();
  final Rxn<File> _selectedPicture = Rxn<File>();
  final _authController = Get.find<AuthController>();
  final _formKey = GlobalKey<FormState>();

  void selectImage() async {
    File? image = await pickImage();
    if (image != null) {
      _selectedPicture.value = image;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Skip button

                SizedBox(height: Get.height * 0.1),

                // Title
                const Text(
                  "Profile details",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 30),

                // Profile Image
                Center(
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Obx(
                        () => Container(
                          height: Get.height * 0.15,
                          width: Get.width * 0.3,
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 2,
                              color: AppColors.primaryColor,
                            ),
                            borderRadius: BorderRadius.circular(15),
                            image: DecorationImage(
                              image: _selectedPicture.value != null
                                  ? FileImage(_selectedPicture.value!)
                                  : const AssetImage(
                                      "assets/images/placeholder1.png"),
                              fit: BoxFit.cover,
                              alignment: Alignment.topCenter,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: -5,
                        right: -5,
                        child: InkWell(
                          onTap: () {
                            selectImage();
                          },
                          child: Container(
                            padding: const EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 2,
                                color: Colors.white,
                              ),
                              color: AppColors.primaryColor,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CustomTextField(
                        controller: _fullNameController,
                        hintText: "Full Name",
                      ),

                      const SizedBox(height: 20),

                      // Last Name Field
                      CustomTextField(
                        controller: _bioController,
                        hintText: "Bio",
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),

                // First Name Field

                const SizedBox(height: 20),

                // Birthday Date Picker
                InkWell(
                  onTap: () async {
                    DateTime now = DateTime.now();
                    DateTime adultAge =
                        DateTime(now.year - 18, now.month, now.day);

                    DateTime? timePicked = await showDatePicker(
                      context: context,
                      firstDate: DateTime(1800),
                      lastDate:
                          adultAge, // Prevents selecting dates under 18 years
                    );

                    if (timePicked != null) {
                      _selectedTime.value = timePicked;
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 20,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.primaryColor),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          color: AppColors.primaryColor,
                        ),
                        const SizedBox(width: 10),
                        Obx(
                          () => Text(
                            _selectedTime.value != null
                                ? DateFormat("MMM dd yyyy")
                                    .format(_selectedTime.value!)
                                : "Choose birthday date",
                            style: TextStyle(color: AppColors.primaryColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // Confirm Button
                CustomButton(
                  ontap: () async {
                    FocusManager.instance.primaryFocus?.unfocus();
                    if (!_formKey.currentState!.validate()) {
                      return;
                    }
                    final UserModel userModel = UserModel(
                      fullName: _fullNameController.text,
                      bio: _bioController.text,
                      dob: _selectedTime.value.toString(),
                    );
                    await _authController.completeProfileScreen(
                      userModel: userModel,
                      imageFile: _selectedPicture.value!,
                      nextScreen: nextScreen,
                    );
                  },
                  child: Obx(
                    () => _authController.isLoading.value
                        ? const Loader()
                        : const Text(
                            "Confirm",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
