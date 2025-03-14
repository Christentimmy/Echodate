import 'package:echodate/app/controller/location_controller.dart';
import 'package:echodate/app/controller/notification_controller.dart';
import 'package:echodate/app/controller/user_controller.dart';
import 'package:echodate/app/modules/auth/views/change_password_screen.dart';
import 'package:echodate/app/modules/profile/views/edit_profile_screen.dart';
import 'package:echodate/app/modules/settings/views/preference_setting_screen.dart';
import 'package:echodate/app/resources/colors.dart';
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

  final _locationController = Get.put(LocationController());
  final _controller = Get.put(NotificationController());
  final _userController = Get.find<UserController>();
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
                  Get.to(() => const EditProfileScreen());
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
                          await _locationController.requestLocationPermission();
                        } else {
                          _locationController.isLocation.value = false;
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
            ],
          ),
        ),
      ),
    );
  }
}
