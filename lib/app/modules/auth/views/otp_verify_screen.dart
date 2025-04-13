import 'package:echodate/app/controller/auth_controller.dart';
import 'package:echodate/app/controller/timer_controller.dart';
import 'package:echodate/app/controller/user_controller.dart';
import 'package:echodate/app/modules/auth/widgets/auth_widgets.dart';
import 'package:echodate/app/resources/colors.dart';
import 'package:echodate/app/widget/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';

// ignore: must_be_immutable
class OTPVerificationScreen extends StatefulWidget {
  String? email;
  String? phoneNumber;
  final VoidCallback onVerifiedCallBack;
  OTPVerificationScreen({
    super.key,
    this.email,
    required this.onVerifiedCallBack,
    this.phoneNumber,
  });

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {});
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
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> changeAuthDetails() async {
    final userController = Get.find<UserController>();
    if (widget.email != null) {
      ContactUpdateBottomSheet.show(
        context: context,
        type: ContactType.email,
        initialValue: widget.email ?? "",
        onSave: (newEmail) async {
          await _authController.changeAuthDetails(
            email: newEmail,
          );
          setState(() {
            widget.email = userController.userModel.value?.email;
          });
        },
      );
    } else if (widget.phoneNumber != null) {
      ContactUpdateBottomSheet.show(
        context: context,
        type: ContactType.phone,
        initialValue: widget.phoneNumber ?? "",
        onSave: (newPhone) async {
          await _authController.changeAuthDetails(
            phoneNumber: newPhone,
          );
          setState(() {
            widget.phoneNumber = userController.userModel.value?.phoneNumber;
          });
        },
      );
    }
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
                opacity: _authController.isOtpVerifyLoading.value ? 0.2 : 1.0,
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
                            "A Verification code has been sent to\n${widget.email ?? widget.phoneNumber}",
                            style: TextStyle(
                              fontSize: 16,
                              color: const Color(0xff000000).withOpacity(0.5),
                              height: 1.1,
                            ),
                          ),
                          const SizedBox(height: 15),
                          widget.email != null || widget.phoneNumber != null
                              ? Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Wrong details?",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: const Color(0xff000000)
                                            .withOpacity(0.5),
                                        height: 1.1,
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        await changeAuthDetails();
                                      },
                                      child: Text(
                                        " Change",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: AppColors.primaryColor,
                                          fontWeight: FontWeight.w600,
                                          decoration: TextDecoration.underline,
                                          height: 1.1,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : const SizedBox(),
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
                                email: widget.email,
                                phoneNumber: widget.phoneNumber,
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
            if (_authController.isOtpVerifyLoading.value)
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
              if (widget.phoneNumber != null &&
                  widget.phoneNumber?.isNotEmpty == true) {
                await _authController.sendNumberOTP();
              } else {
                await _authController.sendOtp();
              }
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

void showUpdateContactBottomSheet(
    BuildContext context, String type, String currentValue) {
  TextEditingController _controller = TextEditingController(
    text: currentValue,
  );

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Update Your $type',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 8,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Enter your new ${type.toLowerCase()}:',
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _controller,
              keyboardType: type == 'Email'
                  ? TextInputType.emailAddress
                  : TextInputType.phone,
              decoration: InputDecoration(
                hintText: type == 'Email'
                    ? 'Enter your email'
                    : 'Enter your phone number',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Add your save functionality here
                    String updatedValue = _controller.text.trim();
                    if (updatedValue.isNotEmpty) {
                      // Save the updated value (e.g., make an API call or update state)
                      Navigator.pop(context);
                    } else {
                      // Show a toast or snackbar for invalid input
                    }
                  },
                  child: Text('Save'),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}
