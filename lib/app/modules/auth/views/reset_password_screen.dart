import 'package:echodate/app/controller/auth_controller.dart';
import 'package:echodate/app/resources/colors.dart';
import 'package:echodate/app/utils/validator.dart';
import 'package:echodate/app/widget/custom_button.dart';
import 'package:echodate/app/widget/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:math' as math;

import 'package:get/get.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _authController = Get.find<AuthController>();

  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    _rotationAnimation = Tween<double>(begin: 0, end: 2 * math.pi).animate(
      _animationController,
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print(Get.isDarkMode);
    return Scaffold(
      // backgroundColor: Get.theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.arrow_back_ios),
                  color: Colors.orange,
                ).animate().fadeIn(duration: 400.ms).slideX(begin: -10, end: 0),
                const SizedBox(height: 30),
                _buildHeader(),
                const SizedBox(height: 40),
                _buildForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Reset Password",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ).animate().fadeIn(delay: 200.ms).slideY(begin: -10, end: 0),
        const SizedBox(height: 12),
        const Text(
          "Enter your email and we'll send you instructions to reset your password.",
          style: TextStyle(
            fontSize: 16,
            height: 1.5,
          ),
        ).animate().fadeIn(delay: 400.ms).slideY(begin: 10, end: 0),
      ],
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          NewCustomTextField(
            hintText: "your@example.com",
            keyboardType: TextInputType.emailAddress,
            controller: _emailController,
            prefixIcon: Icons.email_outlined,
            prefixIconColor: AppColors.primaryColor,
            validator: validateEmail,
          ).animate().fadeIn().slideX(begin: 30, end: 0),
          const SizedBox(height: 24),
          CustomButton(
            ontap: () async {
              if (_authController.isLoading.value) {
                return;
              }
              FocusManager.instance.primaryFocus?.unfocus();
              if (_formKey.currentState!.validate()) {
                await _authController.sendOtpForgotPassword(
                  email: _emailController.text,
                );
              }
            },
            child: Obx(
              () => _authController.isLoading.value
                  ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      "continue",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
            ),
          ).animate().fadeIn(delay: 800.ms).slideY(begin: 20, end: 0),
          const SizedBox(height: 40),
          _buildDecorationElements(),
        ],
      ),
    );
  }

  Widget _buildDecorationElements() {
    return SizedBox(
      height: Get.height * 0.7,
      child: Stack(
        children: [
          // Animated rotating blob 1
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Positioned(
                right: 20 + 40 * math.sin(_rotationAnimation.value * 0.5),
                top: 20 + 30 * math.cos(_rotationAnimation.value * 0.7),
                child: Transform.rotate(
                  angle: _rotationAnimation.value * 0.2,
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
            animation: _animationController,
            builder: (context, child) {
              return Positioned(
                left: 150 + 20 * math.sin(_rotationAnimation.value * 2),
                top: 80 + 15 * math.cos(_rotationAnimation.value * 1.5),
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
            animation: _animationController,
            builder: (context, child) {
              return Positioned(
                right: 120 + 25 * math.cos(_rotationAnimation.value * 1.8),
                top: 120 + 20 * math.sin(_rotationAnimation.value * 1.7),
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
