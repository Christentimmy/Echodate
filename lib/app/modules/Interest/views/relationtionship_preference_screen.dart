import 'package:echodate/app/modules/Interest/views/pick_hobbies_screen.dart';
import 'package:echodate/app/modules/gender/widgets/gender_widget.dart';
import 'package:echodate/app/resources/colors.dart';
import 'package:echodate/app/widget/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RelationtionshipPreferenceScreen extends StatefulWidget {
  const RelationtionshipPreferenceScreen({super.key});

  @override
  State<RelationtionshipPreferenceScreen> createState() =>
      _RelationtionshipPreferenceScreenState();
}

class _RelationtionshipPreferenceScreenState
    extends State<RelationtionshipPreferenceScreen> {
  RxString selectedGender = "".obs;

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
                buildGenderOption("Long-Term", selectedGender),
                const SizedBox(height: 10),
                buildGenderOption("Marriage", selectedGender),
                const SizedBox(height: 10),
                buildGenderOption("Short-Term", selectedGender),
                const SizedBox(height: 10),
                buildGenderOption("Friends", selectedGender),
                const SizedBox(height: 10),
                buildGenderOption("Other", selectedGender),
                SizedBox(height: Get.height * 0.1),
                CustomButton(
                  ontap: () {
                    Get.to(() => const PickHobbiesScreen());
                  },
                  child: const Text(
                    "Continue",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
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
