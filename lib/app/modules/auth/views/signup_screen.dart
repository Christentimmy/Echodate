import 'dart:math' as math;
import 'package:echodate/app/controller/auth_controller.dart';
import 'package:echodate/app/models/user_model.dart';
import 'package:echodate/app/modules/auth/controller/signup_controller.dart';
import 'package:echodate/app/modules/auth/views/login_screen.dart';
import 'package:echodate/app/modules/auth/widgets/auth_widgets.dart';
import 'package:echodate/app/resources/colors.dart';
import 'package:echodate/app/widget/animations.dart';
import 'package:echodate/app/widget/custom_button.dart';
import 'package:echodate/app/widget/loader.dart';
import 'package:echodate/app/widget/snack_bar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final _signUpController = Get.put(SignUpController());
  final _authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    _signUpController.recreateFormKey();
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: AnimatedListWrapper(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: Get.height * 0.15),
              Image.asset(
                "assets/images/ECHODATE.png",
                width: Get.width * 0.34,
                height: Get.height * 0.075,
              ),
              const SizedBox(height: 20),
              const Text(
                "Register to your account",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                "Fill the following essential details to get registered.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 20),
              Stack(
                children: [
                  _buildDecorationElements(),
                  SignUpFormFields(),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Obx(
                    () => Checkbox(
                      value: _signUpController.isCheckValue.value,
                      visualDensity: VisualDensity.compact,
                      activeColor: AppColors.primaryColor,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      onChanged: (value) {
                        _signUpController.isCheckValue.value = value!;
                      },
                    ),
                  ),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(color: Colors.black),
                        children: [
                          const TextSpan(text: 'I agree to the '),
                          TextSpan(
                            text: 'Terms & Conditions',
                            style: TextStyle(
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () =>
                                  _signUpController.showTermsDialog(context),
                          ),
                          const TextSpan(text: ' and '),
                          TextSpan(
                            text: 'Privacy Policy',
                            style: TextStyle(
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () =>
                                  _signUpController.showPrivacyDialog(context),
                          ),
                          const TextSpan(text: '.'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: Get.height * 0.05),
              Obx(() {
                return CustomButton(
                  ontap: () async {
                    FocusManager.instance.primaryFocus?.unfocus();
                    if (!_signUpController.signUpFormKey.currentState!
                        .validate()) {
                      return;
                    }
                    if (!_signUpController.isCheckValue.value) {
                      CustomSnackbar.showErrorSnackBar(
                        "Accept our terms and condition",
                      );
                      return;
                    }
                    if (_signUpController.selectedCountryCode.value.isEmpty) {
                      CustomSnackbar.showErrorSnackBar(
                        "Select your country code",
                      );
                      return;
                    }
                    final String email = _signUpController.emailController.text;
                    final otpCode = _signUpController.otpCodeController.text;
                    final userModel = UserModel(
                      email: email,
                      otpCode: otpCode,
                      password: _signUpController.passwordController.text,
                    );

                    await _authController.signUpUSer(
                      userModel: userModel,
                    );
                  },
                  child: _authController.isLoading.value
                      ? const Loader()
                      : const Text(
                          "Register",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                );
              }),
              SizedBox(height: Get.height * 0.04),
              TextButton(
                onPressed: () => Get.to(() => LoginScreen()),
                child: const Text(
                  "Already have an account? Login",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDecorationElements() {
    return SizedBox(
      height: Get.height * 0.3,
      child: Stack(
        children: [
          // Animated rotating blob 1
          AnimatedBuilder(
            animation: _signUpController.animationController,
            builder: (context, child) {
              final rotationAnimation = _signUpController.rotationAnimation;
              return Positioned(
                right: 20 + 40 * math.sin(rotationAnimation.value * 0.5),
                top: 20 + 30 * math.cos(rotationAnimation.value * 0.7),
                child: Transform.rotate(
                  angle: rotationAnimation.value * 0.2,
                  child: _buildAnimatedBlob(
                    Colors.orange.withOpacity(0.04),
                    120,
                    borderRadius: 60,
                  ),
                ),
              );
            },
          ),

          // Animated rotating blob 2
          AnimatedBuilder(
            animation: _signUpController.animationController,
            builder: (context, child) {
              final rotationAnimation = _signUpController.rotationAnimation;
              return Positioned(
                left: 30 + 50 * math.cos(rotationAnimation.value * 0.3),
                bottom: 50 + 40 * math.sin(rotationAnimation.value * 0.6),
                child: Transform.rotate(
                  angle: -rotationAnimation.value * 0.3,
                  child: _buildAnimatedBlob(
                    Colors.deepOrange.withOpacity(0.02),
                    100,
                    borderRadius: 30,
                  ),
                ),
              );
            },
          ),

          // Animated pulsating circle
          AnimatedBuilder(
            animation: _signUpController.animationController,
            builder: (context, child) {
              final rotationAnimation = _signUpController.rotationAnimation;
              final pulseFactor =
                  1.0 + 0.2 * math.sin(rotationAnimation.value * 3);
              return Positioned(
                right: 70 + 30 * math.cos(rotationAnimation.value * 1.1),
                bottom: 80 + 30 * math.sin(rotationAnimation.value * 1.3),
                child: Transform.scale(
                  scale: pulseFactor,
                  child: _buildAnimatedBlob(
                    Colors.amber.withOpacity(0.07),
                    70,
                    isCircle: true,
                  ),
                ),
              );
            },
          ),

          // Small floating circles
          AnimatedBuilder(
            animation: _signUpController.animationController,
            builder: (context, child) {
              final rotationAnimation = _signUpController.rotationAnimation;
              return Positioned(
                left: 150 + 20 * math.sin(rotationAnimation.value * 2),
                top: 80 + 15 * math.cos(rotationAnimation.value * 1.5),
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
            animation: _signUpController.animationController,
            builder: (context, child) {
              final rotationAnimation = _signUpController.rotationAnimation;
              return Positioned(
                right: 120 + 25 * math.cos(rotationAnimation.value * 1.8),
                top: 120 + 20 * math.sin(rotationAnimation.value * 1.7),
                child: _buildAnimatedBlob(
                  Colors.deepOrange.withOpacity(0.1),
                  20,
                  isCircle: true,
                ),
              );
            },
          ),
        ],
      ),
    ).animate().fadeIn(delay: 1200.ms);
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
