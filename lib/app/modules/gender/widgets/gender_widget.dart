import 'package:echodate/app/resources/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget buildGenderOption(String gender, RxString selectedGender,
    {bool showCheck = true}) {
  return Obx(() {
    bool isSelected = selectedGender.value == gender;
    final isDark = Get.isDarkMode;

    return GestureDetector(
      onTap: () {
        selectedGender.value = gender;
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 20,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryColor
              : (isDark ? Colors.grey[900] : Colors.white),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryColor
                : (isDark ? Colors.grey[700]! : Colors.grey.shade300),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              gender,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: isSelected
                    ? Colors.white
                    : (isDark ? Colors.white : Colors.black),
              ),
            ),
            if (isSelected && showCheck)
              const Icon(Icons.check, color: Colors.white),
            if (!isSelected && !showCheck)
              Icon(
                Icons.arrow_forward_ios,
                color: isDark ? Colors.white54 : Colors.grey,
                size: 16,
              ),
          ],
        ),
      ),
    );
  });
}
