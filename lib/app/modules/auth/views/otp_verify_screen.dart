import 'package:echodate/app/controller/auth_controller.dart';
import 'package:echodate/app/controller/timer_controller.dart';
import 'package:echodate/app/resources/colors.dart';
import 'package:echodate/app/widget/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';

class OTPVerificationScreen extends StatefulWidget {
  final String? email;
  final VoidCallback onVerifiedCallBack;
  const OTPVerificationScreen({
    super.key,
    this.email,
    required this.onVerifiedCallBack,
  });

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    _timerController.startTimer();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _timerController.startTimer();
      _animationController = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 5),
      )..repeat();
      _scaleAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Curves.easeInOut,
        ),
      );
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  final _timerController = Get.put(TimerController());
  final _authController = Get.find<AuthController>();
  final _otpController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Obx(() {
        return Stack(
          children: [
            // Main Content
            SafeArea(
              child: Opacity(
                opacity: _authController.isLoading.value ? 0.2 : 1.0,
                child: AbsorbPointer(
                  absorbing: false,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 20,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: Get.height * 0.02),
                          richTextWidget(),
                          const SizedBox(height: 15),
                          Text(
                            "A Verification code has been sent to\n${widget.email}",
                            style: TextStyle(
                              fontSize: 16,
                              color: const Color(0xff000000).withOpacity(0.5),
                              height: 1.1,
                            ),
                          ),
                          SizedBox(height: Get.height * 0.0375),
                          Center(
                            child: Pinput(
                              controller: _otpController,
                              defaultPinTheme: PinTheme(
                                width: 65,
                                height: 65,
                                textStyle: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: const Color(0xffF1F1F1),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: Get.height * 0.0375),
                          CustomButton(
                            text: "Continue",
                            ontap: () async {
                              _authController.verifyOtp(
                                otpCode: _otpController.text,
                                email: widget.email ?? "",
                                whatNext: () {
                                  widget.onVerifiedCallBack();
                                },
                              );
                            },
                          ),
                          SizedBox(height: Get.height * 0.028),
                          resendOtpRow()
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Preloader with Rotation and Bounce
            if (_authController.isLoading.value)
              Padding(
                padding: EdgeInsets.only(bottom: Get.height * 0.1),
                child: Center(
                  child: CircleAvatar(
                    radius: 25,
                    backgroundColor: AppColors.primaryColor,
                    child: CircleAvatar(
                        radius: 23,
                        backgroundColor: Colors.white,
                        child: ScaleTransition(
                          scale: _scaleAnimation,
                          child: RotationTransition(
                            turns: _animationController,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                "assets/images/ECHODATE.png",
                                width: 50, // Reduced size
                                height: 50,
                              ),
                            ),
                          ),
                        )),
                  ),
                ),
              ),
          ],
        );
      }),
    );
  }

  Row resendOtpRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Didn't receive the code? ",
          style: TextStyle(
            fontSize: 16,
            color: const Color(0xff000000).withOpacity(0.5),
          ),
        ),
        Obx(
          () => InkWell(
            onTap: () async {
              _timerController.startTimer();
              await _authController.sendOtp();
            },
            child: _timerController.secondsRemaining.value == 0
                ? Text(
                    "Resend",
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : Text(
                    "(${_timerController.secondsRemaining.value.toString()})",
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  RichText richTextWidget() {
    return RichText(
      text: TextSpan(
        style: GoogleFonts.roboto(
          fontSize: 24,
        ),
        children: [
          const TextSpan(
            text: "Enter your ",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: "OTP",
            style: TextStyle(
              color: AppColors.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: Size(Get.width, 150),
      child: Container(
        height: 150,
        padding: const EdgeInsets.only(top: 45),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color.fromARGB(255, 95, 63, 23),
              AppColors.primaryColor,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () => Get.back(),
              child: Container(
                height: 44,
                width: 44,
                alignment: Alignment.center,
                margin: const EdgeInsets.symmetric(
                  horizontal: 17,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: const Color(0xffFBFBFB),
                ),
                child: const Icon(
                  Icons.arrow_back_ios,
                  size: 14,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
