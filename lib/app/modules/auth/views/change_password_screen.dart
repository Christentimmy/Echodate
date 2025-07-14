import 'package:echodate/app/controller/auth_controller.dart';
import 'package:echodate/app/widget/custom_button.dart';
import 'package:echodate/app/widget/custom_textfield.dart';
import 'package:echodate/app/widget/loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final RxBool _obscureOldPassword = true.obs;
  final RxBool _obscureNewPassword = true.obs;
  final RxBool _obscureConfirmPassword = true.obs;

  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final _authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Change Password",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 10,
        ),
        child: Column(
          children: [
            const SizedBox(height: 30),

            // Password Input Fields
            Obx(
              () => NewCustomTextField(
                hintText: "Old Password",
                controller: _oldPasswordController,
                isObscure: _obscureOldPassword.value,
                suffixIcon: _obscureOldPassword.value
                    ? Icons.visibility_off
                    : Icons.visibility,
                onSuffixTap: () {
                  _obscureOldPassword.value = !_obscureOldPassword.value;
                },
              ),
            ),
            const SizedBox(height: 15),
            Obx(
              () => NewCustomTextField(
                hintText: "New Password",
                controller: _newPasswordController,
                isObscure: _obscureNewPassword.value,
                suffixIcon: _obscureOldPassword.value
                    ? Icons.visibility_off
                    : Icons.visibility,
                onSuffixTap: () {
                  _obscureNewPassword.value = !_obscureNewPassword.value;
                },
              ),
            ),
            const SizedBox(height: 15),

            Obx(
              () => NewCustomTextField(
                hintText: "Confirm Password",
                controller: _confirmPasswordController,
                isObscure: _obscureConfirmPassword.value,
                suffixIcon: _obscureOldPassword.value
                    ? Icons.visibility_off
                    : Icons.visibility,
                onSuffixTap: () {
                  _obscureConfirmPassword.value =
                      !_obscureConfirmPassword.value;
                },
              ),
            ),
            const Spacer(),

            // Change Password Button
            CustomButton(
              ontap: _authController.isLoading.value
                  ? () {}
                  : () async {
                      await _authController.changePassword(
                        oldPassword: _oldPasswordController.text,
                        newPassword: _newPasswordController.text,
                      );
                    },
              child: _authController.isLoading.value
                  ? const Loader()
                  : const Text(
                      "Update Password",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
