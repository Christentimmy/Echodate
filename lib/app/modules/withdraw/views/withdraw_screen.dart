import 'package:echodate/app/controller/user_controller.dart';
import 'package:echodate/app/models/bank_model.dart';
import 'package:echodate/app/modules/withdraw/controller/withdraw_screen_controller.dart';
import 'package:echodate/app/modules/withdraw/widgets/withdrawal_widgets.dart';
import 'package:echodate/app/resources/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WithdrawalScreen extends StatefulWidget {
  const WithdrawalScreen({super.key});

  @override
  State<WithdrawalScreen> createState() => _WithdrawalScreenState();
}

class _WithdrawalScreenState extends State<WithdrawalScreen> {
  final _withdrawScreenController = Get.put(WithdrawScreenController());
  final _userController = Get.find<UserController>();

  @override
  void initState() {
    super.initState();
    _withdrawScreenController.initAnimations();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_userController.isAllLinkedBankFetched.value) {
        _userController.fetchAllLinkedBanks();
      }
    });
  }

  @override
  void dispose() {
    _withdrawScreenController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            buildHeader(_withdrawScreenController),
            Expanded(
              child: FadeTransition(
                opacity: _withdrawScreenController.fadeAnimation,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BuildBalanceCard(controller: _withdrawScreenController),
                      const SizedBox(height: 40),
                      BuildWithdrawSection(
                        controller: _withdrawScreenController,
                      ),
                      const SizedBox(height: 40),
                      BuildBankSection(controller: _withdrawScreenController),
                      const SizedBox(height: 20),
                      BuildWithdrawButton(
                        controller: _withdrawScreenController,
                      ),
                      const SizedBox(height: 24),
                      // _buildWithdrawInfo(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
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
