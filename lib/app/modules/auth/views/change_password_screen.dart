import 'package:echodate/app/controller/auth_controller.dart';
import 'package:echodate/app/widget/custom_button.dart';
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
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header with Orange Gradient
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 40),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orange.shade700, Colors.orange.shade400],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.lock_outline, color: Colors.white, size: 80),
                  SizedBox(height: 10),
                  Text(
                    "Change Password",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Password Input Fields
            Obx(
              () => _buildPasswordField(
                label: "Old Password",
                controller: _oldPasswordController,
                obscureText: _obscureOldPassword.value,
                toggleObscure: () {
                  _obscureOldPassword.value = !_obscureOldPassword.value;
                },
              ),
            ),
            const SizedBox(height: 15),
            Obx(
              () => _buildPasswordField(
                label: "New Password",
                controller: _newPasswordController,
                obscureText: _obscureNewPassword.value,
                toggleObscure: () {
                  _obscureNewPassword.value = !_obscureNewPassword.value;
                },
              ),
            ),
            const SizedBox(height: 15),

            Obx(
              () => _buildPasswordField(
                label: "Confirm Password",
                controller: _confirmPasswordController,
                obscureText: _obscureConfirmPassword.value,
                toggleObscure: () {
                  _obscureConfirmPassword.value =
                      !_obscureConfirmPassword.value;
                },
              ),
            ),
            const SizedBox(height: 30),

            // Change Password Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: CustomButton(
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
            ),
          ],
        ),
      ),
    );
  }

  // Reusable Password Field Widget
  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
    required bool obscureText,
    required VoidCallback toggleObscure,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.orange.withOpacity(0.1),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.orange, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.orange, width: 2),
          ),
          prefixIcon: const Icon(Icons.lock, color: Colors.orange),
          suffixIcon: IconButton(
            icon: Icon(
              obscureText ? Icons.visibility_off : Icons.visibility,
              color: Colors.orange,
            ),
            onPressed: toggleObscure,
          ),
        ),
      ),
    );
  }
}
