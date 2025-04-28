import 'package:echodate/app/controller/auth_controller.dart';
import 'package:echodate/app/controller/location_controller.dart';
import 'package:echodate/app/controller/message_controller.dart';
import 'package:echodate/app/controller/notification_controller.dart';
import 'package:echodate/app/controller/user_controller.dart';
import 'package:echodate/app/modules/Interest/views/relationtionship_preference_screen.dart';
import 'package:echodate/app/modules/auth/views/change_password_screen.dart';
import 'package:echodate/app/modules/profile/views/edit_profile_screen.dart';
import 'package:echodate/app/modules/profile/widgets/profile_widgets.dart';
import 'package:echodate/app/modules/settings/views/preference_setting_screen.dart';
import 'package:echodate/app/modules/settings/views/verification_badge_screen.dart';
import 'package:echodate/app/resources/colors.dart';
import 'package:echodate/app/widget/custom_button.dart';
import 'package:echodate/app/widget/custom_textfield.dart';
import 'package:echodate/app/widget/loader.dart';
import 'package:echodate/app/widget/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

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
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              FontAwesomeIcons.x,
              size: 18,
            ),
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: Get.height * 0.02),
                const Text(
                  'Settings',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: Get.height * 0.05),
                const Row(
                  children: [
                    Icon(Icons.person),
                    SizedBox(width: 10),
                    Text(
                      "Account",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 10),
                const Divider(height: 0),
                const SizedBox(width: 10),
                ListTile(
                  onTap: () {
                    Get.to(() => EditProfileScreen());
                  },
                  minTileHeight: 30,
                  contentPadding: const EdgeInsets.all(5),
                  leading: const Text(
                    "Edit Profile",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: const Icon(Icons.keyboard_arrow_right_rounded),
                ),
                ListTile(
                  onTap: () {
                    Get.to(() => const ChangePasswordScreen());
                  },
                  minTileHeight: 30,
                  contentPadding: const EdgeInsets.all(5),
                  leading: const Text(
                    "Change Password",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: const Icon(Icons.keyboard_arrow_right_rounded),
                ),
                ListTile(
                  onTap: () {
                    Get.to(() => const PreferenceSettingScreen());
                  },
                  minTileHeight: 30,
                  contentPadding: const EdgeInsets.all(5),
                  leading: const Text(
                    "Your Preferences",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: const Icon(Icons.keyboard_arrow_right_rounded),
                ),
                Obx(() {
                  final user = _userController.userModel.value;
                  if (user == null) {
                    return const SizedBox.shrink();
                  }
                  if (user.phoneNumber!.isNotEmpty) {
                    return const SizedBox.shrink();
                  }
                  return ListTile(
                    onTap: () {
                      String number = "";
                      addNumberBottomSheet(context, number);
                    },
                    minTileHeight: 30,
                    contentPadding: const EdgeInsets.all(5),
                    leading: const Text(
                      "Add Number",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: const Icon(Icons.keyboard_arrow_right_rounded),
                  );
                }),
                ListTile(
                  onTap: () {
                    Get.to(
                      () => RelationtionshipPreferenceScreen(
                        callback: () {
                          Get.back();
                        },
                      ),
                    );
                  },
                  minTileHeight: 30,
                  contentPadding: const EdgeInsets.all(5),
                  leading: const Text(
                    "Relationship Preference",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: const Icon(Icons.keyboard_arrow_right_rounded),
                ),
                ListTile(
                  onTap: () {
                    Get.to(() => const VerificationFlow());
                  },
                  minTileHeight: 30,
                  contentPadding: const EdgeInsets.all(5),
                  leading: const Text(
                    "Verification Badge",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: const Icon(Icons.keyboard_arrow_right_rounded),
                ),
                SizedBox(height: Get.height * 0.05),
                const Row(
                  children: [
                    Icon(Icons.notifications_active),
                    SizedBox(width: 10),
                    Text(
                      "Notification",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 10),
                const Divider(height: 0),
                const SizedBox(width: 10),
                ListTile(
                  minTileHeight: 30,
                  contentPadding: const EdgeInsets.all(5),
                  leading: const Text(
                    "Location",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: Transform.scale(
                    scale: 0.7,
                    child: Obx(
                      () => Switch(
                        value: _locationController.isLocation.value,
                        activeColor: AppColors.primaryColor,
                        onChanged: (value) async {
                          if (value) {
                            await _locationController
                                .requestLocationPermission();
                          } else {
                            _locationController.disableLocation();
                            Get.defaultDialog(
                              title: 'Location Permission',
                              middleText:
                                  'If you want to fully revoke location access, please open App Settings.',
                              textConfirm: 'Open Settings',
                              textCancel: 'Cancel',
                              onConfirm: () async {
                                Get.back();
                                await openAppSettings();
                              },
                              onCancel: (){},
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 20,
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ),
                ListTile(
                  minTileHeight: 30,
                  contentPadding: const EdgeInsets.all(5),
                  leading: const Text(
                    "Weekend Vibes",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: Transform.scale(
                    scale: 0.7,
                    child: Obx(
                      () => Switch(
                        value: _isWeekendVibes.value,
                        activeColor: AppColors.primaryColor,
                        onChanged: (value) async {
                          _isWeekendVibes.value = value;
                          await _userController.updateWeekendAvailability(
                            updateWeekendAvailability: value,
                          );
                        },
                      ),
                    ),
                  ),
                ),
                ListTile(
                  minTileHeight: 30,
                  contentPadding: const EdgeInsets.all(5),
                  leading: const Text(
                    "Notification",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: Transform.scale(
                    scale: 0.7,
                    child: Obx(
                      () => Switch(
                        value: _controller.isNotification.value,
                        activeColor: AppColors.primaryColor,
                        onChanged: (value) {
                          _controller.toggleNotification(value);
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 45),
                CustomButton(
                  ontap: () {
                    final messageController = Get.find<MessageController>();
                    messageController.savedChatToAvoidLoading.clear();
                    CustomSnackbar.showSuccessSnackBar(
                      "Caches Cleared Successfully,",
                    );
                  },
                  child: const Text(
                    "Clear Chat Caches",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
              ],
            ),
          ),
        ),
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
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 50,
            left: 15,
            right: 15,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Add Number",
                  style: TextStyle(
                    fontSize: 18,
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  hintText: "Number",
                  prefixIcon: Icons.call,
                  keyboardType: TextInputType.number,
                  onChanged: (p0) {
                    number = p0;
                  },
                ),
                const SizedBox(height: 20),
                CustomButton(
                  ontap: () async {
                    FocusManager.instance.primaryFocus?.unfocus();
                    await _authController.sendNumberOTP(
                        phoneNumber: "+$number",
                        callback: () {
                          showPhoneNumberEditBottomSheet("+$number");
                        });
                  },
                  child: Obx(
                    () => _authController.isLoading.value
                        ? const Loader()
                        : const Text(
                            "Continue",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }
}
