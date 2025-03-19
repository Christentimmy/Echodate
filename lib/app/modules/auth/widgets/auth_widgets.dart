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
          CustomPhoneNumberField(
            phoneNumberController: phoneNUmberController,
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

class CustomPhoneNumberField extends StatefulWidget {
  final TextEditingController phoneNumberController;
  final ValueChanged<String>? onCountryChanged;

  const CustomPhoneNumberField({
    super.key,
    required this.phoneNumberController,
    this.onCountryChanged,
  });

  @override
  State<CustomPhoneNumberField> createState() => _CustomPhoneNumberFieldState();
}

class _CustomPhoneNumberFieldState extends State<CustomPhoneNumberField> {
  String selectedCountryCode = '+234'; // Default to Nigeria

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

  void _showCountryPickerDialog() {
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
                    setState(() {
                      selectedCountryCode = country['code']!;
                    });
                    if (widget.onCountryChanged != null) {
                      widget.onCountryChanged!(selectedCountryCode);
                    }
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: _showCountryPickerDialog,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              height: 60,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                selectedCountryCode,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          flex: 3,
          child: CustomTextField(
            controller: widget.phoneNumberController,
            hintText: "Phone Number",
            prefixIcon: Icons.phone,
            keyboardType: TextInputType.number,
          ),
        ),
      ],
    );
  }
}
