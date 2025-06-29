import 'package:echodate/app/controller/user_controller.dart';
import 'package:echodate/app/models/bank_model.dart';
import 'package:echodate/app/modules/withdraw/controller/withdraw_screen_controller.dart';
import 'package:echodate/app/modules/withdraw/views/add_bank_screen.dart';
import 'package:echodate/app/resources/colors.dart';
import 'package:echodate/app/widget/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

void showBankSelectionDialog({
  required BuildContext context,
  required RxList banks,
  required RxString bankCode,
  required RxString selectedBank,
}) {
  RxString filteredBanks = "".obs;

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        insetPadding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 40,
        ),
        title: const Text("Select Bank"),
        content: SizedBox(
          width: Get.width,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                hintText: 'Search',
                onChanged: (query) {
                  filteredBanks.value = query;
                },
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Obx(() {
                  if (filteredBanks.isNotEmpty) {
                    List filteredBankList = banks
                        .where((bank) => bank["name"]
                            .toLowerCase()
                            .contains(filteredBanks.toLowerCase()))
                        .toList();
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: filteredBankList.length,
                      itemBuilder: (context, index) {
                        var bank = filteredBankList[index];
                        return ListTile(
                          title: Text(
                            bank["name"],
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          onTap: () {
                            selectedBank.value = bank["name"];
                            bankCode.value = bank["code"];
                            filteredBanks.value = "";
                            Get.back();
                          },
                        );
                      },
                    );
                  } else {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: banks.length,
                      itemBuilder: (context, index) {
                        var bank = banks[index];
                        return ListTile(
                          title: Text(
                            bank["name"],
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          onTap: () {
                            selectedBank.value = bank["name"];
                            bankCode.value = bank["code"];
                            Get.back();
                          },
                        );
                      },
                    );
                  }
                }),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text("Cancel"),
            onPressed: () {
              Get.back();
            },
          ),
        ],
      );
    },
  );
}

Widget buildHeader(WithdrawScreenController controller) {
  return Container(
    padding: const EdgeInsets.symmetric(
      horizontal: 20,
      vertical: 16,
    ),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border(
        bottom: BorderSide(
          color: AppColors.borderColor,
          width: 1,
        ),
      ),
    ),
    child: Row(
      children: [
        GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
            Navigator.pop(Get.context!);
          },
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.lightGrey,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.arrow_back,
              color: AppColors.primaryColor,
              size: 18,
            ),
          ),
        ),
        Expanded(
          child: Text(
            'Withdraw',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.darkColor,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        GestureDetector(
          onTap: () => controller.showHistoryOptions(),
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.lightGrey,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.more_horiz,
              color: AppColors.primaryColor,
              size: 18,
            ),
          ),
        ),
      ],
    ),
  );
}

class BuildBalanceCard extends StatelessWidget {
  final WithdrawScreenController controller;
  BuildBalanceCard({super.key, required this.controller});

