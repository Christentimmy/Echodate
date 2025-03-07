import 'package:echodate/app/widget/custom_textfield.dart';
import 'package:flutter/material.dart';

class LoginFormField extends StatelessWidget {
  const LoginFormField({
    super.key,
    required GlobalKey<FormState> formKey,
    required TextEditingController emailController,
    required TextEditingController passwordController,
  })  : _formKey = formKey,
        _emailController = emailController,
        _passwordController = passwordController;

  final GlobalKey<FormState> _formKey;
  final TextEditingController _emailController;
  final TextEditingController _passwordController;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          CustomTextField(
            controller: _emailController,
            hintText: "Email",
            prefixIcon: Icons.email,
          ),
          const SizedBox(height: 10),
          CustomTextField(
            controller: _passwordController,
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
            keyboardType: TextInputType.number,
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
