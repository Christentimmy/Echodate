import 'dart:math';
import 'package:echodate/app/controller/auth_controller.dart';
import 'package:echodate/app/modules/auth/controller/login_controller.dart';
import 'package:echodate/app/modules/auth/controller/signup_controller.dart';
import 'package:echodate/app/modules/auth/views/signup_screen.dart';
import 'package:echodate/app/modules/auth/views/reset_password_screen.dart';
import 'package:echodate/app/resources/colors.dart';
import 'package:echodate/app/widget/custom_button.dart';
import 'package:echodate/app/widget/custom_textfield.dart';
import 'package:echodate/app/widget/loader.dart';
import 'package:echodate/app/widget/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class LoginFormField extends StatelessWidget {
  LoginFormField({super.key});

  final _loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 20,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Sign In",
            style: Get.textTheme.headlineMedium,
          ),
          const SizedBox(height: 2),
          Text(
            "Enter your credentials to continue",
            style: Get.textTheme.bodySmall,
          ),
          const SizedBox(height: 15),
          Form(
            key: _loginController.formKey,
            child: Column(
              children: [
                _getEmailFormField(_loginController),
                const SizedBox(height: 15),
                Obx(() {
                  RxBool isVsibile = _loginController.isPasswordVisible;
                  return _getPasswordFormField(isVsibile, _loginController);
                }),
                const SizedBox(height: 30),
              ],
            ),
          ),
          CustomButton(
            bgRadient: Get.isDarkMode
                ? LinearGradient(
                    colors: [
                      AppColors.accentOrange400,
                      AppColors.accentOrange600,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            boxShadow: Get.isDarkMode
                ? [
                    BoxShadow(
                      color: AppColors.accentOrange400.withOpacity(0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
            ontap: () async {
              HapticFeedback.lightImpact();
              FocusManager.instance.primaryFocus?.unfocus();
              if (_loginController.formKey.currentState!.validate()) {
                await _loginController.authController.loginUser(
                  identifier: _loginController.emailController.text,
                  password: _loginController.passwordController.text,
                );
                _loginController.clean();
              }
            },
            child: Obx(
              () => _loginController.authController.isLoading.value
                  ? const Loader()
                  : _getButtonContent(),
            ),
          ),
          const SizedBox(height: 6),
          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: () {
                Get.to(() => const ResetPasswordScreen());
              },
              child: Text(
                "Forgot your password?",
                style: Get.textTheme.labelSmall,
              ),
            ),
          ),
          SizedBox(height: Get.height * 0.05),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 4,
            children: [
              Text(
                "New to EchoDate? ",
                style: TextStyle(
                  color: Get.theme.primaryColor,
                ),
              ),
              InkWell(
                onTap: () {
                  Get.to(() => RegisterScreen());
                },
                child: Text(
                  "Create account",
                  style: TextStyle(
                    color: AppColors.accentOrange400,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _getButtonContent() {
    if (Get.isDarkMode) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Sign in",
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 10),
          Icon(
            Icons.arrow_forward,
            size: 20,
            color: AppColors.textPrimary,
          ),
        ],
      );
    } else {
      return const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Sign in",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 10),
          Icon(
            Icons.arrow_forward,
            size: 20,
            color: Colors.white,
          ),
        ],
      );
    }
  }
}

class SignUpFormFields extends StatelessWidget {
  SignUpFormFields({super.key});

