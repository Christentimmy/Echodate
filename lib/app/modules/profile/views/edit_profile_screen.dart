import 'package:echodate/app/controller/user_controller.dart';
import 'package:echodate/app/modules/Interest/views/pick_hobbies_screen.dart';
import 'package:echodate/app/modules/Interest/widgets/interest_widgets.dart';
import 'package:echodate/app/modules/profile/controller/edit_profile_controller.dart';
import 'package:echodate/app/modules/profile/widgets/profile_widgets.dart';
import 'package:echodate/app/utils/date_converter.dart';
import 'package:echodate/app/widget/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({super.key});

  final _userController = Get.find<UserController>();
  final _editProfileController = Get.find<EditProfileController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Profile Pictures',
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10.0),
              BuildPictureSection(),
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
                controller: _editProfileController.nameController,
              ),
              const SizedBox(height: 10.0),
              Obx(
                () => CustomTextField(
                  hintText: "Email",
                  controller: _editProfileController.emailController,
                  readOnly: _editProfileController.isEmailEditDisAllowed.value,
                  suffixIcon: Icons.mode_edit_outline_outlined,
                  onSuffixTap: () {
                    _editProfileController.showEmailEditBottomSheet(context);
                  },
                ),
              ),
              const SizedBox(height: 10.0),
              Obx(
                () => CustomTextField(
                  hintText: "Phone Number",
                  controller: _editProfileController.phoneNumberController,
                  readOnly:
                      _editProfileController.isPhoneNumberEditDisAllowed.value,
                  suffixIcon: Icons.mode_edit_outline_outlined,
                  onSuffixTap: () {
                    _editProfileController
                        .showPhoneNumberEditBottomSheet(context);
                  },
                ),
              ),
              const SizedBox(height: 10.0),
              BuildGenderSelectField(),
              const SizedBox(height: 10.0),
              Obx(
                () => CustomTextField(
                  hintText: convertDateToNormal(
                    _userController.userModel.value?.dob ?? "",
                  ),
                  hintStyle: const TextStyle(color: Colors.black),
                  readOnly: true,
                ),
              ),
              const SizedBox(height: 10.0),
              CustomTextField(
                hintText: "Bio",
                controller: _editProfileController.bioController,
                maxLines: 3,
              ),
              SizedBox(height: Get.height * 0.04),
              Row(
                children: [
                  const Text(
                    'Interests',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      Get.to(
                        () => PickHobbiesScreen(
                          callback: () {
                            Navigator.pop(context);
                          },
                        ),
                      );
                    },
                    child: const Text(
                      "Edit",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              Obx(() {
                if (_userController.userModel.value == null) {
                  return const SizedBox.shrink();
                }
                return Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _userController.userModel.value!.hobbies!
                      .map((interest) => buildInterestCards(interest: interest))
                      .toList(),
                );
              }),
              const SizedBox(height: 20.0),
              BuildSaveButton(),
            ],
          ),
        ),
      ),
    );
  }
}
