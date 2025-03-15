import 'package:echodate/app/controller/user_controller.dart';
import 'package:echodate/app/modules/echocoin/widget/echo_coin_widgets.dart';
import 'package:echodate/app/resources/colors.dart';
import 'package:echodate/app/widget/custom_button.dart';
import 'package:echodate/app/widget/loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllEchoCoinsScreen extends StatefulWidget {
  const AllEchoCoinsScreen({super.key});

  @override
  State<AllEchoCoinsScreen> createState() => _AllEchoCoinsScreenState();
}

class _AllEchoCoinsScreenState extends State<AllEchoCoinsScreen> {
  final _userController = Get.find<UserController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      int? balance = (await _userController.getEchoCoinBalance());
      print(balance);
      if (balance != null) {
        _balance.value = balance;
      }
      if (!_userController.isEchoCoinsListFetched.value) {
        _userController.getAllEchoCoins();
      }
    });
  }

  final RxInt _balance = 0.obs;
  final RxString _selectedCoinPackage = "".obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        elevation: 0,
        title: const Text(
          "Get Coins",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: const Icon(Icons.info_outline, color: Colors.black),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Coin balance",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFFFFD700),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.music_note,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Obx(
                                () => Text(
                                  _balance.value.toString(),
                                  style: const TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      "Recharge",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),
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
                      if (_userController.allEchoCoins.isEmpty) {
                        return SizedBox(
                          height: Get.height * 0.55,
                          width: Get.width,
                          child: const Center(
                            child: Text(
                              "No coins found",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        );
                      }
                      return BuildCoinGridWidget(
                        selectedCoinPackage: _selectedCoinPackage,
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),

          // Bottom recharge button
          SafeArea(
            minimum: const EdgeInsets.all(16),
            child: CustomButton(
              ontap: _userController.isPaymentProcessing.value
                  ? () {}
                  : () async {
                      await _userController.buyCoin(
                        coinPackageId: _selectedCoinPackage.value,
                      );
                    },
              child: Obx(
                () => _userController.isPaymentProcessing.value
                    ? const Loader()
                    : const Text(
                        "Recharge",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
