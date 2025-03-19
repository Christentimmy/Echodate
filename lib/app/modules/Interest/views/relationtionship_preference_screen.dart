import 'package:echodate/app/controller/user_controller.dart';
import 'package:echodate/app/modules/gender/widgets/gender_widget.dart';
import 'package:echodate/app/resources/colors.dart';
import 'package:echodate/app/widget/custom_button.dart';
import 'package:echodate/app/widget/loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RelationtionshipPreferenceScreen extends StatefulWidget {
  final VoidCallback? callback;
  const RelationtionshipPreferenceScreen({
    super.key,
    this.callback,
  });

  @override
  State<RelationtionshipPreferenceScreen> createState() =>
      _RelationtionshipPreferenceScreenState();
}

class _RelationtionshipPreferenceScreenState
    extends State<RelationtionshipPreferenceScreen> {
  @override
  void initState() {
    super.initState();
    selectedPreference.value =
        _userController.userModel.value?.relationshipPreference ?? "";
  }

  RxString selectedPreference = "".obs;
  final _userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
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
                      onTap: () => Get.back(),
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
                        child:
                            const Icon(Icons.arrow_back, color: Colors.black),
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
                  "Relationship Preference",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 30),

                // Gender Selection Cards
                buildGenderOption("Long-Term", selectedPreference),
                const SizedBox(height: 10),
                buildGenderOption("Marriage", selectedPreference),
                const SizedBox(height: 10),
                buildGenderOption("Short-Term", selectedPreference),
                const SizedBox(height: 10),
                buildGenderOption("Friends", selectedPreference),
                const SizedBox(height: 10),
                buildGenderOption("Other", selectedPreference),
                SizedBox(height: Get.height * 0.1),
                CustomButton(
                  ontap: () async {
                    if (selectedPreference.isEmpty) {
                      return;
                    }
                    await _userController.updateRelationshipPreference(
                      relationshipPreference: selectedPreference.value,
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
      ),
    );
  }
}
