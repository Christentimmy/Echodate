import 'package:echodate/app/controller/user_controller.dart';
import 'package:echodate/app/modules/withdraw/controller/withdraw_screen_controller.dart';
import 'package:echodate/app/modules/withdraw/widgets/withdrawal_widgets.dart';
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
