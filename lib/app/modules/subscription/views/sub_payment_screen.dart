import 'package:echodate/app/modules/subscription/views/subscription_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class SubPaymentScreen extends StatelessWidget {
  final String selectedPlan;

  SubPaymentScreen({super.key, required this.selectedPlan});

  @override
  Widget build(BuildContext context) {
    final selectedPlanDetails = _selectedPan[selectedPlan];

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
                  "You have selected",
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                ),
                SizedBox(height: Get.height * 0.05),
                if (selectedPlanDetails != null) selectedPlanDetails,
                SizedBox(height: Get.height * 0.05),
                Text(
                  "Choose Payment methods",
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                ),
                SizedBox(height: Get.height * 0.02),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: const Color.fromARGB(255, 243, 251, 255),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 2,
                        spreadRadius: 1.0,
                        offset: const Offset(0.0, 2.0),
                      )
                    ],
                  ),
                  child: ListTile(
                    onTap: () {},
                    contentPadding: const EdgeInsets.all(5),
                    leading: const CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.white,
                      child: FaIcon(FontAwesomeIcons.stripe),
                    ),
                    title: const Text(
                      "Stripe",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: Get.height * 0.02),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: const Color.fromARGB(255, 243, 251, 255),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 2,
                        spreadRadius: 1.0,
                        offset: const Offset(0.0, 2.0),
                      )
                    ],
                  ),
                  child: ListTile(
                    onTap: () {},
                    contentPadding: const EdgeInsets.all(5),
                    leading: const CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.white,
                      child: FaIcon(FontAwesomeIcons.creditCard),
                    ),
                    title: const Text(
                      "Momo",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Make _buildFeature static
  static Widget _buildFeature(String text) {
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

  // Initialize _selectedPan using the static _buildFeature
  final Map<String, Widget> _selectedPan = {
    "Basic Plan": SubsCard(
      title: "Basic Plan",
      price: "9.99",
      imagePath: "assets/images/couple.png",
      features: [
        _buildFeature("See who likes you"),
        _buildFeature("Be Seen Faster"),
        _buildFeature("20 Swipes Per Day"),
        _buildFeature("5 Priority Messages Daily"),
      ],
    ),
    "Budget Plan": SubsCard(
      title: "Budget Plan",
      price: "19.99",
      imagePath: "assets/images/couple.png",
      features: [
        _buildFeature("See who likes you"),
        _buildFeature("Be Seen Faster"),
        _buildFeature("30 Swipes Per Day"),
        _buildFeature("10 Priority Messages Daily"),
      ],
    ),
    "Premium Plan": SubsCard(
      title: "Premium Plan",
      price: "29.99",
      imagePath: "assets/images/couple.png",
      features: [
        _buildFeature("See who likes you"),
        _buildFeature("Be Seen Faster"),
        _buildFeature("30 Swipes Per Day"),
        _buildFeature("10 Priority Messages Daily"),
        _buildFeature("Unlock Echome"),
      ],
    ),
  };
}
