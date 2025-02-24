import 'package:flutter/material.dart';

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
            const Text(
                "Enter the verification code sent to your mobile number."),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                  4, (index) => const SizedBox(width: 50, child: TextField())),
            ),
            const SizedBox(height: 20),
            const Text("Resend Code (30s)"),
          ],
        ),
      ),
    );
  }
}
