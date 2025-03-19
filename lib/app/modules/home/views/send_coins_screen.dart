import 'package:echodate/app/controller/user_controller.dart';
import 'package:echodate/app/resources/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CoinTransferScreen extends StatefulWidget {
  final String recipientName;
  final String recipientId;

  const CoinTransferScreen({
    super.key,
    required this.recipientName,
    required this.recipientId,
  });

  @override
  _CoinTransferScreenState createState() => _CoinTransferScreenState();
}

class _CoinTransferScreenState extends State<CoinTransferScreen> {
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
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text(
          'Send Coins',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.primaryColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor:
                            AppColors.primaryColor.withOpacity(0.2),
                        child: Text(
                          widget.recipientName[0].toUpperCase(),
                          style: TextStyle(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Sending to:',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              widget.recipientName,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'ID: ${widget.recipientId}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Amount selection
              const Text(
                'Select Amount',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              // Current balance
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primaryColor,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.music_note,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Obx(
                    () => Text(
                      'Available: ${availableCoins.value}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Amount display
              Container(
                padding: const EdgeInsets.symmetric(vertical: 24),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primaryColor,
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.music_note,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _selectedAmount.toStringAsFixed(2),
                          style: TextStyle(
                            fontSize: 42,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Obx(
                      () => Slider(
                        value: _selectedAmount,
                        min: 0,
                        max: double.parse(availableCoins.value),
                        divisions: 100,
                        activeColor: AppColors.primaryColor,
                        inactiveColor: AppColors.primaryColor.withOpacity(0.2),
                        onChanged: (value) {
                          setState(() {
                            _selectedAmount = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Quick amount selection
              const Text(
                'Quick Select',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _quickAmounts.map((amount) {
                  return InkWell(
                    onTap: () {
                      double ava = double.tryParse(availableCoins.value) ?? 0;
                      setState(() {
                        _selectedAmount = amount <= ava ? amount : ava;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: _selectedAmount == amount
                            ? AppColors.primaryColor
                            : Colors.grey[200],
                        border: _selectedAmount == amount
                            ? null
                            : Border.all(
                                color: AppColors.primaryColor,
                              ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 25,
                            height: 25,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primaryColor,
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.music_note,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            amount.toStringAsFixed(0),
                            style: TextStyle(
                              color: _selectedAmount == amount
                                  ? Colors.white
                                  : Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 32),

              // Send button
              ElevatedButton(
                onPressed: _selectedAmount > 0
                    ? () async {
                        await _userController.sendCoins(
                          coins: _selectedAmount.toString(),
                          recipientUserId: widget.recipientId,
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Obx(
                  () => _userController.isSendGiftLoading.value
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text(
                          'Send Coins',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
