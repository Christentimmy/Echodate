import 'package:echodate/app/modules/subscription/views/sub_payment_screen.dart';
import 'package:echodate/app/resources/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "Subscription Plan",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Choose your subscription plan:",
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                ),
                SizedBox(height: Get.height * 0.05),
                SubsCard(
                  title: "Basic Plan",
                  price: "29.99",
                  imagePath: "assets/images/couple.png",
                  features: [
                    _buildFeature("See who likes you"),
                    _buildFeature("Be Seen Faster"),
                    _buildFeature("20 Swipes Per Day"),
                    _buildFeature("5 Priority Messages Daily"),
                  ],
                ),
                SizedBox(height: Get.height * 0.05),
                SubsCard(
                  title: "Budget Plan",
                  price: "59.99",
                  imagePath: "assets/images/couple.png",
                  features: [
                    _buildFeature("See who likes you"),
                    _buildFeature("Be Seen Faster"),
                    _buildFeature("30 Swipes Per Day"),
                    _buildFeature("10 Priority Messages Daily"),
                  ],
                ),
                SizedBox(height: Get.height * 0.05),
                SubsCard(
                  title: "Premium Plan",
                  price: "119.99",
                  imagePath: "assets/images/couple.png",
                  features: [
                    _buildFeature("See who likes you"),
                    _buildFeature("Be Seen Faster"),
                    _buildFeature("30 Swipes Per Day"),
                    _buildFeature("10 Priority Messages Daily"),
                    _buildFeature("Unlock Echome"),
                  ],
                ),
                SizedBox(height: Get.height * 0.05),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeature(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        children: [
          const Icon(
            FontAwesomeIcons.solidSquareCheck,
            color: Colors.white,
          ),
          const SizedBox(width: 10),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class SubsCard extends StatelessWidget {
  final String title;
  final String price;
  final List<Widget> features;
  final String imagePath;

  const SubsCard({
    super.key,
    required this.title,
    required this.price,
    required this.features,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Get.to(()=> SubPaymentScreen(selectedPlan: title));
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.primaryColor,
        ),
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  "GH₵ $price",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    ...features,
                  ],
                ),
                const Spacer(),
                Image.asset(
                  imagePath,
                  width: 80,
                  height: 85,
                  fit: BoxFit.cover,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
