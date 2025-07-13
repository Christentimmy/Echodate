import 'dart:ui';
import 'package:echodate/app/controller/auth_controller.dart';
import 'package:echodate/app/modules/auth/controller/signup_controller.dart';
import 'package:echodate/app/modules/auth/views/login_screen.dart';
import 'package:echodate/app/modules/auth/widgets/auth_widgets.dart';
import 'package:echodate/app/modules/auth/widgets/bouncing_ball.dart';
import 'package:echodate/app/modules/auth/widgets/rotating_star.dart';
import 'package:echodate/app/modules/auth/widgets/rotation_logo.dart';
import 'package:echodate/app/resources/colors.dart';
import 'package:echodate/app/widget/custom_button.dart';
import 'package:echodate/app/widget/loader.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final _signUpController = Get.put(SignUpController());
  final _authController = Get.put(AuthController());

  final GlobalKey<FormState> _signUpFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor:
          Get.isDarkMode ? AppColors.bgDark900 : AppColors.bgOrange400,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: _getBgGradient(),
            begin: Alignment.topCenter,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(),
              Container(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                margin: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 20,
                ),
                decoration: _getDecoration(),
                child: Stack(
                  children: [
                    _getBackDrop(),
                    _getGradientOverlay(),
                    _buildSignUpFormWidget(context),
                  ],
                ),
              ),
              SizedBox(height: Get.height * 0.08),
              const Text("Join millions finding love every day ❤️"),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _getDecoration() {
    if (!Get.isDarkMode) {
      return BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withOpacity(0.8),
      );
    } else {
      return BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppColors.glassDark,
        border: Border.all(
          color: AppColors.fieldBorder,
          width: 1,
        ),
      );
    }
  }

  Padding _buildSignUpFormWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 20,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Create Account",
            style: Get.textTheme.headlineMedium,
          ),
          const SizedBox(height: 2),
          Text(
            "Fill the details to get started",
            style: Get.textTheme.bodySmall,
          ),
          const SizedBox(height: 15),
          Form(
            key: _signUpFormKey,
            child: SignUpFormFields(),
          ),
          const SizedBox(height: 20),
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
                    style: TextStyle(color: Get.theme.primaryColor),
                    children: [
                      const TextSpan(text: 'I agree to the '),
                      TextSpan(
                        text: 'Terms & Conditions',
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap =
                              () => _signUpController.showTermsDialog(context),
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
          const SizedBox(height: 25),
          Obx(() {
            return CustomButton(
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
                await _signUpController.signUp(_signUpFormKey);
              },
              child: _authController.isLoading.value
                  ? const Loader()
                  : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Create Account",
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
                    ),
            );
          }),

          const SizedBox(height: 20),

          // Login Link
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 4,
            children: [
              const Text("Already have an account? "),
              InkWell(
                onTap: () {
                  Get.to(() => LoginScreen());
                },
                child: const Text(
                  "Sign In",
                  style: TextStyle(
                    color: Colors.orange,
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

  Stack _buildHeader() {
    return Stack(
      children: [
        Column(
          children: [
            SizedBox(height: Get.height * 0.1),
            const Center(child: RotatingImage()),
            SizedBox(height: Get.height * 0.03),
            Center(
              child: Text(
                "Join EchoDate",
                style: Get.textTheme.headlineLarge,
              ),
            ),
            Center(
              child: Text(
                "Start your love story today",
                style: Get.textTheme.headlineSmall,
              ),
            ),
          ],
        ),
        Positioned(
          bottom: Get.height * 0.06,
          left: Get.width * 0.18,
          child: const BouncingBallWidget(),
        ),
        Positioned(
          top: Get.height * 0.18,
          right: Get.width * 0.2,
          child: const RotatingStarWidget(),
        ),
      ],
    );
  }

  Widget _getBackDrop() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(color: Colors.transparent),
      ),
    );
  }

  Widget _getGradientOverlay() {
    if (!Get.isDarkMode) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.transparent,
              Colors.pink.withOpacity(0.05),
            ],
          ),
        ),
      );
    } else {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.transparent,
              AppColors.accentOrange400.withOpacity(0.05),
            ],
          ),
        ),
      );
    }
  }

  List<Color> _getBgGradient() {
    if (Get.isDarkMode) {
      return [
        AppColors.bgDark800,
        AppColors.bgDark700,
        AppColors.bgDark900,
      ];
    } else {
      return [
        AppColors.bgOrange100,
        AppColors.bgOrange200,
        AppColors.bgOrange400,
      ];
    }
  }
}