  final _userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller.balanceAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: controller.balanceAnimation.value,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primaryOrange,
                  AppColors.secondaryOrange,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryOrange.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.account_balance_wallet,
                      color: Colors.white,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Available Balance',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.9),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(() {
                      final model = _userController.userModel.value;
                      return Text(
                        model?.echocoinsBalance?.toStringAsFixed(0) ?? "",
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      );
                    }),
                    const SizedBox(width: 8),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Coins',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.8),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Obx(() {
                            final model = _userController.userModel.value;
                            return Text(
                              '≈ GH₵${model?.echocoinsBalance?.toStringAsFixed(0)}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white.withOpacity(0.7),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class BuildWithdrawSection extends StatelessWidget {
  final WithdrawScreenController controller;
  BuildWithdrawSection({super.key, required this.controller});

  final _userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Withdraw Amount',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryColor,
          ),
        ),
        const SizedBox(height: 10),
        Obx(() {
          final model = _userController.userModel.value;
          return Form(
            key: controller.withdrawFormKey,
            autovalidateMode: AutovalidateMode.always,
            child: TextFormField(
              validator: (value) {
                if (model!.echocoinsBalance == null) {
                  return null;
                }
                var withdrawAmount = controller.withdrawAmount;
                if (withdrawAmount > (model.echocoinsBalance ?? 0)) {
                  return "Insufficient Balance";
                }
                if (withdrawAmount > 0 && withdrawAmount < 10) {
                  return "Minimum withdrawal is 10 coins";
                }
                return null;
              },
              controller: controller.withdrawAmountController,
              focusNode: controller.withdrawFocusNode,
              onChanged: (_) {
                controller.canwithdrawM.value = controller.canWithdraw(
                  _userController.userModel.value?.echocoinsBalance ?? 0,
                );
              },
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.darkColor,
              ),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(16),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    width: 1,
                    color: Colors.grey.shade300,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    width: 1,
                    color: AppColors.secondaryOrange,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    width: 1,
                    color: Colors.red.shade300,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    width: 1,
                    color: Colors.red.shade300,
                  ),
                ),
                hintText: '0',
                hintStyle: TextStyle(
                  fontSize: 20,
                  color: Colors.grey[400],
                ),
                prefixIcon: Container(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'GH₵',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.secondaryColor,
                    ),
                  ),
                ),
                suffixIcon: controller.withdrawAmount > 0
                    ? IconButton(
                        onPressed: () {
                          controller.withdrawAmountController.clear();
                          HapticFeedback.lightImpact();
                        },
                        icon: Icon(
                          Icons.close,
                          color: Colors.grey[400],
                          size: 20,
                        ),
                      )
                    : null,
              ),
            ),
          );
        }),
        const SizedBox(height: 16),
        Obx(() {
          final model = _userController.userModel.value;
          if (model == null) return const SizedBox.shrink();
          return Row(
            children: [
              _buildQuickAmountButton('25%', model.echocoinsBalance!),
              const SizedBox(width: 8),
              _buildQuickAmountButton('50%', model.echocoinsBalance!),
              const SizedBox(width: 8),
              _buildQuickAmountButton('75%', model.echocoinsBalance!),
              const SizedBox(width: 8),
              _buildQuickAmountButton('Max', model.echocoinsBalance!),
            ],
          );
        }),
      ],
    );
  }

  Widget _buildQuickAmountButton(String label, int totalCoins) {
    int amount = 0;
    switch (label) {
      case '25%':
        amount = (totalCoins * 0.25).round();
        break;
      case '50%':
        amount = (totalCoins * 0.5).round();
        break;
      case '75%':
        amount = (totalCoins * 0.75).round();
        break;
      case 'Max':
        amount = totalCoins;
        break;
    }

    return Expanded(
      child: GestureDetector(
        onTap: () {
          controller.withdrawAmountController.text = amount.toString();
          controller.canwithdrawM.value = controller.canWithdraw(
            _userController.userModel.value?.echocoinsBalance ?? 0,
          );
          HapticFeedback.lightImpact();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.lightGrey,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: AppColors.borderColor),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryColor,
            ),
          ),
        ),
      ),
    );
  }
}

class BuildBankSection extends StatelessWidget {
  final WithdrawScreenController controller;
  BuildBankSection({super.key, required this.controller});

  final _userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Bank Account',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.darkColor,
              ),
            ),
            GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                Get.to(() => const AddBankScreen());
              },
              child: Text(
                'Add Bank',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primaryColor,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Obx(() {
          RxList allUserBanks = _userController.allLinkedBanks;
          if (_userController.isloading.value) {
            return Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryColor,
              ),
            );
          }
          if (allUserBanks.isEmpty) {
            return const SizedBox.shrink();
          }
          return ListView.builder(
            itemCount: allUserBanks.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              BankModel bankModel = allUserBanks[index];
              return Obx(() {
                final isSelected =
                    controller.selectedBankModel.value?.bankCode ==
                        bankModel.bankCode;
                return BuildEachBankCard(
                  isSelected: isSelected,
                  bank: bankModel,
                  onTap: () {
                    controller.selectBankMethod(bankModel);
                  },
                );
              });
            },
          );
        }),
      ],
    );
  }
}

class BuildEachBankCard extends StatelessWidget {
  final bool isSelected;
  final BankModel bank;
  final VoidCallback onTap;
  const BuildEachBankCard({
    super.key,
    required this.isSelected,
    required this.bank,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.lightGrey : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.primaryColor : AppColors.borderColor,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: bank.isVerified ? Colors.green : Colors.orange,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    bank.bankName ?? "",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: bank.isVerified
                          ? AppColors.darkColor
                          : AppColors.secondaryColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${bank.accountName} • ${bank.accountNumber}',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.secondaryColor,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected && bank.isVerified)
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 12,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class BuildWithdrawButton extends StatelessWidget {
  final WithdrawScreenController controller;
  const BuildWithdrawButton({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return SizedBox(
        width: double.infinity,
        height: 48,
        child: ElevatedButton(
          onPressed: controller.canwithdrawM.value
              ? controller.processWithdrawal
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: controller.canwithdrawM.value
                ? AppColors.primaryColor
                : Colors.grey[300],
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            controller.canwithdrawM.value
                ? 'Withdraw'
                : 'Enter amount to withdraw',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: controller.canwithdrawM.value
                  ? Colors.white
                  : Colors.grey[600],
            ),
          ),
        ),
      );
    });
  }
}
