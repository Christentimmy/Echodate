import 'package:echodate/app/controller/user_controller.dart';
import 'package:echodate/app/modules/gender/widgets/gender_widget.dart';
import 'package:echodate/app/widget/custom_button.dart';
import 'package:echodate/app/widget/loader.dart';
import 'package:echodate/app/widget/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GenderSelectionScreen extends StatefulWidget {
  const GenderSelectionScreen({super.key});

  @override
  State<GenderSelectionScreen> createState() => _GenderSelectionScreenState();
}

class _GenderSelectionScreenState extends State<GenderSelectionScreen> {
  RxString selectedGender = "".obs;
  final _userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  Get.back();
                },
                child: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.transparent,
                    border: Border.all(
                      width: 1,
                      color: Colors.grey,
                    ),
                  ),
                  child: Icon(
                    Icons.arrow_back_ios,
                    size: 18,
                    color: Get.theme.primaryColor,
                  ),
                ),
              ),

              SizedBox(height: Get.height * 0.1),

              // Title
              Text(
                "I am a",
                style: Get.textTheme.headlineMedium,
              ),

              const SizedBox(height: 30),

              // Gender Selection Cards
              buildGenderOption("Female", selectedGender),
              const SizedBox(height: 10),
              buildGenderOption("Male", selectedGender),
              const SizedBox(height: 10),
              buildGenderOption(
                "Others",
                selectedGender,
                showCheck: false,
              ),
              const Spacer(),
              CustomButton(
                ontap: () async {
                  if (selectedGender.isEmpty) {
                    CustomSnackbar.showErrorSnackBar(
                      "Please select your gender",
                    );
                    return;
                  }
                  await _userController.updateGender(
                    gender: selectedGender.value.toLowerCase(),
                  );
                },
                child: Obx(
                  () => _userController.isloading.value
                      ? const Loader()
                      : const Text(
                          "Continue",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
