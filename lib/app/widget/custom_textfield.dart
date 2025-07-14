import 'package:echodate/app/resources/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class CustomTextField extends StatelessWidget {
  TextEditingController? controller;
  int? maxLines;
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
  Function()? onTap;
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
    this.onTap,
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
        onTap: onTap,
        onChanged: onChanged,
        readOnly: readOnly ?? false,
        onEditingComplete: onEditingComplete,
        obscureText: isObscure ?? false,
        cursorColor: AppColors.primaryColor,
        controller: controller,
        keyboardType: keyboardType,
        style: textStyle ??
            const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
        maxLines: maxLines ?? 1,
        decoration: InputDecoration(
          fillColor: bgColor,
          errorText: null,
          errorStyle: const TextStyle(height: 0, fontSize: 0),
          errorMaxLines: null,
          error: null,
          filled: bgColor != null ? true : false,
          counterText: maxLength != null ? "" : null,
          hintText: hintText,
          hintStyle: hintStyle ??
              TextStyle(
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

// ignore: must_be_immutable
class NewCustomTextField extends StatelessWidget {
  TextEditingController? controller;
  int? maxLines;
  FocusNode? focusNode;
  final String hintText;
  TextStyle? hintStyle;
  TextStyle? textStyle;
  IconData? prefixIcon;
  Color? prefixIconColor;
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
  Function()? onTap;
  Widget? prefix;
  NewCustomTextField({
    super.key,
    this.hintStyle,
    this.prefix,
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
    this.onTap,
    this.prefixIconColor,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: fieldHeight,
      child: TextFormField(
        maxLength: maxLength,
        focusNode: focusNode,
        validator: validator ??
            (value) {
              if (value!.isEmpty) {
                return "";
              } else if (errorText?.isNotEmpty == true) {
                return "";
              }
              return null;
            },
        onTap: onTap,
        onChanged: onChanged,
        readOnly: readOnly ?? false,
        onEditingComplete: onEditingComplete,
        obscureText: isObscure ?? false,
        cursorColor: AppColors.primaryColor,
        controller: controller,
        keyboardType: keyboardType,
        style: textStyle ??
            TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Get.theme.primaryColor,
            ),
        maxLines: maxLines ?? 1,
        decoration: InputDecoration(
          fillColor: bgColor ??
              (Get.isDarkMode
                  ? AppColors.fieldBackground
                  : Colors.grey.shade50),
          errorText: null,
          errorStyle: const TextStyle(height: 0, fontSize: 0),
          errorMaxLines: null,
          error: null,
          filled: bgColor != null ? true : false,
          counterText: maxLength != null ? "" : null,
          hintText: hintText,
          hintStyle: hintStyle ?? Get.textTheme.bodySmall,
          prefix: prefix,
          prefixIcon: prefixIcon == null
              ? null
              : Icon(
                  prefixIcon,
                  color: prefixIconColor ?? const Color(0xff36534F),
                ),
          suffixIcon: IconButton(
            onPressed: onSuffixTap,
            icon: Icon(
              suffixIcon,
              size: 20,
              color: Colors.grey.shade600,
            ),
          ),
          enabledBorder: enabledBorder ??
              (Get.isDarkMode
                  ? OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        width: 1,
                        color: AppColors.fieldBorder,
                      ),
                    )
                  : OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        width: 1,
                        color: Colors.grey.shade300,
                      ),
                    )),
          focusedBorder: focusedBorder ??
              (Get.isDarkMode
                  ? OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        width: 2,
                        color: AppColors.fieldFocus,
                      ),
                    )
                  : OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        width: 1,
                        color: AppColors.primaryColor,
                      ),
                    )),
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
