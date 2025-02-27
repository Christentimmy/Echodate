import 'package:echodate/app/modules/Interest/widgets/interest_widgets.dart';
import 'package:echodate/app/modules/auth/views/signup_screen.dart';
import 'package:echodate/app/modules/home/widgets/home_widgets.dart';
import 'package:echodate/app/modules/settings/views/settings_screen.dart';
import 'package:echodate/app/modules/subscription/views/subscription_screen.dart';
import 'package:echodate/app/resources/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final List<Map<String, String>> interests = [
    {"emoji": "⚽", "label": "Football"},
    {"emoji": "🌿", "label": "Nature"},
    {"emoji": "🗣️", "label": "Language"},
    {"emoji": "📸", "label": "Photography"},
  ];

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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: Get.height * 0.01),
                Center(
                  child: CircleAvatar(
                    backgroundColor: AppColors.primaryColor,
                    radius: 45,
                    child: const CircleAvatar(
                      radius: 42,
                      backgroundImage: AssetImage("assets/images/pp.jpg"),
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    "@johndoe123",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey.shade700,
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
                const Text(
                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin in sed enim suscipit phasellus nibh sed. ",
                ),
                const SizedBox(height: 10),
                buildBasicInfoTile(
                  leading: "Gender: ",
                  title: "Male",
                ),
                buildBasicInfoTile(
                  leading: "Age: ",
                  title: "27 Years Old",
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
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: interests.map((interest) {
                    return buildSelectiveCards(
                      interest: interest,
                      isSelected: false,
                      onTap: () {},
                    );
                  }).toList(),
                ),
                SizedBox(height: Get.height * 0.04),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text(
                          "115",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text("Visitor"),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          "115",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text("Likes"),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          "115",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text("Matches"),
                      ],
                    ),
                  ],
                ),
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
                    Get.to(() => SettingsScreen());
                  },
                  bgColor: Colors.blueGrey,
                  iconColor: Colors.white,
                  icon: FontAwesomeIcons.gear,
                ),
                Divider(color: Colors.grey.withOpacity(0.2)),
                const SizedBox(height: 10),
                _buildProfileSettingTiles(
                  title: "Billing Address",
                  onTap: () {},
                  bgColor: Colors.green,
                  iconColor: Colors.white,
                  icon: FontAwesomeIcons.addressBook,
                ),
                Divider(color: Colors.grey.withOpacity(0.2)),
                const SizedBox(height: 10),
                _buildProfileSettingTiles(
                  title: "Earning and Withdrawal",
                  onTap: () {},
                  bgColor: Colors.blueGrey,
                  iconColor: Colors.white,
                  icon: FontAwesomeIcons.creditCard,
                ),
                Divider(color: Colors.grey.withOpacity(0.2)),
                const SizedBox(height: 10),
                _buildProfileSettingTiles(
                  title: "Echo Coins",
                  onTap: () {},
                  bgColor: Colors.deepPurpleAccent,
                  iconColor: Colors.white,
                  icon: FontAwesomeIcons.coins,
                ),
                Divider(color: Colors.grey.withOpacity(0.2)),
                const SizedBox(height: 10),
                _buildProfileSettingTiles(
                  title: "Sign Out",
                  onTap: () {
                    Get.offAll(()=> RegisterScreen());
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
