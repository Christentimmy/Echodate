import 'package:echodate/app/controller/user_controller.dart';
import 'package:echodate/app/modules/withdraw/views/add_bank_screen.dart';
import 'package:echodate/app/resources/colors.dart';
import 'package:echodate/app/widget/custom_button.dart';
import 'package:echodate/app/widget/loader.dart';
import 'package:echodate/app/widget/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class WithdrawalScreen extends StatefulWidget {
  const WithdrawalScreen({super.key});

  @override
  State<WithdrawalScreen> createState() => _WithdrawalScreenState();
}

class _WithdrawalScreenState extends State<WithdrawalScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_userController.isAllLinkedBankFetched.value) {
        // coins.value =
        //     _userController.userModel.value?.echocoinsBalance.toString() ?? "";
        _userController.fetchAllLinkedBanks();
      }
    });
  }

  // final _coinController = TextEditingController();
  final _userController = Get.find<UserController>();
  final RxInt selectedIndex = (-1).obs;
  final RxString recipientCode = "".obs;
  final RxString coins = "".obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: Get.height * 0.3,
              child: Stack(
                children: [
                  Container(
                    height: Get.height * 0.27,
                    color: AppColors.primaryColor,
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () => Get.back(),
                              icon: const Icon(
                                Icons.arrow_back_ios,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 5),
                            const Text(
                              'Withdraw',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: Get.height * 0.035),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
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
                                _userController
                                        .userModel.value?.echocoinsBalance
                                        .toString() ??
                                    "",
                                style: const TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Obx(() {
                              if (coins.isEmpty) {
                                return const SizedBox.shrink();
                              }
                              int coinBalance = _userController
                                      .userModel.value?.echocoinsBalance ??
                                  0;
                              num enteredCoins = num.tryParse(coins.value) ?? 0;
                              if (enteredCoins > coinBalance) {
                                coins.value = "";
                                return const Text(
                                  "Insufficient ECHO Coins",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                  ),
                                );
                              }
                              num price = int.parse(coins.value);
                              return Text(
                                "GHS ${price.toStringAsFixed(2)}",
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              );
                            }),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: Get.width * 0.6,
                      height: 55,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: TextFormField(
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        onChanged: (value) {
                          coins.value = value;
                        },
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: 'Enter your text here',
                          hintStyle: TextStyle(
                            fontSize: 14,
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 15.0),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: Get.height * 0.02),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        "Choose bank account",
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: () {
                          Get.to(() => const AddBankScreen());
                        },
                        child: const Text(
                          "Add new",
                          style: TextStyle(
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    height: Get.height * 0.4,
                    width: Get.width,
                    child: Obx(() {
                      if (_userController.isloading.value) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primaryColor,
                          ),
                        );
                      }
                      if (_userController.allLinkedBanks.isEmpty) {
                        return const Center(
                          child: Text(
                            "No linked bank accounts found",
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        );
                      }
                      return ListView.builder(
                        itemCount: _userController.allLinkedBanks.length,
                        itemBuilder: (context, index) {
                          final bankAccount =
                              _userController.allLinkedBanks[index];
                          return GestureDetector(
                            onTap: () {
                              selectedIndex.value = index;
                              recipientCode.value =
                                  bankAccount.recipientCode ?? "";
                            },
                            child: Obx(
                              () => Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 5.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    color: selectedIndex.value == index
                                        ? Colors.green
                                        : Colors.grey.shade400,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(8.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.3),
                                      spreadRadius: 1,
                                      blurRadius: 5,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: ListTile(
                                  leading: const Icon(Icons.account_balance),
                                  title: Text(
                                    bankAccount.accountName?.split(" ")[0] ??
                                        "",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  subtitle: Text(
                                    formatBankAccount(
                                      bankAccount.bankName ?? "",
                                      bankAccount.accountNumber ?? "",
                                    ),
                                    style: const TextStyle(
                                      fontSize: 13,
                                    ),
                                  ),
                                  trailing: selectedIndex.value == index
                                      ? const Icon(
                                          Icons.check_circle,
                                          color: Colors.green,
                                        )
                                      : const Icon(
                                          Icons.radio_button_unchecked),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }),
                  ),
                  SizedBox(height: Get.height * 0.1),
                  CustomButton(
                    ontap: _userController.isloading.value
                        ? () {}
                        : () async {
                            print(coins.value);
                            if (coins.value.isEmpty ||
                                recipientCode.value.isEmpty) {
                              CustomSnackbar.showErrorSnackBar(
                                "Choose your bank and coins",
                              );
                              return;
                            }
                            await _userController.withdrawCoin(
                              coins: coins.value,
                              recipientCode: recipientCode.value,
                            );
                          },
                    child: Obx(
                      () => _userController.isPaymentProcessing.value
                          ? const Loader()
                          : const Text(
                              "Withdraw",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String formatBankAccount(String bankName, String accountNumber) {
    if (accountNumber.length < 4) {
      return 'Invalid account number';
    }
    String lastFourDigits = accountNumber.substring(accountNumber.length - 4);
    return '$bankName **** $lastFourDigits';
  }
}
