import 'dart:ui';
import 'package:echodate/app/modules/auth/controller/login_controller.dart';
import 'package:echodate/app/modules/auth/widgets/bouncing_ball.dart';
import 'package:echodate/app/modules/auth/widgets/rotating_star.dart';
import 'package:echodate/app/modules/auth/widgets/rotation_logo.dart';
import 'package:echodate/app/resources/colors.dart';
import 'package:echodate/app/widget/custom_button.dart';
import 'package:echodate/app/widget/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AltLoginScreen extends StatefulWidget {
  const AltLoginScreen({super.key});

  @override
  State<AltLoginScreen> createState() => _AltLoginScreenState();
}

class _AltLoginScreenState extends State<AltLoginScreen> {
  @override
  void initState() {
    Get.put(LoginController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: Column(
              children: [
                SizedBox(
                  height: Get.height * 0.34,
                  width: Get.width,
                  child: Stack(
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
                  ),
                ),
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
                      // Backdrop blur
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                          child: Container(color: Colors.transparent),
                        ),
                      ),
                      // Gradient overlay
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              // Colors.orange.withOpacity(0.05), // orange-500/10
                              Colors.transparent,
                              Colors.pink.withOpacity(0.05), // pink-500/10
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 20,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // const SizedBox(height: 20),
                            const Text(
                              "Sign In",
                              style: TextStyle(
                                fontSize: 23,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              "Enter your credentials to continue",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 15),
                            NewCustomTextField(
                              hintText: "Email",
                              prefixIcon: Icons.email,
                              bgColor: Colors.grey.shade50,
                              prefixIconColor: Colors.orange,
                            ),
                            const SizedBox(height: 15),
                            NewCustomTextField(
                              hintText: "Password",
                              prefixIcon: Icons.lock,
                              bgColor: Colors.grey.shade50,
                              prefixIconColor: Colors.orange,
                            ),
                            const SizedBox(height: 30),
                            CustomButton(
                              ontap: () {},
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Sign in",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Icon(
                                    Icons.arrow_forward,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                            // LoginFormField(),
                            const SizedBox(height: 6),
                            const Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                "Forgot your password?",
                                style: TextStyle(
                                  color: Colors.orange,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            // const Spacer(),
                            SizedBox(height: Get.height * 0.1),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "New to EchoDate? ",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13,
                                    // fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "Create account",
                                  style: TextStyle(
                                    color: Colors.orange,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // const SizedBox(height: 2),
                const Text("Join millions finding love every day ❤️"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
