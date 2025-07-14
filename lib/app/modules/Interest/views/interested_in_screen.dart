import 'package:echodate/app/controller/user_controller.dart';
import 'package:echodate/app/modules/gender/widgets/gender_widget.dart';
import 'package:echodate/app/widget/custom_button.dart';
import 'package:echodate/app/widget/loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InterestedInScreen extends StatefulWidget {
  final VoidCallback? callback;
  const InterestedInScreen({super.key, this.callback});

  @override
  State<InterestedInScreen> createState() => _InterestedInScreenState();
}

class _InterestedInScreenState extends State<InterestedInScreen> {
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
                    Icons.arrow_back,
                    color: Get.theme.primaryColor,
                  ),
                ),
              ),

              SizedBox(height: Get.height * 0.1),

              // Title
              Text(
                "I am interested in",
                style: Get.textTheme.headlineMedium,
              ),

              const SizedBox(height: 30),

              // Gender Selection Cards
              buildGenderOption("Female", selectedGender),
              const SizedBox(height: 10),
              buildGenderOption("Male", selectedGender),
              const SizedBox(height: 10),
              buildGenderOption(
                "Both",
                selectedGender,
                showCheck: false,
              ),
              const Spacer(),
              CustomButton(
                ontap: () async {
                  if (selectedGender.value.isEmpty) {
                    return;
                  }
                  await _userController.updateInterestedIn(
                    interestedIn: selectedGender.value.toLowerCase(),
                    callback: widget.callback,
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
