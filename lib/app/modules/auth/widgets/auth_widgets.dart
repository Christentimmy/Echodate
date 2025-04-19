import 'dart:math';

import 'package:echodate/app/controller/auth_controller.dart';
import 'package:echodate/app/modules/auth/controller/login_controller.dart';
import 'package:echodate/app/modules/auth/controller/signup_controller.dart';
import 'package:echodate/app/widget/custom_textfield.dart';
import 'package:echodate/app/widget/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class LoginFormField extends StatelessWidget {
  LoginFormField({super.key});

  final _loginController = Get.find<LoginController>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _loginController.formKey,
      child: Column(
        children: [
          CustomTextField(
            controller: _loginController.emailController,
            hintText: "Email/Number",
            prefixIcon: Icons.email,
            validator: (value) {
              if (value!.isEmpty) {
                return "";
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
          CustomTextField(
            controller: _loginController.passwordController,
            hintText: "Password",
            isObscure: true,
            prefixIcon: Icons.lock,
          ),
        ],
      ),
    );
  }
}

class SignUpFormFields extends StatelessWidget {
  SignUpFormFields({super.key});

  final _signController = Get.find<SignUpController>();
  final _authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _signController.signUpFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextField(
            controller: _signController.emailController,
            hintText: "Email",
            prefixIcon: Icons.email,
          ),
          // const SizedBox(height: 15),
          // CustomPhoneNumberField(
          //   phoneNumberController: phoneNUmberController,
          //   selectedCountryCode: selectedCountryCode,
          // ),
          const SizedBox(height: 15),
          CustomTextField(
            controller: _signController.passwordController,
            hintText: "Password",
            isObscure: true,
            prefixIcon: Icons.lock,
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  hintText: "Code",
                  prefixIcon: Icons.code,
                  controller: _signController.otpCodeController,
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 10),
              AnimatedSendButton(
                onTap: () async {
                  String email = _signController.emailController.text.trim();
                  if (email.isEmpty) {
                    CustomSnackbar.showErrorSnackBar("Email is required");
                    return;
                  }
                  await _authController.sendSignUpOtp(email: email);
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}

class CustomPhoneNumberField extends StatelessWidget {
  final TextEditingController phoneNumberController;
  final RxString selectedCountryCode;

  CustomPhoneNumberField({
    super.key,
    required this.phoneNumberController,
    required this.selectedCountryCode,
  });

  final List<Map<String, String>> africanCountries = [
    {'name': 'Nigeria', 'code': '+234'},
    {'name': 'South Africa', 'code': '+27'},
    {'name': 'Kenya', 'code': '+254'},
    {'name': 'Ghana', 'code': '+233'},
    {'name': 'Egypt', 'code': '+20'},
    {'name': 'Morocco', 'code': '+212'},
    {'name': 'Ethiopia', 'code': '+251'},
    {'name': 'Algeria', 'code': '+213'},
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text("Select Country"),
                    content: SizedBox(
                      width: double.maxFinite,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: africanCountries.length,
                        itemBuilder: (context, index) {
                          final country = africanCountries[index];
                          return ListTile(
                            title:
                                Text("${country['name']} (${country['code']})"),
                            onTap: () {
                              selectedCountryCode.value = country['code']!;

                              Navigator.pop(context);
                            },
                          );
                        },
                      ),
                    ),
                  );
                },
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              height: 51,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Obx(
                () => Text(
                  selectedCountryCode.value,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          flex: 3,
          child: CustomTextField(
            controller: phoneNumberController,
            hintText: "Phone Number",
            prefixIcon: Icons.phone,
            keyboardType: TextInputType.number,
          ),
        ),
      ],
    );
  }
}

enum ContactType { email, phone }

class ContactUpdateBottomSheet extends StatefulWidget {
  final ContactType type;
  final String initialValue;
  final Function(String) onSave;
  final Color primaryColor;

  const ContactUpdateBottomSheet({
    super.key,
    required this.type,
    required this.initialValue,
    required this.onSave,
    this.primaryColor = Colors.orange,
  });

  // Static method to show the bottom sheet
  static Future<void> show({
    required BuildContext context,
    required ContactType type,
    required String initialValue,
    required Function(String) onSave,
    Color primaryColor = Colors.orange,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ContactUpdateBottomSheet(
        type: type,
        initialValue: initialValue,
        onSave: onSave,
        primaryColor: primaryColor,
      ),
    );
  }

  @override
  State<ContactUpdateBottomSheet> createState() =>
      _ContactUpdateBottomSheetState();
}

