import 'dart:io';

import 'package:echodate/app/modules/Interest/widgets/interest_widgets.dart';
import 'package:echodate/app/modules/profile/widgets/profile_widgets.dart';
import 'package:echodate/app/resources/colors.dart';
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
  String name = 'John Doe';
  String gender = 'Male';
  DateTime birthDate = DateTime(1996, 8, 2);
  String bio = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.';

  String relationshipStatus = 'Long-Term Relationship';

  double screenWidth = Get.width;
  double screenHeight = Get.height;

  List<Map<String, String>> interests = [
    {"emoji": "⚽", "label": "Football"},
    {"emoji": "🌿", "label": "Nature"},
    {"emoji": "🗣️", "label": "Tech"},
    {"emoji": "📸", "label": "Photography"},
    {"emoji": "🌱", "label": "Language"},
  ];

  File? profileImage;
  List<File?> images = List.filled(5, null);

  Future<void> pickImage(int index, {bool isProfile = false}) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        if (isProfile) {
          profileImage = File(pickedFile.path);
        } else {
          images[index] = File(pickedFile.path);
        }
      });
    }
  }

  void removeImage(int index, {bool isProfile = false}) {
    setState(() {
      if (isProfile) {
        profileImage = null;
      } else {
        images[index] = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Profile Pictures',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10.0),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      ProfileImage(
                        imageFile: profileImage,
                        isLarge: true,
                        index: "1",
                        onPickImage: () => pickImage(0, isProfile: true),
                        onRemove: () => removeImage(0, isProfile: true),
                      ),
                      SizedBox(width: screenWidth * 0.02),
                      Column(
                        children: [
                          ProfileImage(
                            imageFile: images[0],
                            index: "2",
                            onPickImage: () => pickImage(0),
                            onRemove: () => removeImage(0),
                          ),
                          SizedBox(height: screenHeight * 0.01),
                          ProfileImage(
                            imageFile: images[1],
                            index: "3",
                            onPickImage: () => pickImage(1),
                            onRemove: () => removeImage(1),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ProfileImage(
                        imageFile: images[2],
                        index: "4",
                        onPickImage: () => pickImage(2),
                        onRemove: () => removeImage(2),
                      ),
                      SizedBox(width: screenWidth * 0.02),
                      ProfileImage(
                        imageFile: images[3],
                        index: "5",
                        onPickImage: () => pickImage(3),
                        onRemove: () => removeImage(3),
                      ),
                      SizedBox(width: screenWidth * 0.02),
                      ProfileImage(
                        imageFile: images[4],
                        index: "6",
                        onPickImage: () => pickImage(4),
                        onRemove: () => removeImage(4),
                      ),
                    ],
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
                onChanged: (value) {
                  setState(() {
                    name = value;
                  });
                },
              ),
              const SizedBox(height: 10.0),
              DropdownButtonFormField<String>(
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
                value: gender,
                onChanged: (value) {
                  setState(() {
                    gender = value!;
                  });
                },
                items: ['Male', 'Female', 'Other'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const SizedBox(height: 10.0),
              CustomTextField(
                hintText: "April 12 2000",
                readOnly: true,
              ),
              const SizedBox(height: 10.0),
              CustomTextField(
                hintText: "Bio",
                maxLines: 3,
              ),
              SizedBox(height: Get.height * 0.04),
              const Row(
                children: [
                  Text(
                    'Interests',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  Text(
                    "Edit",
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: interests.map((interest) {
                  return buildSelectiveCards(
                    interest: interest,
                    isSelected: false,
                    onTap: () {},
                  );
                }).toList(),
              ),
              const SizedBox(height: 20.0),
              CustomButton(
                ontap: () {},
                child: const Text(
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
