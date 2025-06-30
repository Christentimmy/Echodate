import 'package:echodate/app/controller/auth_controller.dart';
import 'package:echodate/app/controller/location_controller.dart';
import 'package:echodate/app/controller/message_controller.dart';
import 'package:echodate/app/controller/notification_controller.dart';
import 'package:echodate/app/controller/user_controller.dart';
import 'package:echodate/app/modules/Interest/views/relationtionship_preference_screen.dart';
import 'package:echodate/app/modules/auth/views/change_password_screen.dart';
import 'package:echodate/app/modules/profile/widgets/edit_profile_widgets.dart';
import 'package:echodate/app/modules/settings/views/preference_setting_screen.dart';
import 'package:echodate/app/modules/settings/views/verification_badge_screen.dart';
import 'package:echodate/app/modules/settings/widgets/setting_widgets.dart';
import 'package:echodate/app/resources/colors.dart';
import 'package:echodate/app/widget/custom_button.dart';
import 'package:echodate/app/widget/custom_textfield.dart';
import 'package:echodate/app/widget/loader.dart';
import 'package:echodate/app/widget/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    _isWeekendVibes.value =
        _userController.userModel.value?.weekendAvailability ?? false;
  }

  final _locationController = Get.find<LocationController>();
  final _controller = Get.put(NotificationController());
  final _userController = Get.find<UserController>();
  final _authController = Get.find<AuthController>();
  final RxBool _isWeekendVibes = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Settings',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: Colors.black,
            letterSpacing: -0.8,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(
                FontAwesomeIcons.xmark,
                size: 18,
                color: Colors.black54,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(13),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Account Section
                _buildSectionCard(
                  icon: Icons.person_outline_rounded,
                  title: "Account",
                  iconColor: AppColors.primaryColor,
                  children: [
                    _buildSettingTile(
                      title: "Change Password",
                      icon: Icons.lock_outline_rounded,
                      onTap: () => Get.to(() => const ChangePasswordScreen()),
                    ),
                    _buildSettingTile(
                      title: "Your Preferences",
                      icon: Icons.tune_rounded,
                      onTap: () =>
                          Get.to(() => const PreferenceSettingScreen()),
                    ),
                    Obx(() {
                      final user = _userController.userModel.value;
                      if (user == null || user.phoneNumber!.isNotEmpty) {
                        return const SizedBox.shrink();
                      }
                      return _buildSettingTile(
                        title: "Add Phone Number",
                        icon: Icons.phone_outlined,
                        onTap: () {
                          String number = "";
                          addNumberBottomSheet(context, number);
                        },
                        showNewBadge: true,
                      );
                    }),
                    _buildSettingTile(
                      title: "Relationship Preference",
                      icon: Icons.favorite_outline_rounded,
                      onTap: () =>
                          Get.to(() => RelationtionshipPreferenceScreen(
                                callback: () => Get.back(),
                              )),
                    ),
                    _buildSettingTile(
                      title: "Verification Badge",
                      icon: Icons.verified_outlined,
                      onTap: () => Get.to(() => const VerificationFlow()),
                      showVerifiedIcon: true,
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Notifications & Privacy Section
                _buildSectionCard(
                  icon: Icons.notifications_none_rounded,
                  title: "Notifications & Privacy",
                  iconColor: Colors.orange,
                  children: [
                    _buildSwitchTile(
                      title: "Location Services",
                      subtitle: "Allow location-based matching",
                      icon: Icons.location_on_outlined,
                      controller: _locationController.isLocation,
                      onChanged: (value) async {
                        if (value) {
                          await _locationController.requestLocationPermission();
                        } else {
                          _locationController.disableLocation();
                          showLocationDialog();
                        }
                      },
                    ),
                    _buildSwitchTile(
                      title: "Weekend Vibes",
                      subtitle: "Show availability on weekends",
                      icon: Icons.weekend_outlined,
                      controller: _isWeekendVibes,
                      onChanged: (value) async {
                        _isWeekendVibes.value = value;
                        await _userController.updateWeekendAvailability(
                          updateWeekendAvailability: value,
                        );
                      },
                    ),
                    _buildSwitchTile(
                      title: "Push Notifications",
                      subtitle: "Receive app notifications",
                      icon: Icons.notifications_active_outlined,
                      controller: _controller.isNotification,
                      onChanged: (value) =>
                          _controller.toggleNotification(value),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                CustomButton(
                  ontap: () {
                    final messageController = Get.find<MessageController>();
                    messageController.savedChatToAvoidLoading.clear();
                    CustomSnackbar.showSuccessSnackBar(
                      "Caches Cleared Successfully",
                    );
                  },
                  bgColor: Colors.red,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.cleaning_services_outlined,
                        color: Colors.white,
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Text(
                        "Clear Chat Caches",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                CustomButton(
                  ontap: () {
                    showDeleteAccountDialog(context, () async {
                      await _authController.deleteAccount();
                    });
                  },
                  bgColor: Colors.red,
                  child: _authController.isLoading.value
                      ? const Loader()
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.delete,
                              color: Colors.white,
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Text(
                              "Delete Accoount",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required IconData icon,
    required String title,
    required Color iconColor,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                  letterSpacing: -0.4,
                ),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            height: 1,
            color: Colors.grey[100],
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSettingTile({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    bool showNewBadge = false,
    bool showVerifiedIcon = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  size: 20,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Colors.black87,
                  ),
                ),
              ),
              if (showNewBadge)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'NEW',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              if (showVerifiedIcon)
                const Icon(
                  Icons.verified,
                  color: Colors.blue,
                  size: 16,
                ),
              const SizedBox(width: 8),
              Icon(
                Icons.chevron_right_rounded,
                color: Colors.grey[400],
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required RxBool controller,
    required Function(bool) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 5,
        vertical: 12,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 20,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          Obx(
            () => Transform.scale(
              scale: 0.75,
              child: Switch.adaptive(
                value: controller.value,
                activeColor: AppColors.primaryColor,
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showPhoneNumberEditBottomSheet(String phoneNumber) async {
    OtpVerificationBottomSheet.show(
      context: context,
      contactType: 'phone',
      contactValue: phoneNumber,
      onOtpSubmitted: (otp) async {
        await _authController.verifyOtp(
            otpCode: otp,
            phoneNumber: phoneNumber,
            whatNext: () {
              Get.back();
            });
        await _userController.getUserDetails();
        phoneNumber = "";
        Navigator.of(Get.context!).pop();
      },
      onResendOtp: () async {
        await _authController.sendNumberOTP(phoneNumber: phoneNumber);
      },
    );
  }

  Future<dynamic> addNumberBottomSheet(
    BuildContext context,
    String number,
  ) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            top: 32,
            left: 20,
            right: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  Icons.phone_outlined,
                  color: AppColors.primaryColor,
                  size: 32,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Add Phone Number",
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.black87,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Add your phone number for better security",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              CustomTextField(
                hintText: "Enter phone number",
                prefixIcon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                onChanged: (value) {
                  number = value;
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primaryColor,
                        AppColors.primaryColor.withOpacity(0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryColor.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () async {
                      FocusManager.instance.primaryFocus?.unfocus();
                      await _authController.sendNumberOTP(
                          phoneNumber: "+$number",
                          callback: () {
                            showPhoneNumberEditBottomSheet("+$number");
                          });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Obx(
                      () => _authController.isLoading.value
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              "Continue",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