class _ContactUpdateBottomSheetState extends State<ContactUpdateBottomSheet> {
  late TextEditingController _controller;
  bool _isValid = false;
  String? _errorText;
  final _authController = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
    _validate(_controller.text);
    _controller.addListener(() {
      _validate(_controller.text);
    });
  }

  void _validate(String value) {
    setState(() {
      if (widget.type == ContactType.email) {
        final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
        _isValid = emailRegex.hasMatch(value);
        _errorText = _isValid ? null : 'Please enter a valid email address';
      } else {
        // Simple phone validation (can be improved based on your requirements)
        final phoneRegex = RegExp(r'^\d{10,15}$');
        _isValid = phoneRegex.hasMatch(value);
        _errorText = _isValid ? null : 'Please enter a valid phone number';
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final title = widget.type == ContactType.email
        ? 'Update Email'
        : 'Update Phone Number';
    final hint = widget.type == ContactType.email
        ? 'Enter your email'
        : 'Enter your phone number';
    final keyboardType = widget.type == ContactType.email
        ? TextInputType.emailAddress
        : TextInputType.phone;

    final inputFormatters = widget.type == ContactType.phone
        ? [FilteringTextInputFormatter.digitsOnly]
        : null;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: widget.primaryColor.withOpacity(0.1),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: widget.primaryColor,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.grey),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Current ${widget.type == ContactType.email ? 'Email' : 'Phone Number'}:',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.initialValue,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'New ${widget.type == ContactType.email ? 'Email' : 'Phone Number'}:',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _controller,
                    keyboardType: keyboardType,
                    inputFormatters: inputFormatters,
                    decoration: InputDecoration(
                      hintText: hint,
                      errorText: _errorText,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide:
                            BorderSide(color: widget.primaryColor, width: 2),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide:
                            const BorderSide(color: Colors.red, width: 1),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isValid
                          ? () {
                              widget.onSave(_controller.text);
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.primaryColor,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: Colors.grey[300],
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Obx(
                        () => _authController.isLoading.value
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                'Save Changes',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class AnimatedSendButton extends StatefulWidget {
  final Function() onTap;
  final String text;

  const AnimatedSendButton({
    super.key,
    required this.onTap,
    this.text = "Send Code",
  });

  @override
  State<AnimatedSendButton> createState() => _AnimatedSendButtonState();
}

class _AnimatedSendButtonState extends State<AnimatedSendButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  // bool _isLoading = false;
  final List<ParticleModel> _particles = [];
  final _authController = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.3, curve: Curves.easeOut),
      ),
    );

    // Generate particles
    _generateParticles();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _authController.isSignUpOtpLoading.value = true;
        });
      }
    });
  }

  void _generateParticles() {
    final random = Random();
    for (int i = 0; i < 20; i++) {
      _particles.add(
        ParticleModel(
          id: i,
          x: 0,
          y: 0,
          vx: (random.nextDouble() - 0.5) * 8,
          vy: (random.nextDouble() - 0.5) * 8,
          size: random.nextDouble() * 5 + 1,
          color: Colors.grey.shade600,
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        if (!_authController.isSignUpOtpLoading.value &&
            !_controller.isAnimating) {
          _controller.forward();
          await widget.onTap();
          await Future.delayed(const Duration(milliseconds: 400));
          _controller.reverse().then((_) {
            setState(() {
              _authController.isSignUpOtpLoading.value = false;
            });
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        height: 51,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(12),
        ),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Stack(
              alignment: Alignment.center,
              children: [
                // Particles
                if (_controller.value > 0 && _controller.value < 0.7)
                  ...generateParticleWidgets(),

                // Original text that fades out
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Text(
                    widget.text,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),

                // Loading indicator that fades in
                if (_authController.isSignUpOtpLoading.value)
                  const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  List<Widget> generateParticleWidgets() {
    final progress = _controller.value;
    final particleWidgets = <Widget>[];

    for (var particle in _particles) {
      // Calculate position based on animation progress
      final x = particle.x + particle.vx * progress * 20;
      final y = particle.y + particle.vy * progress * 20;

      // Calculate opacity based on animation progress
      final opacity = 1.0 - (_controller.value * 2).clamp(0.0, 1.0);

      particleWidgets.add(
        Positioned(
          left: x,
          top: y,
          child: Opacity(
            opacity: opacity,
            child: Container(
              width: particle.size,
              height: particle.size,
              decoration: BoxDecoration(
                color: particle.color,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      );
    }

    return particleWidgets;
  }
}

class ParticleModel {
  final int id;
  final double x;
  final double y;
  final double vx; // velocity x
  final double vy; // velocity y
  final double size;
  final Color color;

  ParticleModel({
    required this.id,
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.size,
    required this.color,
  });
}
