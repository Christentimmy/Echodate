import 'package:echodate/app/widget/custom_textfield.dart';
import 'package:flutter/material.dart';

class SignUpFormFields extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController phoneNUmberController;
  final TextEditingController passwordController;
  final GlobalKey<FormState> formKey;
  const SignUpFormFields({
    super.key,
    required this.emailController,
    required this.phoneNUmberController,
    required this.passwordController,
    required this.formKey,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextField(
            controller: emailController,
            hintText: "Email",
            prefixIcon: Icons.email,
          ),
          const SizedBox(height: 20),
          CustomTextField(
            controller: phoneNUmberController,
            hintText: "Phone Number",
            prefixIcon: Icons.phone,
          ),
          const SizedBox(height: 20),
          CustomTextField(
            controller: passwordController,
            hintText: "Password",
            isObscure: true,
            prefixIcon: Icons.lock,
          ),
        ],
      ),
    );
  }
}
