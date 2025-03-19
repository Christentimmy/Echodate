import 'package:echodate/app/controller/user_controller.dart';
import 'package:echodate/app/models/sub_model.dart';
import 'package:echodate/app/modules/subscription/views/sub_payment_screen.dart';
import 'package:echodate/app/resources/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  final _userController = Get.find<UserController>();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_userController.isSubscriptionPlansFetched.value) {
        _userController.getSubscriptionPlans();
      }
    });
  }

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
                Obx(() {
                  if (_userController.isloading.value) {
                    return SizedBox(
                      height: Get.height * 0.55,
                      width: Get.width,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primaryColor,
                        ),
                      ),
                    );
                  }
                  if (_userController.allSubscriptionPlanList.isEmpty) {
                    return SizedBox(
                      height: Get.height * 0.55,
                      width: Get.width,
                      child: const Center(
                        child: Text("Empty"),
                      ),
                    );
                  }
                  if (_userController.userModel.value?.plan != "free") {
                    final subModel =
                        subscriptionMap[_userController.userModel.value?.plan];

                    return SubsCard(
                      title: subModel?.title ?? "",
                      price: subModel?.price.toString() ?? "",
                      imagePath: "assets/images/couple.png",
                      subModel: subModel ?? SubModel(),
                      features: subModel?.features
                              ?.map((e) => _buildFeature(e))
                              .toList() ??
                          [],
                    );
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _userController.allSubscriptionPlanList.length,
                    itemBuilder: (context, index) {
                      final subModel =
                          _userController.allSubscriptionPlanList[index];
                      return InkWell(
                        onTap: () {
                          Get.to(
                            () => SubPaymentScreen(subModel: subModel),
                          );
                        },
                        child: SubsCard(
                          title: subModel.title ?? "",
                          price: subModel.price.toString(),
                          imagePath: "assets/images/couple.png",
                          subModel: subModel,
                          features: subModel.features
                              ?.map((e) => _buildFeature(e))
                              .toList() ?? [],
                        ),
                      );
                    },
                  );
                }),
                SizedBox(height: Get.height * 0.05),
              ],
            ),
          ),
        ),
      ),
    );
  }

  final Map<String, SubModel> subscriptionMap = {
    "basic": SubModel(
      id: "basic",
      title: "Basic Plan",
      price: 9.99,
      durationDays: 30,
      features: [
        "See who likes you",
        "Be Seen Faster",
        "40 Swipes Per Day",
        "5 Priority Messages Daily",
      ],
    ),
    "budget": SubModel(
      id: "budget",
      title: "Budget Plan",
      price: 24.99,
      durationDays: 30,
      features: [
        "See who likes you",
        "Be Seen Faster",
        "80 Swipes Per Day",
        "10 Priority Messages Daily",
      ],
    ),
    "premium": SubModel(
      id: "premium",
      title: "Premium Plan",
      price: 59.99,
      durationDays: 30,
      features: [
        "See who likes you",
        "Be Seen Faster",
        "Unlimited Swipes",
        "10 Priority Messages Daily",
        "Unlock Echome",
      ],
    ),
  };

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
  final SubModel subModel;

  const SubsCard({
    super.key,
    required this.title,
    required this.price,
    required this.features,
    required this.imagePath,
    required this.subModel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColors.primaryColor,
      ),
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.symmetric(vertical: 10),
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
    );
  }
}
