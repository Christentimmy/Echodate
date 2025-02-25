import 'package:echodate/app/resources/colors.dart';
import 'package:echodate/app/widget/custom_button.dart';
import 'package:echodate/app/widget/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ProfileDetailsScreen extends StatelessWidget {
  ProfileDetailsScreen({super.key});

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final Rxn<DateTime> _selectedTime = Rxn<DateTime>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Skip button
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
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
              ),

              const SizedBox(height: 20),

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
                    Container(
                      height: Get.height * 0.1,
                      width: Get.width * 0.2,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        image: const DecorationImage(
                          image: AssetImage("assets/images/pp.jpg"),
                          fit: BoxFit.cover,
                          alignment: Alignment.topCenter,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -5,
                      right: -5,
                      child: Container(
                        padding: const EdgeInsets.all(4),
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
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // First Name Field
              CustomTextField(
                controller: _firstNameController,
                hintText: "First Name",
              ),

              const SizedBox(height: 20),

              // Last Name Field
              CustomTextField(
                controller: _lastNameController,
                hintText: "Last Name",
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
                      Icon(Icons.calendar_today, color: AppColors.primaryColor),
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
                ontap: () {},
                child: const Text(
                  "Confirm",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
