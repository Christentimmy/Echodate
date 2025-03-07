import 'dart:io';
import 'package:echodate/app/modules/gender/views/gender_screen.dart';
import 'package:echodate/app/resources/colors.dart';
import 'package:echodate/app/utils/image_picker.dart';
import 'package:echodate/app/widget/custom_button.dart';
import 'package:echodate/app/widget/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CompleteProfileScreen extends StatelessWidget {
  CompleteProfileScreen({super.key});

  final _fullNameController = TextEditingController();
  final _bioController = TextEditingController();
  final Rxn<DateTime> _selectedTime = Rxn<DateTime>();
  final Rxn<File> _selectedPicture = Rxn<File>();

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
                                  : const AssetImage("assets/images/pp.jpg"),
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

                // First Name Field
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

                const SizedBox(height: 20),

                // Birthday Date Picker
                InkWell(
                  onTap: () async {
                    DateTime? timePicked = await showDatePicker(
                      context: context,
                      firstDate: DateTime(1800),
                      lastDate: DateTime.now(),
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
                        Icon(Icons.calendar_today,
                            color: AppColors.primaryColor),
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
                  ontap: () {
                    Get.to(() => const GenderSelectionScreen());
                  },
                  child: const Text(
                    "Confirm",
                    style: TextStyle(fontSize: 16, color: Colors.white),
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
