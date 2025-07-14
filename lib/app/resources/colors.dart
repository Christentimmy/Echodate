import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppColors {
  static Color get loginSignUpBg => Get.isDarkMode ? bgDark900 : bgOrange400;
  static List<Color> get authGradientColors => Get.isDarkMode
      ? [
          AppColors.bgDark800,
          AppColors.bgDark700,
          AppColors.bgDark900,
        ]
      : [
          AppColors.bgOrange100,
          AppColors.bgOrange200,
          AppColors.bgOrange400,
        ];

  static BoxDecoration get formFieldDecoration => Get.isDarkMode
      ? BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: AppColors.glassDark,
          border: Border.all(
            color: AppColors.fieldBorder,
            width: 1,
          ),
        )
      : BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white.withOpacity(0.8),
        );

  static List<Color> get formFieldGradient => Get.isDarkMode
      ? [
          Colors.transparent,
          AppColors.accentOrange400.withOpacity(0.05),
        ]
      : [
          Colors.transparent,
          Colors.pink.withOpacity(0.05),
        ];
  static Color primaryColor = const Color(0xffECA014);

  static Color textFormFieldBgColor = Colors.grey;

  static Color bgOrange50 = const Color(0xFFFFF7ED);
  static Color bgOrange100 = const Color(0xFFFFEDD5);
  static Color bgOrange200 = const Color(0xFFFED7AA);
  static Color bgOrange400 = const Color(0xFFFB923C);
  static Color bgOrange500 = const Color(0xFFF97316);
  static Color bgOrange600 = const Color(0xFFEA580C);
  static Color bgOrange800 = const Color(0xFF9A3412);

  static Color pink500 = const Color(0xFFEC4899);
  static Color pink600 = const Color(0xFFDB2777);

  static Color primaryOrange = const Color(0xFFFB923C);
  static Color secondaryOrange = const Color(0xFFF59E0B);

  static Color secondaryColor = const Color(0xFF666666);
  static Color lightGrey = const Color(0xFFF5F5F5);
  static Color borderColor = const Color(0xFFE0E0E0);
  static Color darkColor = const Color(0xFF1A1A1A);

  // Dark background gradients
  static Color bgDark900 = const Color(0xFF0F0F0F);
  static Color bgDark800 = const Color(0xFF1A1A1A);
  static Color bgDark700 = const Color(0xFF2D2D2D);
  static Color bgDark600 = const Color(0xFF404040);
  static Color bgDark500 = const Color(0xFF525252);

  // Text colors for dark theme
  static Color textSecondary = const Color(0xFFB3B3B3);
  static Color textTertiary = const Color(0xFF808080);

  // Glass effect colors
  static Color glassDark = const Color(0xFF1A1A1A).withOpacity(0.8);
  static Color glassLight = const Color(0xFF2D2D2D).withOpacity(0.6);

  // Form field colors
  static Color fieldBackground = const Color(0xFF262626);
  static Color fieldBorder = const Color(0xFF404040);
  static Color fieldFocus = const Color(0xFFFF8C42);

  // Orange accents for dark theme
  static Color accentOrange400 = const Color(0xFFFF8C42);
  static Color accentOrange500 = const Color(0xFFFF7629);
  static Color accentOrange600 = const Color(0xFFE5651A);
  static Color accentOrange700 = const Color(0xFFCC5200);

  // Sender (your messages)
  static const Color senderStart = Color(0xFFFF6B35);
  static const Color senderEnd = Color(0xFFF7931E);
  static const Color senderText = Colors.white;

  // Receiver (other person's messages)
  static const Color receiverBackground = Color(0xFFF1F3F4);
  static const Color receiverBorder = Color(0xFFE1E5E9);
  static const Color receiverText = Color(0xFF2C3E50);

  // Chat background
  static const Color chatBackground = Color(0xFFF8F9FA);

  // 🎯 NEW: Highlight colors for reply feature
  static const Color senderHighlightStart = Color(0xFFFF8A65);
  static const Color senderHighlightEnd = Color(0xFFFFB74D);
  static const Color senderHighlightShadow = Color(0x66FF8A65);

  static const Color receiverHighlightBackground = Color(0xFFFFF8E1);
  static const Color receiverHighlightBorder = Color(0xFFFFD54F);
  static const Color receiverHighlightShadow = Color(0x4DFFD54F);
}
