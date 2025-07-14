import 'package:echodate/app/modules/auth/widgets/bouncing_ball.dart';
import 'package:echodate/app/modules/auth/widgets/rotating_star.dart';
import 'package:echodate/app/modules/auth/widgets/rotation_logo.dart';
import 'package:echodate/app/modules/auth/widgets/signup_widget.dart';
import 'package:echodate/app/resources/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.loginSignUpBg,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: AppColors.authGradientColors,
            begin: Alignment.topCenter,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(),
              SignUpModalWidget(),
              SizedBox(height: Get.height * 0.08),
              const Text("Join millions finding love every day ❤️"),
            ],
          ),
        ),
      ),
    );
  }

  Stack _buildHeader() {
    return Stack(
      children: [
        Column(
          children: [
            SizedBox(height: Get.height * 0.1),
            const Center(child: RotatingImage()),
            SizedBox(height: Get.height * 0.03),
            Center(
              child: Text(
                "Join EchoDate",
                style: Get.textTheme.headlineLarge,
              ),
            ),
            Center(
              child: Text(
                "Start your love story today",
                style: Get.textTheme.headlineSmall,
              ),
            ),
          ],
        ),
        Positioned(
          bottom: Get.height * 0.06,
          left: Get.width * 0.18,
          child: const BouncingBallWidget(),
        ),
        Positioned(
          top: Get.height * 0.18,
          right: Get.width * 0.2,
          child: const RotatingStarWidget(),
        ),
      ],
    );
  }
}
