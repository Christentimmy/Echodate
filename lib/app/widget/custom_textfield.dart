
import 'package:echodate/app/resources/colors.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  IconData? prefixIcon;
  IconData? suffixIcon;
  VoidCallback? onSuffixTap;
  bool? isObscure;
  Color? bgColor;
  String? Function(String?)? validator;
  double? fieldHeight;
  Function(String)? onChanged;
  Function()? onEditingComplete;
  bool? readOnly;
  TextInputType? keyboardType;
  int? maxLength;
  String? errorText;
  CustomTextField({
    super.key,
    this.onChanged,
    this.errorText,
    required this.controller,
    this.prefixIcon,
    this.suffixIcon,
    this.bgColor,
    this.onSuffixTap,
    this.isObscure,
    required this.hintText,
    this.fieldHeight,
    this.validator,
    this.readOnly,
    this.onEditingComplete,
    this.keyboardType,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLength: maxLength,
      validator: validator ??
          (value) {
            if (value!.isEmpty) {
              return "";
            }else if(errorText?.isNotEmpty ==  true){
              return  "";
            }
            return null;
          },
      onChanged: onChanged,
      readOnly: readOnly ?? false,
      onEditingComplete: onEditingComplete,
      obscureText: isObscure ?? false,
      cursorColor: AppColors.primaryColor,
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        counterText: maxLength != null ? "" : null,
        hintText: hintText,
        hintStyle: TextStyle(
          fontSize: 14,
          color: const Color(0xff000000).withOpacity(0.25),
        ),
        prefixIcon: prefixIcon == null
            ? null
            : Icon(prefixIcon, color: const Color(0xff36534F)),
        suffixIcon: IconButton(
          onPressed: onSuffixTap,
          icon: Icon(suffixIcon, size: 20, color: const Color(0xff36534F)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            width: 1,
            color: AppColors.textFormFieldBgColor,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:  BorderSide(
            width: 1,
            color: AppColors.primaryColor,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            width: 1,
            color: Colors.red,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            width: 1,
            color: Colors.red,
          ),
        ),
      ),
    );
  }
}