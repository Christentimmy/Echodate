import 'package:echodate/app/controller/user_controller.dart';
import 'package:echodate/app/resources/colors.dart';
import 'package:echodate/app/widget/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SendCoinsScreen extends StatefulWidget {
  final String recipientName;
  final String recipientId;

  const SendCoinsScreen({
    super.key,
    required this.recipientName,
    required this.recipientId,
  });

  @override
  State<SendCoinsScreen> createState() => _SendCoinsScreenState();
}

class _SendCoinsScreenState extends State<SendCoinsScreen> {
  double _selectedAmount = 0;
  final List<double> _quickAmounts = [5, 10, 25, 50, 100, 150, 200];
  final _userController = Get.find<UserController>();

  @override
  void initState() {
    availableCoins.value =
        _userController.userModel.value?.echocoinsBalance.toString() ?? "";
    super.initState();
  }

  RxString availableCoins = "0".obs;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: theme.primaryColor,
        title: Text(
          'Send Coins',
          style: theme.textTheme.bodyLarge,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Recipient Card
              _buildRecipientCard(isDark, theme),

              const SizedBox(height: 32),

              // Available Balance
              _buildAvailableBalance(theme),

              const SizedBox(height: 32),

              // Amount Selection
              _buildAmountSelection(isDark, theme),

              const SizedBox(height: 32),

              // Quick Amount Selection
              _buildQuickAmountSelection(isDark, theme),

              const SizedBox(height: 48),

              // Send Button
              _buildSendButton(theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecipientCard(bool isDark, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900]?.withOpacity(0.3) : Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  AppColors.accentOrange400,
                  AppColors.bgOrange600,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Text(
                widget.recipientName[0].toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sending to',
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(height: 4),
                Text(
                  widget.recipientName,
                  style: theme.textTheme.bodyLarge,
                ),
                const SizedBox(height: 2),
                Text(
                  'ID: ${widget.recipientId}',
                  style: theme.textTheme.titleSmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvailableBalance(ThemeData theme) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.accentOrange400.withOpacity(0.1),
          ),
          child: Icon(
            Icons.account_balance_wallet_outlined,
            color: AppColors.accentOrange400,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Obx(
          () => Text(
            'Available: ${availableCoins.value} coins',
            style: theme.textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }

  Widget _buildAmountSelection(bool isDark, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Amount',
          style: theme.textTheme.headlineMedium,
        ),
        const SizedBox(height: 20),

        // Amount Display
        Container(
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.accentOrange400.withOpacity(0.1),
                AppColors.bgOrange600.withOpacity(0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.accentOrange400.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.accentOrange400,
                    ),
                    child: const Icon(
                      Icons.music_note,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    _selectedAmount.toStringAsFixed(0),
                    style: theme.textTheme.headlineLarge?.copyWith(
                      fontSize: 36,
                      color: AppColors.accentOrange400,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Obx(
                () => SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 4,
                    thumbShape:
                        const RoundSliderThumbShape(enabledThumbRadius: 8),
                    overlayShape:
                        const RoundSliderOverlayShape(overlayRadius: 16),
                  ),
                  child: Slider(
                    value: _selectedAmount,
                    min: 0,
                    max: double.tryParse(availableCoins.value) ?? 0,
                    divisions: 100,
                    activeColor: AppColors.accentOrange400,
                    inactiveColor: AppColors.accentOrange400.withOpacity(0.2),
                    onChanged: (value) {
                      setState(() {
                        _selectedAmount = value;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickAmountSelection(bool isDark, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Select',
          style: theme.textTheme.bodyLarge,
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: _quickAmounts.map((amount) {
            final isSelected = _selectedAmount == amount;
            final isAffordable =
                amount <= (double.tryParse(availableCoins.value) ?? 0);

            return InkWell(
              onTap: isAffordable
                  ? () {
                      setState(() {
                        _selectedAmount = amount;
                      });
                    }
                  : null,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.accentOrange400
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isAffordable
                        ? (isSelected
                            ? AppColors.accentOrange400
                            : AppColors.accentOrange400.withOpacity(0.3))
                        : Colors.grey.withOpacity(0.3),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected
                            ? Colors.white
                            : AppColors.accentOrange400,
                      ),
                      child: Icon(
                        Icons.music_note,
                        size: 12,
                        color: isSelected
                            ? AppColors.accentOrange400
                            : Colors.white,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      amount.toStringAsFixed(0),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isSelected
                            ? Colors.white
                            : (isAffordable ? theme.primaryColor : Colors.grey),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSendButton(ThemeData theme) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        gradient: _selectedAmount > 0
            ? LinearGradient(
                colors: [
                  AppColors.accentOrange400,
                  AppColors.bgOrange600,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: _selectedAmount > 0 ? null : Colors.grey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ElevatedButton(
        onPressed: _selectedAmount > 0
            ? () {
                showCoinDisclaimerDialog(context);
              }
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          'Send ${_selectedAmount.toStringAsFixed(0)} Coins',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void showCoinDisclaimerDialog(BuildContext context) {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          // backgroundColor: theme.scaffoldBackgroundColor,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.amber.withOpacity(0.1),
                  ),
                  child: const Icon(
                    Icons.info_outline,
                    size: 32,
                    color: Colors.amber,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Important Notice",
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: Colors.amber,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "Sending coins will boost your profile to their top likes and notify them, but doesn't guarantee they'll like you back.",
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        bgColor: Colors.transparent,
                        border: Border.all(
                          width: 1,
                          color: AppColors.fieldBorder,
                        ),
                        ontap: () => Navigator.pop(context),
                        child: Text(
                          "Cancel",
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CustomButton(
                        ontap: () async {
                          await _userController.sendCoins(
                            coins: _selectedAmount.toString(),
                            recipientUserId: widget.recipientId,
                          );
                          Navigator.pop(context);
                        },
                        child: Obx(
                          () => _userController.isSendGiftLoading.value
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  "Send",
                                  style: TextStyle(
                                    color: Colors.white,
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
        );
      },
    );
  }
}
