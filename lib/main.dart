import 'package:echodate/resources/colors.dart';
import 'package:echodate/utils/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.robotoTextTheme(),
      ),
      home: SplashScreen1(),
    );
  }
}

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
                Get.to(()=> LoginScreen());
              },
              bgColor: Colors.transparent,
              border: Border.all(
                color: AppColors().primaryColor,
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
                Get.to(()=> RegisterScreen());
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



class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "ECHODATE",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            const SizedBox(height: 20),
            const TextField(
              decoration: InputDecoration(labelText: "Email/ Mobile Number"),
            ),
            const TextField(
              decoration: InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
                child: const Text("Forgot password?"),
              ),
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text("Login", style: TextStyle(fontSize: 18)),
            ),
            const SizedBox(height: 20),
            const Text("OR"),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(onPressed: () {}, icon: const Icon(Icons.g_translate)),
                IconButton(onPressed: () {}, icon: const Icon(Icons.apple)),
              ],
            ),
            TextButton(
              onPressed: () => Get.to(() => const RegisterScreen()),
              child: const Text("Don't have an account? Register"),
            ),
          ],
        ),
      ),
    );
  }
}

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "ECHODATE",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            const SizedBox(height: 20),
            const TextField(decoration: InputDecoration(labelText: "Email")),
            const TextField(decoration: InputDecoration(labelText: "Mobile Number")),
            const TextField(
              decoration: InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            Row(
              children: [
                Checkbox(value: true, onChanged: (value) {}),
                const Text("I agree to the terms and conditions."),
              ],
            ),
            ElevatedButton(
              onPressed: () => Get.to(() => const OTPVerificationScreen()),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text("Register", style: TextStyle(fontSize: 18)),
            ),
            TextButton(
              onPressed: () => Get.to(() => const LoginScreen()),
              child: const Text("Already have an account? Login"),
            ),
          ],
        ),
      ),
    );
  }
}

class OTPVerificationScreen extends StatelessWidget {
  const OTPVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.mail, size: 60, color: Colors.orange),
            const SizedBox(height: 20),
            const Text(
              "Verify Mobile Number",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text("Enter the verification code sent to your mobile number."),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(4, (index) => const SizedBox(width: 50, child: TextField())),
            ),
            const SizedBox(height: 20),
            const Text("Resend Code (30s)"),
          ],
        ),
      ),
    );
  }
}
