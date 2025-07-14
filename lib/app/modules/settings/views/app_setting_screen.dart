import 'package:cached_network_image/cached_network_image.dart';
import 'package:echodate/app/controller/auth_controller.dart';
import 'package:echodate/app/controller/user_controller.dart';
import 'package:echodate/app/modules/echocoin/views/all_echo_coins_screen.dart';
import 'package:echodate/app/modules/profile/views/edit_profile_screen.dart';
import 'package:echodate/app/modules/settings/views/settings_screen.dart';
import 'package:echodate/app/modules/subscription/views/subscription_screen.dart';
import 'package:echodate/app/modules/support/views/contact_us_screen.dart';
import 'package:echodate/app/modules/withdraw/views/withdraw_screen.dart';
import 'package:echodate/app/resources/colors.dart';
import 'package:echodate/app/utils/shimmer_effect.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class AppSettings extends StatefulWidget {
  const AppSettings({super.key});

  @override
  State<AppSettings> createState() => _AppSettingsState();
}

class _AppSettingsState extends State<AppSettings>
    with TickerProviderStateMixin {
  final _userController = Get.find<UserController>();
  final _authController = Get.find<AuthController>();

  String currentScreen = 'main';
  bool darkMode = false;

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
        CurvedAnimation(parent: _slideController, curve: Curves.easeOutBack));

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: _buildMainSettings(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainSettings() {
    final bool isDark = Get.isDarkMode;

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 24),
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[850] : Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withOpacity(0.3)
                      : Colors.black.withOpacity(0.05),
                  blurRadius: isDark ? 8 : 2,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primaryOrange,
                        AppColors.secondaryOrange
                      ],
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Row(
                    children: [
                      Obx(() {
                        final userModel = _userController.userModel.value;
                        if (userModel == null) {
                          return const ShimmerWrapper(
                            child: CircleAvatar(
                              radius: 30,
                            ),
                          );
                        }
                        return CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.grey[200],
                          child: CircleAvatar(
                            radius: 28,
                            child: ClipOval(
                              child: CachedNetworkImage(
                                width: Get.width * 0.2,
                                height: Get.height * 0.11,
                                fit: BoxFit.cover,
                                imageUrl: userModel.avatar ?? "",
                                placeholder: (context, url) {
                                  return const CircleAvatar(radius: 30);
                                },
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                            ),
                          ),
                        );
                      }),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Obx(
                            () => Text(
                              _userController.userModel.value?.fullName ?? "",
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Obx(() {
                            final memberStatus =
                                _userController.userModel.value?.plan ?? "";
                            return Text(
                              "${memberStatus.capitalizeFirst} Plan",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.8),
                              ),
                            );
                          }),
                        ],
                      ),
                    ],
                  ),
                ),
                _buildSettingsItem(
                  icon: Icons.person,
                  title: 'Edit Profile',
                  subtitle: 'Update your photos and info',
                  onTap: () {
                    Get.to(() => EditProfileScreen());
                  },
                ),
              ],
            ),
          ),

          // Main Settings
          Container(
            margin: const EdgeInsets.only(bottom: 24),
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[850] : Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withOpacity(0.3)
                      : Colors.black.withOpacity(0.05),
                  blurRadius: isDark ? 8 : 2,
                  offset: const Offset(0, 2),
                ),
                BoxShadow(
                  color: isDark
                      ? Colors.black.withOpacity(0.2)
                      : Colors.black.withOpacity(0.05),
                  blurRadius: isDark ? 6 : 2,
                  offset: const Offset(2, 0),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildSettingsItem(
                  icon: FontAwesomeIcons.gear,
                  title: 'Settings',
                  subtitle: 'Edit your settings',
                  onTap: () {
                    Get.to(() => const SettingsScreen());
                  },
                ),
                Divider(
                  height: 1,
                  color: isDark ? Colors.grey[700] : Colors.grey[100],
                ),
                Divider(
                  height: 1,
                  color: isDark ? Colors.grey[700] : Colors.grey[100],
                ),
                _buildSettingsItem(
                  icon: FontAwesomeIcons.creditCard,
                  title: 'Withdraw Coin',
                  subtitle: 'Unlock unlimited likes',
                  onTap: () {
                    Get.to(() => const WithdrawalScreen());
                  },
                ),
                Divider(
                  height: 1,
                  color: isDark ? Colors.grey[700] : Colors.grey[100],
                ),
                _buildSettingsItem(
                  icon: FontAwesomeIcons.crown,
                  title: 'Premium Features',
                  subtitle: 'Unlock unlimited likes',
                  onTap: () {
                    Get.to(() => const SubscriptionScreen());
                  },
                ),
                Divider(
                  height: 1,
                  color: isDark ? Colors.grey[700] : Colors.grey[100],
                ),
                _buildSettingsItem(
                  icon: Icons.music_note,
                  title: 'Echo Coins',
                  subtitle: 'Unlock unlimited likes',
                  onTap: () {
                    Get.to(() => const AllEchoCoinsScreen());
                  },
                ),
                Divider(
                  height: 1,
                  color: isDark ? Colors.grey[700] : Colors.grey[100],
                ),
                _buildSettingsItem(
                  icon: Icons.dark_mode,
                  title: 'Dark Mode',
                  hasToggle: true,
                  toggleValue: darkMode,
                  onToggle: (value) => setState(() => darkMode = value),
                  showChevron: false,
                ),
              ],
            ),
          ),

          // Support Section
          Container(
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[850] : Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withOpacity(0.3)
                      : Colors.black.withOpacity(0.05),
                  blurRadius: isDark ? 8 : 2,
                  offset: const Offset(2, 0),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildSettingsItem(
                  icon: Icons.help_outline,
                  title: 'Help & Support',
                  subtitle: 'Get help when you need it',
                  onTap: () {
                    Get.to(() => const ContactUsPage());
                  },
                ),
                Divider(
                    height: 1,
                    color: isDark ? Colors.grey[700] : Colors.grey[100]),
                Obx(() {
                  final isloading = _authController.isLoading.value;
                  return _buildSettingsItem(
                    icon: isloading ? FontAwesomeIcons.spinner : Icons.logout,
                    title: 'Sign Out',
                    subtitle: 'See you later!',
                    onTap: () async {
                      await _authController.logout();
                    },
                    showChevron: false,
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    String? subtitle,
    VoidCallback? onTap,
    bool hasToggle = false,
    bool toggleValue = false,
    Function(bool)? onToggle,
    bool showChevron = true,
  }) {
    final bool isDark = Get.isDarkMode;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: hasToggle ? null : onTap,
        splashColor: isDark
            ? Colors.white.withOpacity(0.1)
            : Colors.grey.withOpacity(0.1),
        highlightColor: isDark
            ? Colors.white.withOpacity(0.05)
            : Colors.grey.withOpacity(0.05),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primaryOrange,
                      AppColors.secondaryOrange
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.grey[100] : Colors.grey[800],
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 10,
                          color: isDark ? Colors.grey[400] : Colors.grey[500],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (hasToggle)
                GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    onToggle?.call(!toggleValue);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 48,
                    height: 24,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: toggleValue
                          ? LinearGradient(
                              colors: [
                                AppColors.primaryOrange,
                                AppColors.secondaryOrange
                              ],
                            )
                          : null,
                      color: toggleValue
                          ? null
                          : isDark
                              ? Colors.grey[600]
                              : Colors.grey[300],
                    ),
                    child: AnimatedAlign(
                      duration: const Duration(milliseconds: 300),
                      alignment: toggleValue
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        width: 20,
                        height: 20,
                        margin: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: isDark
                                  ? Colors.black.withOpacity(0.4)
                                  : Colors.black.withOpacity(0.2),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              else if (showChevron)
                Icon(
                  Icons.chevron_right,
                  color: isDark ? Colors.grey[500] : Colors.grey[400],
                  size: 20,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
