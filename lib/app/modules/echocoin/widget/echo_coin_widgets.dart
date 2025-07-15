import 'package:echodate/app/controller/theme_controller.dart';
import 'package:echodate/app/controller/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class BuildCoinGridWidget extends StatelessWidget {
  final RxString selectedCoinPackage;
  BuildCoinGridWidget({
    super.key,
    required this.selectedCoinPackage,
  });

  final NumberFormat currencyFormat = NumberFormat("#,##0.00", "en_US");
  final RxInt _currentIndex = (-1).obs;
  final _userController = Get.find<UserController>();
  final _themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.1,
      ),
      itemCount: _userController.allEchoCoins.length,
      itemBuilder: (context, index) {
        final coinOption = _userController.allEchoCoins[index];
        return Obx(() {
          final isDark = _themeController.isDarkMode.value;
          return InkWell(
            onTap: () {
              _currentIndex.value = index;
              selectedCoinPackage.value = coinOption.id;
            },
            child: Container(
              decoration: BoxDecoration(
                color: (isDark
                    ? const Color.fromARGB(255, 22, 22, 22)
                    : Colors.grey[200]),
                borderRadius: BorderRadius.circular(12),
                border: index == _currentIndex.value
                    ? Border.all(
                        color: Colors.orange.shade300,
                        width: 1.5,
                      )
                    : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFFFD700),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.music_note,
                            color: Colors.white,
                            size: 14,
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        coinOption.coins.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: index == _currentIndex.value
                              ? 18
                              : (coinOption.coins > 999 ? 16 : 18),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "₵${currencyFormat.format(coinOption.price)}",
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }
}
