import 'package:cached_network_image/cached_network_image.dart';
import 'package:echodate/app/controller/user_controller.dart';
import 'package:echodate/app/modules/echocoin/views/all_echo_coins_screen.dart';
import 'package:echodate/app/modules/profile/views/edit_profile_screen.dart';
import 'package:echodate/app/modules/settings/views/settings_screen.dart';
import 'package:echodate/app/modules/subscription/views/subscription_screen.dart';
import 'package:echodate/app/modules/withdraw/views/alt_withraw_screen.dart';
import 'package:echodate/app/modules/withdraw/views/coin_history_screen.dart';
import 'package:echodate/app/modules/withdraw/views/withdraw_history_screen.dart';
import 'package:echodate/app/modules/withdraw/views/withdrawal_screen.dart';
import 'package:echodate/app/resources/colors.dart';
import 'package:echodate/app/utils/shimmer_effect.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class DatingAppSettings extends StatefulWidget {
  const DatingAppSettings({super.key});

  @override
  State<DatingAppSettings> createState() => _DatingAppSettingsState();
}

class _DatingAppSettingsState extends State<DatingAppSettings>
    with TickerProviderStateMixin {
  final _userController = Get.find<UserController>();

  String currentScreen = 'main';
  bool darkMode = false;

  Map<String, bool> notifications = {
    'matches': true,
    'messages': true,
    'likes': false,
    'promotions': false,
  };

  Map<String, bool> privacy = {
    'showAge': true,
    'showDistance': true,
    'incognito': false,
  };

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

  final Map<String, String> screens = {
    'main': 'Settings',
    'profile': 'Edit Profile',
    'notifications': 'Notifications',
    'privacy': 'Privacy & Safety',
    'subscription': 'Premium Features',
  };

  // Color get primaryOrange => const Color(0xFFFB923C);
  // Color get secondaryOrange => const Color(0xFFF59E0B);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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

  Widget _renderScreen() {
    switch (currentScreen) {
      case 'notifications':
        return _buildNotificationSettings();
      case 'privacy':
        return _buildPrivacySettings();
      case 'subscription':
        return _buildSubscriptionScreen();
      default:
        return _buildMainSettings();
    }
  }

  Widget _buildMainSettings() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 2,
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
                                imageUrl: userModel?.avatar ?? "",
                                placeholder: (context, url) {
                                  return const ShimmerWrapper(
                                    child: CircleAvatar(
                                      radius: 30,
                                    ),
                                  );
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
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 2,
                  offset: const Offset(0, 2),
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 2,
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
                Divider(height: 1, color: Colors.grey[100]),
                // _buildSettingsItem(
                //   icon: Icons.security,
                //   title: 'Coin History',
                //   subtitle: 'View coin history',
                //   onTap: () {
                //     Get.to(() => const CoinHistoryScreen());
                //   },
                // ),
                // Divider(height: 1, color: Colors.grey[100]),
                // _buildSettingsItem(
                //   icon: FontAwesomeIcons.addressBook,
                //   title: 'Withdraw History',
                //   subtitle: 'View withdraw history',
                //   onTap: () {
                //     Get.to(() => const WithdrawHistoryScreen());
                //   },
                // ),
                Divider(height: 1, color: Colors.grey[100]),
                _buildSettingsItem(
                  icon: FontAwesomeIcons.creditCard,
                  title: 'Withdraw Coin',
                  subtitle: 'Unlock unlimited likes',
                  onTap: () {
                    // Get.to(() => const WithdrawalScreen());

                    // Get.to(() => const CoinWithdrawalScreen());
                    Get.to(() =>  const NewCoinWithdrawalScreen());
                  },
                ),
                Divider(height: 1, color: Colors.grey[100]),
                _buildSettingsItem(
                  icon: FontAwesomeIcons.crown,
                  title: 'Premium Features',
                  subtitle: 'Unlock unlimited likes',
                  onTap: () {
                    Get.to(() => const SubscriptionScreen());
                  },
                ),
                Divider(height: 1, color: Colors.grey[100]),
                _buildSettingsItem(
                  icon: Icons.music_note,
                  title: 'Echo Coins',
                  subtitle: 'Unlock unlimited likes',
                  onTap: () {
                    Get.to(() => const AllEchoCoinsScreen());
                  },
                ),
                Divider(height: 1, color: Colors.grey[100]),
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
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 2,
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
                  onTap: () {},
                ),
                Divider(height: 1, color: Colors.grey[100]),
                _buildSettingsItem(
                  icon: Icons.logout,
                  title: 'Sign Out',
                  subtitle: 'See you later!',
                  onTap: () {},
                  showChevron: false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationSettings() {
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey[100]!),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Push Notifications',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Choose what notifications you\'d like to receive',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
            _buildSettingsItem(
              icon: Icons.favorite,
              title: 'New Matches',
              subtitle: 'When someone likes you back',
              hasToggle: true,
              toggleValue: notifications['matches']!,
              onToggle: (value) =>
                  setState(() => notifications['matches'] = value),
              showChevron: false,
            ),
            Divider(height: 1, color: Colors.grey[100]),
            _buildSettingsItem(
              icon: Icons.message,
              title: 'Messages',
              subtitle: 'New message alerts',
              hasToggle: true,
              toggleValue: notifications['messages']!,
              onToggle: (value) =>
                  setState(() => notifications['messages'] = value),
              showChevron: false,
            ),
            Divider(height: 1, color: Colors.grey[100]),
            _buildSettingsItem(
              icon: Icons.thumb_up,
              title: 'Profile Likes',
              subtitle: 'When someone likes your profile',
              hasToggle: true,
              toggleValue: notifications['likes']!,
              onToggle: (value) =>
                  setState(() => notifications['likes'] = value),
              showChevron: false,
            ),
            Divider(height: 1, color: Colors.grey[100]),
            _buildSettingsItem(
              icon: Icons.local_offer,
              title: 'Promotions',
              subtitle: 'Special offers and deals',
              hasToggle: true,
              toggleValue: notifications['promotions']!,
              onToggle: (value) =>
                  setState(() => notifications['promotions'] = value),
              showChevron: false,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrivacySettings() {
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey[100]!),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Profile Visibility',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Control what information is visible to others',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
            _buildSettingsItem(
              icon: Icons.cake,
              title: 'Show Age',
              subtitle: 'Display your age on profile',
              hasToggle: true,
              toggleValue: privacy['showAge']!,
              onToggle: (value) => setState(() => privacy['showAge'] = value),
              showChevron: false,
            ),
            Divider(height: 1, color: Colors.grey[100]),
            _buildSettingsItem(
              icon: Icons.location_on,
              title: 'Show Distance',
              subtitle: 'Display distance to matches',
              hasToggle: true,
              toggleValue: privacy['showDistance']!,
              onToggle: (value) =>
                  setState(() => privacy['showDistance'] = value),
              showChevron: false,
            ),
            Divider(height: 1, color: Colors.grey[100]),
            _buildSettingsItem(
              icon: Icons.visibility_off,
              title: 'Incognito Mode',
              subtitle: 'Browse profiles privately',
              hasToggle: true,
              toggleValue: privacy['incognito']!,
              onToggle: (value) => setState(() => privacy['incognito'] = value),
              showChevron: false,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubscriptionScreen() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 24),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primaryOrange, AppColors.secondaryOrange],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: const Icon(
                    Icons.favorite,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Premium Features',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Unlock the full dating experience',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                'Unlimited Likes',
                'See Who Likes You',
                'Boost Your Profile',
                'Advanced Filters',
                'Read Receipts',
              ].asMap().entries.map((entry) {
                int index = entry.key;
                String feature = entry.value;
                return Column(
                  children: [
                    if (index > 0) Divider(height: 1, color: Colors.grey[100]),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: Colors.green[100],
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Icon(
                              Icons.check,
                              color: Colors.green[600],
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            feature,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[800],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
          Container(
            width: double.infinity,
            height: 56,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primaryOrange, AppColors.secondaryOrange],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryOrange.withOpacity(0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  HapticFeedback.mediumImpact();
                },
                child: const Center(
                  child: Text(
                    'Upgrade to Premium',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
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
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: hasToggle ? null : onTap,
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
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[500],
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
                      color: toggleValue ? null : Colors.grey[300],
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
                              color: Colors.black.withOpacity(0.2),
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
                  color: Colors.grey[400],
                  size: 20,
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToScreen(String screen) {
    HapticFeedback.lightImpact();
    setState(() {
      currentScreen = screen;
    });
    _slideController.reset();
    _slideController.forward();
  }
}
