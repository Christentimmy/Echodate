
import 'package:echodate/app/modules/auth/views/login_screen.dart';
import 'package:echodate/app/modules/auth/views/signup_screen.dart';
import 'package:echodate/app/resources/colors.dart';
import 'package:echodate/app/widget/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';



class SplashScreen1 extends StatelessWidget {
  const SplashScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () {
      Get.to(
        () => const OnboardingScreen(),
        transition: Transition.fade,
      );
    });

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.orange, Colors.deepOrange],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: const Center(
          child: Text(
            "ECHODATE",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}



class SplashScreen2 extends StatelessWidget {
  const SplashScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () {
      Get.to(() => const OnboardingScreen());
    });

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.orangeAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: const Center(
          child: Text(
            "ECHODATE",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.orange,
            ),
          ),
        ),
      ),
    );
  }
}

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: Get.height * 0.4),
            Image.asset(
              "assets/images/ECHODATE.png",
              width: Get.width * 0.4,
            ),
            const SizedBox(height: 20),
            const Text(
              "Welcome to ECHODATE\nLorem ipsum dolor sit amet, consectetur\nadipiscing elit.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const Spacer(),
            CustomButton(
              ontap: () {
                Get.to(() => LoginScreen());
              },
              bgColor: Colors.transparent,
              border: Border.all(
                color: AppColors.primaryColor,
                width: 1,
              ),
              child: const Text(
                "Login",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.orange,
                ),
              ),
            ),
            const SizedBox(height: 10),
            CustomButton(
              ontap: () {
                Get.to(() =>  RegisterScreen());
              },
              child: const Text(
                "Register",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}