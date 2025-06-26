import 'package:echodate/app/modules/auth/widgets/auth_widgets.dart';
import 'package:echodate/app/modules/auth/widgets/bouncing_ball.dart';
import 'package:echodate/app/modules/auth/widgets/rotating_star.dart';
import 'package:echodate/app/modules/auth/widgets/rotation_logo.dart';
import 'package:echodate/app/resources/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.bgOrange400,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              // AppColors.bgOrange50,
              AppColors.bgOrange100,
              AppColors.bgOrange200,
              AppColors.bgOrange400,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(),
              Container(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                margin: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 20,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white.withOpacity(0.8),
                ),
                child: Stack(
                  children: [
                    buildBackDrop(),
                    buildGradientOverlay(),
                    LoginFormField(),
                  ],
                ),
              ),
              SizedBox(height: Get.height * 0.12),
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
            SizedBox(height: Get.height * 0.12),
            const Center(child: RotatingImage()),
            SizedBox(height: Get.height * 0.04),
            Center(
              child: Text(
                "Welcome Back",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.bgOrange800,
                ),
              ),
            ),
            Center(
              child: Text(
                "Continue your love story",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.bgOrange600,
                ),
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
          top: Get.height * 0.2,
          right: Get.width * 0.2,
          child: const RotatingStarWidget(),
        ),
      ],
    );
  }
}
