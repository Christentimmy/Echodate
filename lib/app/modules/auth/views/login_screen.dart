import 'dart:math' as math;
import 'package:echodate/app/modules/auth/controller/login_controller.dart';
import 'package:echodate/app/modules/auth/views/reset_password_screen.dart';
import 'package:echodate/app/modules/auth/views/signup_screen.dart';
import 'package:echodate/app/modules/auth/widgets/auth_widgets.dart';
import 'package:echodate/app/resources/colors.dart';
import 'package:echodate/app/widget/animations.dart';
import 'package:echodate/app/widget/custom_button.dart';
import 'package:echodate/app/widget/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final _loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    _loginController.recreateFormKey();
    return Scaffold(
      body: Stack(
        children: [
          _buildDecorationElements(),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 20,
              ),
              child: AnimatedListWrapper(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: Get.height * 0.09),
                  Image.asset(
                    "assets/images/ECHODATE.png",
                    width: Get.width * 0.34,
                    height: Get.height * 0.075,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Login to your account",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    "Welcome to ECHODATE, enter your details below to continue .",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: Get.height * 0.05),
                  LoginFormField(),
                  // const SizedBox(height: 5),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Get.to(() => const ResetPasswordScreen());
                      },
                      child: Text(
                        "Forgot password?",
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: Get.height * 0.05),
                  CustomButton(
                    ontap: () async {
                      FocusManager.instance.primaryFocus?.unfocus();
                      if (_loginController.formKey.currentState!.validate()) {
                        await _loginController.authController.loginUser(
                          identifier: _loginController.emailController.text,
                          password: _loginController.passwordController.text,
                        );
                      }
                    },
                    child: Obx(
                      () => _loginController.authController.isLoading.value
                          ? const Loader()
                          : const Text(
                              "Login",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                  SizedBox(height: Get.height * 0.1),
                  TextButton(
                    onPressed: () => Get.to(() => RegisterScreen()),
                    child: const Text("Don't have an account? Register"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDecorationElements() {
    return Padding(
      padding: EdgeInsets.only(top: Get.height * 0.4),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Animated rotating blob 1
          AnimatedBuilder(
            animation: _loginController.animationController,
            builder: (context, child) {
              return Positioned(
                right: 20 +
                    40 *
                        math.sin(
                            _loginController.rotationAnimation.value * 0.5),
                top: 20 +
                    30 *
                        math.cos(
                            _loginController.rotationAnimation.value * 0.7),
                child: Transform.rotate(
                  angle: _loginController.rotationAnimation.value * 0.2,
                  child: _buildAnimatedBlob(
                    Colors.orange.withOpacity(0.04),
                    120,
                    borderRadius: 60,
                  ),
                ),
              );
            },
          ),

          // Small floating circles
          AnimatedBuilder(
            animation: _loginController.animationController,
            builder: (context, child) {
              return Positioned(
                left: 150 +
                    20 * math.sin(_loginController.rotationAnimation.value * 2),
                top: 80 +
                    15 *
                        math.cos(
                            _loginController.rotationAnimation.value * 1.5),
                child: _buildAnimatedBlob(
                  Colors.orange.withOpacity(0.15),
                  30,
                  isCircle: true,
                ),
              );
            },
          ),

          // Another small floating circle
          AnimatedBuilder(
            animation: _loginController.animationController,
            builder: (context, child) {
              return Positioned(
                right: 120 +
                    25 *
                        math.cos(
                            _loginController.rotationAnimation.value * 1.8),
                top: 120 +
                    20 *
                        math.sin(
                            _loginController.rotationAnimation.value * 1.7),
                child: _buildAnimatedBlob(
                  Colors.deepOrange.withOpacity(0.1),
                  20,
                  isCircle: true,
                ),
              );
            },
          ),
        ],
      ).animate().fadeIn(delay: 1200.ms),
    );
  }

  Widget _buildAnimatedBlob(
    Color color,
    double size, {
    double? borderRadius,
    bool isCircle = false,
  }) {
    if (isCircle) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      );
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(borderRadius ?? size / 4),
      ),
    );
  }
}
