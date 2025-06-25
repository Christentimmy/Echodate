import 'dart:math' as math;
import 'package:echodate/app/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authController = Get.find<AuthController>();
  late GlobalKey<FormState> _formKey;
  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;

  TextEditingController get emailController => _emailController;
  TextEditingController get passwordController => _passwordController;
  AuthController get authController => _authController;
  GlobalKey<FormState> get formKey => _formKey;
  AnimationController get animationController => _animationController;
  Animation<double> get rotationAnimation => _rotationAnimation;

  @override
  void onInit() {
    _formKey = GlobalKey<FormState>();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    _rotationAnimation = Tween<double>(begin: 0, end: 2 * math.pi).animate(
      _animationController,
    );

    super.onInit();
  }

  void recreateFormKey() {
    _formKey = GlobalKey<FormState>();
  }

  void clean() {
    _emailController.clear();
    _passwordController.clear();
  }

  @override
  void onClose() {
    _emailController.clear();
    _passwordController.clear();
    _animationController.dispose();
    super.onClose();
  }
}
