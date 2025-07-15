import 'package:echodate/app/controller/theme_controller.dart';
import 'package:echodate/app/controller/user_controller.dart';
import 'package:echodate/app/modules/echocoin/widget/echo_coin_widgets.dart';
import 'package:echodate/app/modules/withdraw/controller/withdraw_screen_controller.dart';
import 'package:echodate/app/resources/colors.dart';
import 'package:echodate/app/widget/custom_button.dart';
import 'package:echodate/app/widget/custom_textfield.dart';
import 'package:echodate/app/widget/loader.dart';
import 'package:echodate/app/widget/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class AllEchoCoinsScreen extends StatefulWidget {
  const AllEchoCoinsScreen({super.key});

  @override
  State<AllEchoCoinsScreen> createState() => _AllEchoCoinsScreenState();
}

class _AllEchoCoinsScreenState extends State<AllEchoCoinsScreen>
    with TickerProviderStateMixin {
  final _userController = Get.find<UserController>();
  final _themeController = Get.find<ThemeController>();
  final TextEditingController _amountController = TextEditingController();
  final FocusNode _amountFocusNode = FocusNode();

  late TabController _tabController;
  final RxString _selectedCoinPackage = "".obs;
  final RxString _customAmount = "".obs;
  final RxBool _isCustomAmountValid = false.obs;
  final currentIndex = 0.obs;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!_userController.isEchoCoinsListFetched.value) {
        _userController.getAllEchoCoins();
      }
    });

    // Listen to amount changes
    _amountController.addListener(() {
      _customAmount.value = _amountController.text;
      _validateCustomAmount();
    });
  }

  void _validateCustomAmount() {
    final amount = double.tryParse(_amountController.text);
    _isCustomAmountValid.value = amount != null && amount > 0;
  }

  @override
  void dispose() {
    _tabController.dispose();
    _amountController.dispose();
    _amountFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Obx(() {
            final isDark = _themeController.isDarkMode.value;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color.fromARGB(255, 22, 22, 22)
                      : const Color.fromARGB(255, 238, 238, 238),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Current Balance",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                const Color(0xFFFFD700),
                                const Color(0xFFFFD700).withOpacity(0.8),
                              ],
                            ),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.music_note,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Obx(
                          () => Text(
                            _userController.userModel.value?.echocoinsBalance
                                    .toString() ??
                                "0",
                            style: const TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            "Coins",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),

          // Tab bar
          Obx(() {
            final isDark = _themeController.isDarkMode.value;
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color.fromARGB(255, 27, 27, 27)
                    : Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TabBar(
                controller: _tabController,
                onTap: (v) {
                  currentIndex.value = v;
                },
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.primaryColor,
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.grey[600],
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                tabs: const [
                  Tab(text: "Quick Buy"),
                  Tab(text: "Custom Amount"),
                ],
              ),
            );
          }),

          const SizedBox(height: 16),

          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildQuickBuyTab(),
                _buildCustomAmountTab(),
              ],
            ),
          ),
          _buildBottomButton(),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    final controller = Get.put(WithdrawScreenController());
    return AppBar(
      elevation: 0,
      title: const Text(
        "Get Coins",
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        onPressed: () => Navigator.of(Get.context!).pop(),
      ),
      actions: [
        IconButton(
          onPressed: () => controller.showHistoryOptions(),
          icon: Icon(
            Icons.more_horiz,
            color: AppColors.primaryColor,
            size: 25,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickBuyTab() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Choose a package",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            Obx(() {
              if (_userController.isCoinPackageLoading.value) {
                return SizedBox(
                  height: Get.height * 0.4,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryColor,
                    ),
                  ),
                );
              }
              if (_userController.allEchoCoins.isEmpty) {
                return SizedBox(
                  height: Get.height * 0.4,
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inbox_outlined,
                          size: 64,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          "No packages available",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
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
    );
  }

  Widget _buildCustomAmountTab() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NewCustomTextField(
              hintText: "0.00",
              controller: _amountController,
              focusNode: _amountFocusNode,
              maxLines: 1,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              prefixIcon: Icons.wallet,
              prefixIconColor: AppColors.primaryColor,
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                  RegExp(r'^\d*\.?\d{0,2}'),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Quick amount buttons
            const Text(
              "Quick amounts",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 9,
              runSpacing: 9,
              children: [10, 25, 50, 100, 200].map((amount) {
                return GestureDetector(onTap: () {
                  _amountController.text = amount.toString();
                  _validateCustomAmount();
                }, child: Obx(() {
                  final isDark = _themeController.isDarkMode.value;
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color.fromARGB(255, 22, 22, 22)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.grey[300]!,
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      "GH₵$amount",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  );
                }));
              }).toList(),
            ),

            const SizedBox(height: 24),

            // Conversion info
            Obx(() {
              if (_customAmount.value.isNotEmpty &&
                  _isCustomAmountValid.value) {
                final amount = double.parse(_customAmount.value);
                // final coins = (amount * 10).toInt();
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.primaryColor.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: AppColors.primaryColor,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        "You'll receive ${amount.toStringAsFixed(0)} coins",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomButton() {
    return SafeArea(
      minimum: const EdgeInsets.all(16),
      child: Obx(() {
        final isQuickBuyTab = currentIndex.value == 0;
        return CustomButton(
          ontap: _userController.isPaymentProcessing.value
              ? () {}
              : () async {
                  if (!isQuickBuyTab && !_isCustomAmountValid.value) {
                    CustomSnackbar.showErrorSnackBar(
                      "Please enter a valid amount",
                    );
                    return;
                  }
                  if (isQuickBuyTab && _selectedCoinPackage.value.isEmpty) {
                    CustomSnackbar.showErrorSnackBar("Please select a package");
                    return;
                  }

                  if (isQuickBuyTab) {
                    await _userController.buyCoin(
                      coinPackageId: _selectedCoinPackage.value,
                    );
                  } else {
                    await _userController.buyCoin(
                      coins: _amountController.text,
                    );
                  }
                },
          child: _userController.isPaymentProcessing.value
              ? const Loader()
              : Text(
                  isQuickBuyTab ? "Buy Package" : "Buy Coins",
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        );
      }),
    );
  }
}
