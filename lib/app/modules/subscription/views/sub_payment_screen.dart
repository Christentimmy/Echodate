import 'package:echodate/app/controller/user_controller.dart';
import 'package:echodate/app/models/sub_model.dart';
import 'package:echodate/app/modules/subscription/views/subscription_screen.dart';
import 'package:echodate/app/widget/custom_button.dart';
import 'package:echodate/app/widget/loader.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class SubPaymentScreen extends StatelessWidget {
  final SubModel subModel;
  SubPaymentScreen({
    super.key,
    required this.subModel,
  });

  final _userController = Get.find<UserController>();

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
                  "You have selected",
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                ),
                SizedBox(height: Get.height * 0.05),
                SubsCard(
                  title: subModel.title ?? "",
                  price: subModel.price.toString(),
                  imagePath: "assets/images/couple.png",
                  subModel: subModel,
                  features: subModel.features
                          ?.map((e) => _buildFeature(e))
                          .toList() ??
                      [],
                ),
                SizedBox(height: Get.height * 0.05),
                Text(
                  "Payment",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade500,
                  ),
                ),
                SizedBox(height: Get.height * 0.02),
                CustomButton(
                  ontap: _userController.isloading.value
                      ? () {}
                      : () async {
                          await _userController.subscribeToPlan(
                            planId: subModel.id ?? "",
                          );
                        },
                  child: Obx(
                    () => _userController.isloading.value
                        ? const Loader()
                        : const Text(
                            "Pay",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
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
}
