import 'package:echodate/app/controller/user_controller.dart';
import 'package:echodate/app/models/bank_model.dart';
import 'package:echodate/app/modules/withdraw/views/coin_history_screen.dart';
import 'package:echodate/app/modules/withdraw/views/withdraw_history_screen.dart';
import 'package:echodate/app/resources/colors.dart';
import 'package:echodate/app/widget/custom_button.dart';
import 'package:echodate/app/widget/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class WithdrawScreenController extends GetxController
    with GetTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _balanceAnimation;
  late AnimationController _balanceController;
  final TextEditingController _withdrawAmountController =
      TextEditingController();
  final FocusNode _withdrawFocusNode = FocusNode();
  final _withdrawFormKey = GlobalKey<FormState>();
  final RxBool _canwithdrawM = false.obs;
  final Rxn<BankModel> _selectedBankModel = Rxn<BankModel>(null);

  // Getters
  AnimationController get fadeController => _fadeController;
  Animation<double> get fadeAnimation => _fadeAnimation;
  Animation<double> get balanceAnimation => _balanceAnimation;
  AnimationController get balanceController => _balanceController;
  TextEditingController get withdrawAmountController =>
      _withdrawAmountController;
  FocusNode get withdrawFocusNode => _withdrawFocusNode;
  GlobalKey<FormState> get withdrawFormKey => _withdrawFormKey;
  RxBool get canwithdrawM => _canwithdrawM;
  Rxn<BankModel> get selectedBankModel => _selectedBankModel;

  final _userController = Get.find<UserController>();

  void initAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _balanceController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _balanceAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _balanceController, curve: Curves.elasticOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _fadeController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      _balanceController.forward();
    });
  }

  int get withdrawAmount {
    try {
      return int.parse(_withdrawAmountController.text);
    } catch (e) {
      return 0;
    }
  }

  bool canWithdraw(int totalCoins) {
    if (_selectedBankModel.value == null) return false;
    return withdrawAmount > 0 &&
        withdrawAmount <= totalCoins &&
        withdrawAmount >= 100 && // Minimum withdrawal
        _selectedBankModel.value!.isVerified;
  }

  void processWithdrawal() {
    HapticFeedback.mediumImpact();
    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon with gradient background
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primaryColor.withOpacity(0.1),
                      AppColors.primaryColor.withOpacity(0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Icon(
                  Icons.account_balance_wallet_outlined,
                  size: 25,
                  color: AppColors.primaryColor,
                ),
              ),

              const SizedBox(height: 20),

              // Title
              Text(
                'Confirm Withdrawal',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.darkColor,
                  letterSpacing: -0.5,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Please review your withdrawal details',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.darkColor.withOpacity(0.6),
                  fontWeight: FontWeight.w400,
                ),
              ),

              const SizedBox(height: 15),

              // Amount Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.primaryColor.withOpacity(0.1),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Withdrawal Amount',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.darkColor.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'GH₵${withdrawAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primaryColor,
                        letterSpacing: -0.8,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // Bank Details Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.grey.withOpacity(0.1),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.secondaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.account_balance,
                            size: 20,
                            color: AppColors.secondaryColor,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Obx(
                                () => Text(
                                  selectedBankModel.value?.bankName ?? "",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.darkColor,
                                    letterSpacing: -0.2,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '****${selectedBankModel.value?.accountNumber!.substring(selectedBankModel.value!.accountNumber!.length - 4)}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.darkColor.withOpacity(0.6),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 15),

              // Action Buttons
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: Colors.grey.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: AppColors.darkColor.withOpacity(0.7),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomButton(
                      ontap: () async {
                        BankModel model = selectedBankModel.value!;
                        bool? isSuccess = await _userController.withdrawCoin(
                          coins: withdrawAmountController.text,
                          recipientCode: model.recipientCode!,
                        );
                        if (isSuccess != null && isSuccess == true) {
                          Navigator.pop(context);
                          showSuccessDialog();
                        }
                      },
                      child: Obx(
                        () => _userController.isPaymentProcessing.value
                            ? const Loader(height: 22)
                            : const Text(
                                'Confirm',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showSuccessDialog() {
    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(24),
              ),
              child: Icon(Icons.check, color: Colors.green[600], size: 24),
            ),
            const SizedBox(height: 16),
            Text(
              'Withdrawal Requested',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.darkColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your withdrawal request has been submitted. You will receive the money in 1-3 business days.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.secondaryColor,
              ),
            ),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: const Text(
                'Done',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showHistoryOptions() {
    showModalBottomSheet(
      context: Get.context!,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 32,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.history),
              contentPadding: EdgeInsets.zero,
              title: const Text('Coin History'),
              onTap: () {
                Navigator.pop(context);
                Get.to(() => const CoinHistoryScreen());
              },
            ),
            ListTile(
              leading: const Icon(Icons.account_balance_wallet_outlined),
              contentPadding: EdgeInsets.zero,
              title: const Text('Withdraw History'),
              onTap: () {
                Navigator.pop(context);
                Get.to(() => const WithdrawHistoryScreen());
              },
            ),
          ],
        ),
      ),
    );
  }

  void selectBankMethod(BankModel bankModel) {
    if (bankModel.isVerified && selectedBankModel.value != bankModel) {
      selectedBankModel.value = bankModel;
      canwithdrawM.value = canWithdraw(
        _userController.userModel.value?.echocoinsBalance ?? 0,
      );
      HapticFeedback.lightImpact();
    } else {
      selectedBankModel.value = null;
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _balanceController.dispose();
    _withdrawAmountController.dispose();
    _withdrawFocusNode.dispose();
    super.dispose();
  }
}
