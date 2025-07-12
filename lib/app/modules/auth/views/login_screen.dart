import 'dart:ui';
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
      backgroundColor:
          Get.isDarkMode ? AppColors.bgDark900 : AppColors.bgOrange400,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: _getBgGradient(),
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
                decoration: _getDecoration(),
                child: Stack(
                  children: [
                    _getBackDrop(),
                    _getGradientOverlay(),
                    LoginFormField(),
                  ],
                ),
              ),
              SizedBox(height: Get.height * 0.12),
              Text(
                "Join millions finding love every day ❤️",
                style: TextStyle(
                  color: Get.theme.primaryColor,
                ),
              ),
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
                style: Get.textTheme.headlineLarge,
              ),
            ),
            Center(
              child: Text(
                "Continue your love story",
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
          top: Get.height * 0.2,
          right: Get.width * 0.2,
          child: const RotatingStarWidget(),
        ),
      ],
    );
  }

  List<Color> _getBgGradient() {
    if (Get.isDarkMode) {
      return [
        AppColors.bgDark800,
        AppColors.bgDark700,
        AppColors.bgDark900,
      ];
    } else {
      return [
        AppColors.bgOrange100,
        AppColors.bgOrange200,
        AppColors.bgOrange400,
      ];
    }
  }

  BoxDecoration _getDecoration() {
    if (!Get.isDarkMode) {
      return BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withOpacity(0.8),
      );
    } else {
      return BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppColors.glassDark,
        border: Border.all(
          color: AppColors.fieldBorder,
          width: 1,
        ),
      );
    }
  }

  Widget _getBackDrop() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(color: Colors.transparent),
      ),
    );
  }

  Widget _getGradientOverlay() {
    if (!Get.isDarkMode) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.transparent,
              Colors.pink.withOpacity(0.05),
            ],
          ),
        ),
      );
    } else {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.transparent,
              AppColors.accentOrange400.withOpacity(0.05),
            ],
          ),
        ),
      );
    }
  }
}
