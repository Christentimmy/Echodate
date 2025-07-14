import 'package:echodate/app/controller/auth_controller.dart';
import 'package:echodate/app/modules/auth/controller/signup_controller.dart';
import 'package:echodate/app/modules/auth/views/login_screen.dart';
import 'package:echodate/app/modules/auth/widgets/auth_widgets.dart';
import 'package:echodate/app/resources/colors.dart';
import 'package:echodate/app/utils/validator.dart';
import 'package:echodate/app/widget/custom_button.dart';
import 'package:echodate/app/widget/custom_textfield.dart';
import 'package:echodate/app/widget/loader.dart';
import 'package:echodate/app/widget/snack_bar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpModalWidget extends StatelessWidget {
  SignUpModalWidget({super.key});

  final GlobalKey<FormState> _signUpFormKey = GlobalKey<FormState>();
  final _signUpController = Get.put(SignUpController());
  final _authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      margin: const EdgeInsets.symmetric(
        vertical: 15,
        horizontal: 20,
      ),
      decoration: AppColors.formFieldDecoration,
      child: Stack(
        children: [
          buildBackDrop(),
          getGradientOverlay(),
          _buildSignUpFormWidget(context),
        ],
      ),
    );
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
          const SizedBox(height: 10),
          Form(
            key: _signUpFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NewCustomTextField(
                  prefixIconColor: Colors.orange,
                  controller: _signUpController.emailController,
                  hintText: "Email",
                  prefixIcon: Icons.email,
                  validator: validateEmail,
                ),
                const SizedBox(height: 10),
                Obx(() {
                  RxBool isVisible = _signUpController.isPasswordVisible;
                  return NewCustomTextField(
                    controller: _signUpController.passwordController,
                    hintText: "Password",
                    isObscure: isVisible.value,
                    prefixIcon: Icons.lock,
                    prefixIconColor: Colors.orange,
                    suffixIcon: !isVisible.value
                        ? Icons.visibility
                        : Icons.visibility_off,
                    onSuffixTap: () {
                      isVisible.value = !isVisible.value;
                    },
                  );
                }),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: NewCustomTextField(
                        hintText: "Code",
                        prefixIcon: Icons.code,
                        controller: _signUpController.otpCodeController,
                        keyboardType: TextInputType.number,
                        prefixIconColor: Colors.orange,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 1,
                      child: _getCustomButton(),
                    ),
                  ],
                ),
              ],
            ),
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
                  Get.to(() => const LoginScreen());
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

  Widget _getCustomButton() {
    final isDark = Get.isDarkMode;

    return CustomButton(
      bgColor: isDark ? AppColors.fieldBackground : Colors.transparent,
      border: Border.all(
        width: 1,
        color: isDark ? AppColors.fieldBorder : Colors.grey.shade300,
      ),
      ontap: () async {
        String email = _signUpController.emailController.text.trim();
        if (email.isEmpty) {
          CustomSnackbar.showErrorSnackBar("Email is required");
          return;
        }
        String? errorText = validateEmail(email);
        if (errorText != null) {
          return CustomSnackbar.showErrorSnackBar(errorText);
        }
        await _authController.sendSignUpOtp(email: email);
      },
      child: Obx(
        () => _authController.isSignUpOtpLoading.value
            ? Loader(
                height: 20,
                color: AppColors.primaryColor,
              )
            : Text(
                "Send-Code",
                style: Get.textTheme.titleSmall,
              ),
      ),
    );
  }
}
