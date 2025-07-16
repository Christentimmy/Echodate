import 'package:echodate/app/controller/auth_controller.dart';
import 'package:echodate/app/modules/auth/views/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'dart:math' as math;

class CreateNewPasswordScreen extends StatefulWidget {
  final String email;

  const CreateNewPasswordScreen({super.key, required this.email});

  @override
  State<CreateNewPasswordScreen> createState() =>
      _CreateNewPasswordScreenState();
}

class _CreateNewPasswordScreenState extends State<CreateNewPasswordScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  final _authController = Get.find<AuthController>();

  // Password strength variables
  double _passwordStrength = 0;
  String _passwordStrengthText = 'Weak';
  Color _passwordStrengthColor = Colors.red;

  // Animation controllers
  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    _rotationAnimation =
        Tween<double>(begin: 0, end: 2 * math.pi).animate(_animationController);
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _checkPasswordStrength(String password) {
    if (password.isEmpty) {
      setState(() {
        _passwordStrength = 0;
        _passwordStrengthText = 'Weak';
        _passwordStrengthColor = Colors.red;
      });
      return;
    }

    double strength = 0;

    // Length check
    if (password.length >= 8) strength += 0.25;

    // Contains uppercase
    if (password.contains(RegExp(r'[A-Z]'))) strength += 0.25;

    // Contains lowercase
    if (password.contains(RegExp(r'[a-z]'))) strength += 0.15;

    // Contains number
    if (password.contains(RegExp(r'[0-9]'))) strength += 0.2;

    // Contains special character
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) strength += 0.15;

    setState(() {
      _passwordStrength = strength;

      if (strength < 0.4) {
        _passwordStrengthText = 'Weak';
        _passwordStrengthColor = Colors.red;
      } else if (strength < 0.7) {
        _passwordStrengthText = 'Medium';
        _passwordStrengthColor = Colors.orange;
      } else {
        _passwordStrengthText = 'Strong';
        _passwordStrengthColor = Colors.green;
      }
    });
  }

  void _resetPassword() async {
    if (_formKey.currentState!.validate()) {
      final res = await _authController.forgotPassword(
        email: widget.email,
        password: _passwordController.text,
      );
      if (res != null) {
        _showSuccessAndNavigate();
      }
    }
  }

  void _showSuccessAndNavigate() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Success!',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.orange,
            fontWeight: FontWeight.bold,
          ),
        ).animate().fadeIn(duration: 400.ms).scale(),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle_outline,
              color: Colors.green,
              size: 80,
            ).animate().fadeIn(duration: 600.ms).scale(),
            const SizedBox(height: 16),
            const Text(
              'Your password has been reset successfully.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13),
            ).animate().fadeIn(delay: 300.ms).slideY(begin: 10, end: 0),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onPressed: () {
                Get.offAll(() => const LoginScreen());
              },
              child: const Text(
                'Go to Login',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ).animate().fadeIn(delay: 600.ms).slideY(begin: 20, end: 0),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: [
            _buildDecorationElements(),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back_ios),
                      color: Colors.orange,
                    )
                        .animate()
                        .fadeIn(duration: 400.ms)
                        .slideX(begin: -10, end: 0),
                    const SizedBox(height: 30),
                    _buildHeader(),
                    const SizedBox(height: 40),
                    _buildForm(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Create New Password",
          style: TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.bold,
          ),
        ).animate().fadeIn(delay: 200.ms).slideY(begin: -10, end: 0),
        const SizedBox(height: 12),
        Text(
          "Create a new password for ${widget.email}",
          style: const TextStyle(
            fontSize: 13,
            height: 1.5,
          ),
        ).animate().fadeIn(delay: 400.ms).slideY(begin: 10, end: 0),
      ],
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPasswordField()
              .animate()
              .fadeIn(delay: 600.ms)
              .slideX(begin: 30, end: 0),
          const SizedBox(height: 16),
          _buildPasswordStrengthIndicator()
              .animate()
              .fadeIn(delay: 700.ms)
              .slideX(begin: 30, end: 0),
          const SizedBox(height: 24),
          _buildConfirmPasswordField()
              .animate()
              .fadeIn(delay: 800.ms)
              .slideX(begin: 30, end: 0),
          const SizedBox(height: 24),
          _buildPasswordRequirements()
              .animate()
              .fadeIn(delay: 900.ms)
              .slideY(begin: 20, end: 0),
          const SizedBox(height: 32),
          _buildSubmitButton()
              .animate()
              .fadeIn(delay: 1000.ms)
              .slideY(begin: 20, end: 0),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      onChanged: _checkPasswordStrength,
      style: Get.textTheme.labelMedium,
      cursorColor: Colors.white,
      decoration: InputDecoration(
        hintText: "Enter your new password",
        hintStyle: Get.textTheme.bodySmall,
        prefixIcon: const Icon(
          Icons.lock_outline,
          color: Colors.orange,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility_off : Icons.visibility,
            color: Colors.orange.withOpacity(0.7),
          ),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
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
          return "Please enter a new password";
        }
        if (value.length < 8) {
          return "Password must be at least 8 characters long";
        }
        if (!value.contains(RegExp(r'[A-Z]'))) {
          return "Password must contain at least one uppercase letter";
        }
        if (!value.contains(RegExp(r'[0-9]'))) {
          return "Password must contain at least one number";
        }
        return null;
      },
    );
  }

  Widget _buildPasswordStrengthIndicator() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Password Strength",
              style: TextStyle(fontSize: 12),
            ),
            Text(
              _passwordStrengthText,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: _passwordStrengthColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Stack(
          children: [
            Container(
              height: 6,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: 6,
              width:
                  MediaQuery.of(context).size.width * 0.85 * _passwordStrength,
              decoration: BoxDecoration(
                color: _passwordStrengthColor,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildConfirmPasswordField() {
    return TextFormField(
      controller: _confirmPasswordController,
      obscureText: _obscureConfirmPassword,
      style: Get.textTheme.labelMedium,
      cursorColor: Colors.white,
      decoration: InputDecoration(
        hintText: "Confirm your new password",
        hintStyle: Get.textTheme.bodySmall,
        prefixIcon: const Icon(
          Icons.lock_outline,
          color: Colors.orange,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
            color: Colors.orange.withOpacity(0.7),
          ),
          onPressed: () {
            setState(() {
              _obscureConfirmPassword = !_obscureConfirmPassword;
            });
          },
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
          return "Please confirm your password";
        }
        if (value != _passwordController.text) {
          return "Passwords do not match";
        }
        return null;
      },
    );
  }

  Widget _buildPasswordRequirements() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.orange.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Password Requirements:",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _buildRequirementRow(
            "At least 8 characters",
            _passwordController.text.length >= 8,
          ),
          const SizedBox(height: 8),
          _buildRequirementRow(
            "At least one uppercase letter (A-Z)",
            _passwordController.text.contains(RegExp(r'[A-Z]')),
          ),
          const SizedBox(height: 8),
          _buildRequirementRow(
            "At least one number (0-9)",
            _passwordController.text.contains(RegExp(r'[0-9]')),
          ),
          const SizedBox(height: 8),
          _buildRequirementRow(
            "Passwords match",
            _confirmPasswordController.text.isNotEmpty &&
                _confirmPasswordController.text == _passwordController.text,
          ),
        ],
      ),
    );
  }

  Widget _buildRequirementRow(String text, bool isMet) {
    return Row(
      children: [
        Icon(
          isMet ? Icons.check_circle : Icons.circle_outlined,
          size: 18,
          color: isMet ? Colors.green : Colors.grey,
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(fontSize: 11),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _authController.isLoading.value ? null : _resetPassword,
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
                  "Reset Password",
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

          // Animated rotating blob 2
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Positioned(
                left: 30 + 50 * math.cos(_rotationAnimation.value * 0.3),
                bottom: 50 + 40 * math.sin(_rotationAnimation.value * 0.6),
                child: Transform.rotate(
                  angle: -_rotationAnimation.value * 0.3,
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
            animation: _animationController,
            builder: (context, child) {
              final pulseFactor =
                  1.0 + 0.2 * math.sin(_rotationAnimation.value * 3);
              return Positioned(
                right: 70 + 30 * math.cos(_rotationAnimation.value * 1.1),
                bottom: 80 + 30 * math.sin(_rotationAnimation.value * 1.3),
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
