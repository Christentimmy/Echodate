import 'dart:math' as math;
import 'package:echodate/app/utils/privacy.dart';
import 'package:echodate/app/utils/terms.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _passwordController = TextEditingController();
  final otpCodeController = TextEditingController();
  late GlobalKey<FormState> _signUpFormKey;
  final _isCheckValue = false.obs;
  final selectedCountryCode = RxString("+233");

  // Animation controllers
  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;

  TextEditingController get emailController => _emailController;
  TextEditingController get phoneNumberController => _phoneNumberController;
  TextEditingController get passwordController => _passwordController;
  GlobalKey<FormState> get signUpFormKey => _signUpFormKey;
  RxBool get isCheckValue => _isCheckValue;
  RxString get countryCode => selectedCountryCode;
  AnimationController get animationController => _animationController;
  Animation<double> get rotationAnimation => _rotationAnimation;

  @override
  void onInit() {
    _signUpFormKey = GlobalKey<FormState>();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    _rotationAnimation =
        Tween<double>(begin: 0, end: 2 * math.pi).animate(_animationController);
    super.onInit();
  }

  void showTermsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Terms & Conditions'),
        content: SingleChildScrollView(
          child: Text(termsAndConditionsText),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void showPrivacyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Privacy Policy'),
        content: SingleChildScrollView(
          child: Text(privacyPolicyText),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void recreateFormKey() {
    _signUpFormKey = GlobalKey<FormState>();
  }

  @override
  void onClose() {
    _emailController.dispose();
    _phoneNumberController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    super.onClose();
  }
}
