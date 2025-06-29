import 'package:echodate/app/controller/user_controller.dart';
import 'package:echodate/app/models/bank_model.dart';
import 'package:echodate/app/modules/withdraw/views/add_bank_screen.dart';
import 'package:echodate/app/modules/withdraw/views/coin_history_screen.dart';
import 'package:echodate/app/modules/withdraw/views/withdraw_history_screen.dart';
import 'package:echodate/app/resources/colors.dart';
import 'package:echodate/app/widget/custom_button.dart';
import 'package:echodate/app/widget/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class NewCoinWithdrawalScreen extends StatefulWidget {
  const NewCoinWithdrawalScreen({super.key});

  @override
  State<NewCoinWithdrawalScreen> createState() =>
      _NewCoinWithdrawalScreenState();
}

class _NewCoinWithdrawalScreenState extends State<NewCoinWithdrawalScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _balanceAnimation;
  late AnimationController _balanceController;

  final TextEditingController _withdrawController = TextEditingController();
  final FocusNode _withdrawFocusNode = FocusNode();
  final _userController = Get.find<UserController>();
  final _withdrawFormKey = GlobalKey<FormState>();

  final RxInt selectedIndex = (-1).obs;
  final RxString recipientCode = "".obs;
  final RxBool _canwithdrawM = false.obs;
  final Rx<BankModel> selectedBankModel = BankModel().obs;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_userController.isAllLinkedBankFetched.value) {
        _userController.fetchAllLinkedBanks();
        _withdrawController.addListener(() {
          _canwithdrawM.value = canWithdraw(
            _userController.userModel.value?.echocoinsBalance ?? 0,
          );
        });
      }
    });
  }

  void _initAnimations() {
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

  @override
  void dispose() {
    _fadeController.dispose();
    _balanceController.dispose();
    _withdrawController.dispose();
    _withdrawFocusNode.dispose();
    super.dispose();
  }

  int get withdrawAmount {
    try {
      return int.parse(_withdrawController.text);
    } catch (e) {
      return 0;
    }
  }

  bool canWithdraw(int totalCoins) {
    if (selectedIndex.value == -1) return false;
    return withdrawAmount > 0 &&
        withdrawAmount <= totalCoins &&
        withdrawAmount >= 10 && // Minimum withdrawal
        selectedBankModel.value.isVerified;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildBalanceCard(),
                      const SizedBox(height: 40),
                      _buildWithdrawSection(),
                      const SizedBox(height: 40),
                      _buildBankSection(),
                      const SizedBox(height: 20),
                      _buildWithdrawButton(),
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

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: AppColors.borderColor, width: 1),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              Navigator.pop(context);
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
            onTap: () => _showHistoryOptions(),
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

  Widget _buildBalanceCard() {
    return AnimatedBuilder(
      animation: _balanceAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _balanceAnimation.value,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primaryOrange, AppColors.secondaryOrange],
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

  Widget _buildWithdrawSection() {
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
            key: _withdrawFormKey,
            autovalidateMode: AutovalidateMode.always,
            child: TextFormField(
              validator: (value) {
                if (model!.echocoinsBalance == null) {
                  return null;
                }
                if (withdrawAmount > (model.echocoinsBalance ?? 0)) {
                  return "Insufficient Balance";
                }
                if (withdrawAmount > 0 && withdrawAmount < 10) {
                  return "Minimum withdrawal is 10 coins";
                }
                return null;
              },
              controller: _withdrawController,
              focusNode: _withdrawFocusNode,
              onChanged: (_) {
                _canwithdrawM.value = canWithdraw(
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
                suffixIcon: withdrawAmount > 0
                    ? IconButton(
                        onPressed: () {
                          _withdrawController.clear();
                          HapticFeedback.lightImpact();
                        },
                        icon: Icon(Icons.close,
                            color: Colors.grey[400], size: 20),
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
          _withdrawController.text = amount.toString();
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

  Widget _buildBankSection() {
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
              final bankModel = allUserBanks[index];
              return Obx(
                () => BuildEachBankCard(
                  isSelected: index == selectedIndex.value,
                  bank: bankModel,
                  onTap: () {
                    if (bankModel.isVerified) {
                      selectedIndex.value = index;
                      selectedBankModel.value = bankModel;
                      recipientCode.value = bankModel.recipientCode ?? "";
                      _canwithdrawM.value = canWithdraw(
                        _userController.userModel.value?.echocoinsBalance ?? 0,
                      );
                      HapticFeedback.lightImpact();
                    }
                  },
                ),
              );
            },
          );
        }),
      ],
    );
  }

  Widget _buildWithdrawButton() {
    return Obx(() {
      return SizedBox(
        width: double.infinity,
        height: 48,
        child: ElevatedButton(
          onPressed: _canwithdrawM.value ? _processWithdrawal : null,
          style: ElevatedButton.styleFrom(
            backgroundColor:
                _canwithdrawM.value ? AppColors.primaryColor : Colors.grey[300],
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            _canwithdrawM.value ? 'Withdraw' : 'Enter amount to withdraw',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: _canwithdrawM.value ? Colors.white : Colors.grey[600],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildWithdrawInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Withdrawal Information',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.darkColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Minimum withdrawal: 10 coins\n'
            'Processing time: 1-3 business days\n'
            '1 coin = 1 GH₵\n'
            'Bank account must be verified',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.secondaryColor,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  void _processWithdrawal() {
    HapticFeedback.mediumImpact();
    showDialog(
      context: context,
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
                                  selectedBankModel.value.bankName ?? "",
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
                                '****${selectedBankModel.value.accountNumber!.substring(selectedBankModel.value.accountNumber!.length - 4)}',
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
                        bool? isSuccess = await _userController.withdrawCoin(
                          coins: _withdrawController.text,
                          recipientCode: recipientCode.value,
                        );
                        if (isSuccess != null && isSuccess == true) {
                          Navigator.pop(context);
                          _showSuccessDialog();
                        }
                      },
                      child: Obx(
                        () => _userController.isPaymentProcessing.value
                            ? const Loader(height: 25)
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

  void _showSuccessDialog() {
    showDialog(
      context: context,
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

  void _showHistoryOptions() {
    showModalBottomSheet(
      context: context,
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