  final _signController = Get.find<SignUpController>();
  final _authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _getEmailFormField(_signController),
        const SizedBox(height: 15),
        Obx(() {
          RxBool isVisible = _signController.isPasswordVisible;
          return _getPasswordFormField(isVisible, _signController);
        }),
        const SizedBox(height: 15),
        Row(
          children: [
            _getCodeField(),
            const SizedBox(width: 10),
            Expanded(
              flex: 1,
              child: _getCustomButton(),
            ),
          ],
        )
      ],
    );
  }

  Widget _getCustomButton() {
    final isDark = Get.isDarkMode;

    return CustomButton(
      bgColor: isDark ? AppColors.fieldBackground : Colors.grey.shade50,
      bgRadient: null,
      border: Border.all(
        width: 1,
        color: isDark ? AppColors.fieldBorder : Colors.grey.shade300,
      ),
      ontap: () async {
        String email = _signController.emailController.text.trim();
        if (email.isEmpty) {
          CustomSnackbar.showErrorSnackBar("Email is required");
          return;
        }
        await _authController.sendSignUpOtp(email: email);
      },
      child: Obx(
        () => _authController.isLoading.value
            ? CircularProgressIndicator(color: AppColors.primaryColor)
            : Text(
                "Send-Code",
                style: Get.textTheme.titleSmall,
              ),
      ),
    );
  }

  Widget _getCodeField() {
    if (Get.isDarkMode) {
      return Expanded(
        flex: 2,
        child: NewCustomTextField(
          hintText: "Code",
          prefixIcon: Icons.code,
          hintStyle: Get.textTheme.bodySmall,
          bgColor: AppColors.fieldBackground,
          controller: _signController.otpCodeController,
          keyboardType: TextInputType.number,
          prefixIconColor: Colors.orange,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              width: 1,
              color: AppColors.fieldBorder,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              width: 2,
              color: AppColors.fieldFocus,
            ),
          ),
        ),
      );
    } else {
      return Expanded(
        flex: 2,
        child: NewCustomTextField(
          hintText: "Code",
          prefixIcon: Icons.code,
          controller: _signController.otpCodeController,
          keyboardType: TextInputType.number,
          bgColor: Colors.grey.shade50,
          prefixIconColor: Colors.orange,
        ),
      );
    }
  }
}

Widget _getEmailFormField(controller) {
  if (Get.isDarkMode) {
    return NewCustomTextField(
      hintStyle: Get.textTheme.bodySmall,
      bgColor: AppColors.fieldBackground,
      prefixIconColor: AppColors.accentOrange400,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          width: 1,
          color: AppColors.fieldBorder,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          width: 2,
          color: AppColors.fieldFocus,
        ),
      ),
      controller: controller.emailController,
      hintText: "Email/Number",
      prefixIcon: Icons.email,
    );
  } else {
    return NewCustomTextField(
      bgColor: Colors.grey.shade50,
      prefixIconColor: Colors.orange,
      controller: controller.emailController,
      hintText: "Email/Number",
      prefixIcon: Icons.email,
    );
  }
}

Widget _getPasswordFormField(RxBool isVsibile, controller) {
  if (Get.isDarkMode) {
    return NewCustomTextField(
      hintStyle: Get.textTheme.bodySmall,
      controller: controller.passwordController,
      hintText: "Password",
      isObscure: isVsibile.value,
      prefixIcon: Icons.lock,
      bgColor: AppColors.fieldBackground,
      prefixIconColor: AppColors.accentOrange400,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          width: 1,
          color: AppColors.fieldBorder,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          width: 2,
          color: AppColors.fieldFocus,
        ),
      ),
      suffixIcon: !isVsibile.value ? Icons.visibility : Icons.visibility_off,
      onSuffixTap: () {
        isVsibile.value = !isVsibile.value;
      },
    );
  } else {
    return NewCustomTextField(
      controller: controller.passwordController,
      hintText: "Password",
      isObscure: isVsibile.value,
      prefixIcon: Icons.lock,
      bgColor: Colors.grey.shade50,
      prefixIconColor: Colors.orange,
      suffixIcon: !isVsibile.value ? Icons.visibility : Icons.visibility_off,
      onSuffixTap: () {
        isVsibile.value = !isVsibile.value;
      },
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
          color: Colors.grey.shade50,
          border: Border.all(color: Colors.grey.shade300),
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
