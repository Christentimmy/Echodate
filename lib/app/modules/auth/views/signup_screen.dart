import 'package:echodate/app/controller/auth_controller.dart';
import 'package:echodate/app/models/user_model.dart';
import 'package:echodate/app/modules/auth/views/login_screen.dart';
import 'package:echodate/app/modules/auth/widgets/auth_widgets.dart';
import 'package:echodate/app/resources/colors.dart';
import 'package:echodate/app/widget/custom_button.dart';
import 'package:echodate/app/widget/loader.dart';
import 'package:echodate/app/widget/snack_bar.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final _emailController = TextEditingController();
  final _phoneNUmberController = TextEditingController();
  final _passwordController = TextEditingController();
  final _signUpFormKey = GlobalKey<FormState>();
  final _isCheckValue = false.obs;
  final _authController = Get.find<AuthController>();
  final selectedCountryCode = RxString("");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
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
                "Fill the following essential details to getting registered.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 20),
              SignUpFormFields(
                formKey: _signUpFormKey,
                emailController: _emailController,
                phoneNUmberController: _phoneNUmberController,
                passwordController: _passwordController,
                selectedCountryCode: selectedCountryCode,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Obx(
                    () => Checkbox(
                      value: _isCheckValue.value,
                      visualDensity: VisualDensity.compact,
                      activeColor: AppColors.primaryColor,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      onChanged: (value) {
                        _isCheckValue.value = value!;
                      },
                    ),
                  ),
                  const Text("I agree to the terms and conditions."),
                ],
              ),
              SizedBox(height: Get.height * 0.05),
              CustomButton(
                ontap: () async {
                  FocusManager.instance.primaryFocus?.unfocus();
                  if (!_signUpFormKey.currentState!.validate()) {
                    return;
                  }
                  if (!_isCheckValue.value) {
                    CustomSnackbar.showErrorSnackBar(
                      "Accept our terms and condition",
                    );
                    return;
                  }
                  if (selectedCountryCode.value.isEmpty) {
                    CustomSnackbar.showErrorSnackBar(
                      "Select your country code",
                    );
                    return;
                  }
                  final userModel = UserModel(
                    email: _emailController.text,
                    phoneNumber: "$selectedCountryCode${_phoneNUmberController.text}",
                    password: _passwordController.text,
                  );
                  await _authController.signUpUSer(userModel: userModel);
                  // Get.to(
                  //   () => OTPVerificationScreen(
                  //     onVerifiedCallBack: () {
                  //       Get.to(() => CompleteProfileScreen());
                  //     },
                  //   ),
                  // );
                },
                child: Obx(
                  () => _authController.isLoading.value
                      ? const Loader()
                      : const Text(
                          "Register",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
              SizedBox(height: Get.height * 0.1),
              TextButton(
                onPressed: () => Get.to(() => LoginScreen()),
                child: const Text("Already have an account? Login"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
