import 'package:echodate/app/controller/auth_controller.dart';
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
    return Scaffold(
      backgroundColor: Colors.white,
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
                  onPressed: () {
                    // Navigate back
                  },
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
            color: Colors.black87,
          ),
        ).animate().fadeIn(delay: 200.ms).slideY(begin: -10, end: 0),
        const SizedBox(height: 12),
        const Text(
          "Enter your email and we'll send you instructions to reset your password.",
          style: TextStyle(
            fontSize: 16,
            color: Colors.black54,
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
          _buildAnimatedEmailField()
              .animate()
              .fadeIn(delay: 600.ms)
              .slideX(begin: 30, end: 0),
          const SizedBox(height: 24),
          _buildSubmitButton()
              .animate()
              .fadeIn(delay: 800.ms)
              .slideY(begin: 20, end: 0),
          const SizedBox(height: 40),
          _buildDecorationElements(),
        ],
      ),
    );
  }

  Widget _buildAnimatedEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        hintText: "your@example.com",
        hintStyle: const TextStyle(
          fontSize: 14,
          color: Colors.black26,
        ),
        prefixIcon: const Icon(
          Icons.email_outlined,
          color: Colors.orange,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.orange.withOpacity(0.1),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: Colors.orange,
            width: 2,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please enter your email";
        }
        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
          return "Please enter a valid email";
        }
        return null;
      },
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _authController.isLoading.value
            ? null
            : () async {
                FocusManager.instance.primaryFocus?.unfocus();
                if (_formKey.currentState!.validate()) {
                  await _authController.sendOtpForgotPassword(
                    email: _emailController.text,
                  );
                }
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
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
                  ),
                ),
        ),
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
