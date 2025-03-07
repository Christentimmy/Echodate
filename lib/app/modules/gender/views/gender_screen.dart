import 'package:echodate/app/controller/user_controller.dart';
import 'package:echodate/app/modules/gender/widgets/gender_widget.dart';
import 'package:echodate/app/resources/colors.dart';
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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {},
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
                      child: const Icon(Icons.arrow_back, color: Colors.black),
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      "Skip",
                      style: TextStyle(
                        color: AppColors.primaryColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: Get.height * 0.1),

              // Title
              const Text(
                "I am a",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
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
