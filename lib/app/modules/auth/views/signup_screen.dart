import 'package:echodate/app/modules/auth/views/login_screen.dart';
import 'package:echodate/app/widget/custom_button.dart';
import 'package:echodate/app/widget/custom_textfield.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final _emailController = TextEditingController();
  final _phoneNUmberController = TextEditingController();
  final _passwordController = TextEditingController();

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
              CustomTextField(
                controller: _emailController,
                hintText: "Email",
                prefixIcon: Icons.email,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                controller: _phoneNUmberController,
                hintText: "Phone Number",
                prefixIcon: Icons.phone,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                controller: _passwordController,
                hintText: "Password",
                isObscure: true,
                prefixIcon: Icons.lock,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Checkbox(
                    value: true,
                    visualDensity: VisualDensity.compact,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    onChanged: (value) {},
                  ),
                  const Text("I agree to the terms and conditions."),
                ],
              ),
              SizedBox(height: Get.height * 0.05),
              CustomButton(
                ontap: () {},
                child: const Text(
                  "Register",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
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
