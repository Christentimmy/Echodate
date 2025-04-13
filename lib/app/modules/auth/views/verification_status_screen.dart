import 'package:echodate/app/controller/auth_controller.dart';
import 'package:echodate/app/controller/user_controller.dart';
import 'package:echodate/app/modules/auth/views/otp_verify_screen.dart';
import 'package:echodate/app/modules/profile/views/complete_profile_screen.dart';
import 'package:echodate/app/widget/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VerificationStatusScreen extends StatefulWidget {
  final VoidCallback? callback;
  const VerificationStatusScreen({super.key, this.callback});

  @override
  State<VerificationStatusScreen> createState() =>
      _VerificationStatusScreenState();
}

class _VerificationStatusScreenState extends State<VerificationStatusScreen> {
  final _userController = Get.find<UserController>();
  final _authController = Get.find<AuthController>();
  RxBool isloading = false.obs;

  @override
  void initState() {
    getUserDetails();
    super.initState();
  }

  void getUserDetails() async {
    await _userController.getUserDetails();
  }

  Future<void> checkUSer() async {
    isloading.value = true;
    try {
      await _userController.getUserDetails();
      final userModel = _userController.userModel.value;
      if (userModel == null) return;
      if (userModel.isEmailVerified == false ||
          userModel.isPhoneNumberVerified == false) {
        CustomSnackbar.showErrorSnackBar(
          "Please verify your email and phone number before proceeding.",
        );
        return;
      }
      if (widget.callback != null) {
        widget.callback!();
        return;
      }
      Get.offAll(() => CompleteProfileScreen());
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isloading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                width: 480,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: const BoxDecoration(
                        color: Color(0xFFFF8C00),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Verification Status',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    // Content
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          // Email Verification Item
                          Obx(
                            () => VerificationItem(
                              icon: Icons.email_outlined,
                              label: 'Email Address',
                              value:
                                  _userController.userModel.value?.email ?? "",
                              isVerified: _userController
                                      .userModel.value?.isEmailVerified ??
                                  false,
                              onVerify: () async {
                                Get.to(() => OTPVerificationScreen(
                                    email:
                                        _userController.userModel.value?.email,
                                    onVerifiedCallBack: () async {
                                      await _userController.getUserDetails();
                                      Get.back();
                                    }));
                                await _authController.sendOtp();
                              },
                            ),
                          ),

                          const SizedBox(height: 8),

                          // Phone Verification Item
                          Obx(
                            () => VerificationItem(
                              icon: Icons.phone_outlined,
                              label: 'Phone Number',
                              value: _userController
                                      .userModel.value?.phoneNumber ??
                                  "",
                              isVerified: _userController
                                      .userModel.value?.isPhoneNumberVerified ??
                                  false,
                              onVerify: () async {
                                Get.to(() => OTPVerificationScreen(
                                    phoneNumber: _userController
                                        .userModel.value?.phoneNumber,
                                    onVerifiedCallBack: () async {
                                      await _userController.getUserDetails();
                                      Get.back();
                                    }));
                                await _authController.sendNumberOTP();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Footer
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        border: Border(
                          top: BorderSide(color: Color(0xFFEEEEEE)),
                        ),
                      ),
                      child: ElevatedButton(
                        onPressed: () async {
                          await checkUSer();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF8C00),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: Obx(
                          () => isloading.value
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text(
                                  'Done',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class VerificationItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isVerified;
  final VoidCallback onVerify;

  const VerificationItem({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.isVerified,
    required this.onVerify,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFEEEEEE)),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xFFFF8C00).withOpacity(0.1),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Icon(
              icon,
              color: const Color(0xFFFF8C00),
              size: 24,
            ),
          ),

          const SizedBox(width: 16),

          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF555555),
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: isVerified
                        ? const Color(0xFF00AA00).withOpacity(0.1)
                        : const Color(0xFFFF8C00).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    isVerified ? 'Verified' : 'Not Verified',
                    style: TextStyle(
                      color: isVerified
                          ? const Color(0xFF00AA00)
                          : const Color(0xFFFF8C00),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (!isVerified) ...[
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: onVerify,
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFFFF8C00),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: const Text(
                      'Verify Now',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
