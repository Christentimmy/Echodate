import 'package:echodate/app/widget/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
            validator: (value) {
              if (value!.isEmpty) {
                return "";
              }
              if (!value.contains("@")) {
                return "";
              }
              return null;
            },
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
  final RxString selectedCountryCode;

  const SignUpFormFields({
    super.key,
    required this.emailController,
    required this.phoneNUmberController,
    required this.passwordController,
    required this.formKey,
    required this.selectedCountryCode,
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
          CustomPhoneNumberField(
            phoneNumberController: phoneNUmberController,
            selectedCountryCode: selectedCountryCode,
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
            onTap: (){
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
                  title: Text("${country['name']} (${country['code']})"),
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
              height: 60,
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
