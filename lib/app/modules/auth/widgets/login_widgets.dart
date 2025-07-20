import 'package:echodate/app/modules/auth/controller/login_controller.dart';
import 'package:echodate/app/modules/auth/views/reset_password_screen.dart';
import 'package:echodate/app/modules/auth/views/signup_screen.dart';
import 'package:echodate/app/modules/auth/widgets/auth_widgets.dart';
import 'package:echodate/app/resources/colors.dart';
import 'package:echodate/app/widget/custom_button.dart';
import 'package:echodate/app/widget/custom_textfield.dart';
import 'package:echodate/app/widget/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class LoginModalWidget extends StatelessWidget {
  LoginModalWidget({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _loginController = Get.put(LoginController());

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
          _formFields(),
        ],
      ),
    );
  }

  Widget _formFields() {
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
            key: _formKey,
            child: Column(
              children: [
                NewCustomTextField(
                  prefixIconColor: Colors.orange,
                  controller: _loginController.emailController,
                  hintText: "Email/Number",
                  prefixIcon: Icons.email,
                ),
                const SizedBox(height: 15),
                Obx(() {
                  RxBool isVsibile = _loginController.isPasswordVisible;
                  return NewCustomTextField(
                    controller: _loginController.passwordController,
                    hintText: "Password",
                    isObscure: isVsibile.value,
                    prefixIcon: Icons.lock,
                    prefixIconColor: Colors.orange,
                    suffixIcon: !isVsibile.value
                        ? Icons.visibility
                        : Icons.visibility_off,
                    onSuffixTap: () {
                      isVsibile.value = !isVsibile.value;
                    },
                  );
                }),
                const SizedBox(height: 30),
              ],
            ),
          ),
          CustomButton(
            ontap: () async {
              HapticFeedback.lightImpact();
              FocusManager.instance.primaryFocus?.unfocus();
              if (_formKey.currentState!.validate()) {
                await _loginController.authController.loginUser(
                  identifier: _loginController.emailController.text,
                  password: _loginController.passwordController.text,
                );
              }
            },
            child: Obx(
              () => _loginController.authController.isLoading.value
                  ? const Loader()
                  : const Row(
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
                    ),
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
}
