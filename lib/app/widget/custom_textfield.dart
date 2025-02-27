import 'package:echodate/app/resources/colors.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomTextField extends StatelessWidget {
  TextEditingController? controller;
  int? maxLines = 1;
  final String hintText;
  TextStyle? hintStyle;
  TextStyle? textStyle;
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
  InputBorder? focusedBorder;
  InputBorder? enabledBorder;
  CustomTextField({
    super.key,
    this.hintStyle,
    this.maxLines,
    this.focusedBorder,
    this.enabledBorder,
    this.onChanged,
    this.errorText,
    this.controller,
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
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: fieldHeight,
      child: TextFormField(
        maxLength: maxLength,
        validator: validator ??
            (value) {
              if (value!.isEmpty) {
                return "";
              } else if (errorText?.isNotEmpty == true) {
                return "";
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
        style: textStyle,
        maxLines: maxLines,
        decoration: InputDecoration(
          fillColor: bgColor,
          filled:  bgColor != null ? true : false,
          counterText: maxLength != null ? "" : null,
          hintText: hintText,
          hintStyle: hintStyle ?? TextStyle(
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
          enabledBorder: enabledBorder ??
              OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  width: 1,
                  color: AppColors.textFormFieldBgColor,
                ),
              ),
          focusedBorder: focusedBorder ??
              OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
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
      ),
    );
  }
}
