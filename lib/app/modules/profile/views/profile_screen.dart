import 'package:cached_network_image/cached_network_image.dart';
import 'package:echodate/app/controller/auth_controller.dart';
import 'package:echodate/app/controller/user_controller.dart';
import 'package:echodate/app/modules/Interest/widgets/interest_widgets.dart';
import 'package:echodate/app/modules/echocoin/views/all_echo_coins_screen.dart';
import 'package:echodate/app/modules/home/widgets/home_widgets.dart';
import 'package:echodate/app/modules/settings/views/settings_screen.dart';
import 'package:echodate/app/modules/subscription/views/subscription_screen.dart';
import 'package:echodate/app/modules/withdraw/views/coin_history_screen.dart';
import 'package:echodate/app/modules/withdraw/views/withdraw_history_screen.dart';
import 'package:echodate/app/modules/withdraw/views/withdrawal_screen.dart';
import 'package:echodate/app/resources/colors.dart';
import 'package:echodate/app/utils/age_calculator.dart';
import 'package:echodate/app/widget/animations.dart';
import 'package:echodate/app/widget/shimmer_effect.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _userController = Get.find<UserController>();

  @override
  void initState() {
    super.initState();
    if (!_userController.isUserDetailsFetched.value) {
      _userController.getUserDetails();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Profile",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: AnimatedListWrapper(
              duration: const Duration(milliseconds: 150),
              children: [
                SizedBox(height: Get.height * 0.01),
                Center(
                  child: Obx(() {
                    final userModel = _userController.userModel.value;
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(80),
                      child: CachedNetworkImage(
                        width: Get.width * 0.31,
                        height: Get.height * 0.14,
                        fit: BoxFit.cover,
                        imageUrl: userModel?.avatar ?? "",
                        placeholder: (context, url) {
                          return ShimmerEffect(
                            child: const CircleAvatar(radius: 30),
                          );
                        },
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    );
                  }),
                ),
                Center(
                  child: Obx(
                    () => Text(
                      _userController.userModel.value?.fullName ?? "",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: Get.height * 0.04),
                const Text(
                  "Bio",
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Obx(() => Text(_userController.userModel.value?.bio ?? "")),
                const SizedBox(height: 10),
                Obx(() {
                  String gender = _userController.userModel.value?.gender ?? "";
                  return buildBasicInfoTile(
                    leading: "Gender: ",
                    title: gender.toUpperCase(),
                  );
                }),
                Obx(
                  () => buildBasicInfoTile(
                    leading: "Age: ",
                    title:
                        "${calculateAge(_userController.userModel.value?.dob ?? "")} YEARS OLD",
                  ),
                ),
                SizedBox(height: Get.height * 0.04),
                const Text(
                  "Hobbies",
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Obx(() {
                  List? hobbies = _userController.userModel.value?.hobbies;
                  if (hobbies == null || hobbies.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  return Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: hobbies.map((interest) {
                      return buildInterestCards(interest: interest);
                    }).toList(),
                  );
                }),
                SizedBox(height: Get.height * 0.04),
                Divider(color: Colors.grey.withOpacity(0.2)),
                const SizedBox(height: 10),
                _buildProfileSettingTiles(
                  title: "EchoDate Premium",
                  onTap: () {
                    Get.to(() => const SubscriptionScreen());
                  },
                  bgColor: AppColors.primaryColor,
                  iconColor: Colors.white,
                  icon: FontAwesomeIcons.crown,
                ),
                Divider(color: Colors.grey.withOpacity(0.2)),
                const SizedBox(height: 10),
                _buildProfileSettingTiles(
                  title: "Settings",
                  onTap: () {
                    Get.to(() => const SettingsScreen());
                  },
                  bgColor: Colors.blueGrey,
                  iconColor: Colors.white,
                  icon: FontAwesomeIcons.gear,
                ),
                Divider(color: Colors.grey.withOpacity(0.2)),
                const SizedBox(height: 10),
                _buildProfileSettingTiles(
                  title: "Transactions",
                  onTap: () {
                    Get.to(() => const CoinHistoryScreen());
                  },
                  bgColor: Colors.green,
                  iconColor: Colors.white,
                  icon: FontAwesomeIcons.addressBook,
                ),
                const SizedBox(height: 10),
                Divider(color: Colors.grey.withOpacity(0.2)),
                _buildProfileSettingTiles(
                  title: "Withdraw History",
                  onTap: () {
                    Get.to(() => const WithdrawHistoryScreen());
                  },
                  bgColor: Colors.teal,
                  iconColor: Colors.white,
                  icon: FontAwesomeIcons.addressBook,
                ),
                Divider(color: Colors.grey.withOpacity(0.2)),
                const SizedBox(height: 10),
                _buildProfileSettingTiles(
                  title: "Earning and Withdrawal",
                  onTap: () {
                    Get.to(() => const WithdrawalScreen());
                  },
                  bgColor: Colors.blueGrey,
                  iconColor: Colors.white,
                  icon: FontAwesomeIcons.creditCard,
                ),
                Divider(color: Colors.grey.withOpacity(0.2)),
                const SizedBox(height: 10),
                _buildProfileSettingTiles(
                  title: "Echo Coins",
                  onTap: () {
                    Get.to(() => const AllEchoCoinsScreen());
                  },
                  bgColor: Colors.deepPurpleAccent,
                  iconColor: Colors.white,
                  icon: FontAwesomeIcons.coins,
                ),
                Divider(color: Colors.grey.withOpacity(0.2)),
                const SizedBox(height: 10),
                _buildProfileSettingTiles(
                  title: "Sign Out",
                  onTap: () async {
                    final authController = Get.find<AuthController>();
                    await authController.logout();
                  },
                  bgColor: Colors.red,
                  iconColor: Colors.white,
                  icon: FontAwesomeIcons.arrowRightFromBracket,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ListTile _buildProfileSettingTiles({
    required String title,
    required VoidCallback onTap,
    required Color bgColor,
    required Color iconColor,
    required IconData icon,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      minTileHeight: 20,
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
      leading: Container(
        height: 40,
        width: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: bgColor,
        ),
        child: Icon(
          icon,
          color: iconColor,
          size: 20,
        ),
      ),
    );
  }
}
