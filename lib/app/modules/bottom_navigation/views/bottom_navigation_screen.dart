import 'package:echodate/app/modules/chat/views/chat_list_screen.dart';
import 'package:echodate/app/modules/favourtie/views/favourite_screen.dart';
import 'package:echodate/app/modules/favourtie/views/matches_screen.dart';
import 'package:echodate/app/modules/home/views/home_screen.dart';
import 'package:echodate/app/modules/profile/views/profile_screen.dart';
import 'package:echodate/app/modules/settings/views/alt_setting_screen.dart';
import 'package:echodate/app/resources/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class BottomNavigationScreen extends StatelessWidget {
  BottomNavigationScreen({super.key});

  final RxInt _currentIndex = 0.obs;
  final List<Widget> _pages = [
    const HomeScreen(),
    const FavouriteScreen(),
    const MatchesScreen(),
    const ChatListScreen(),
    const ProfileScreen(),
    const DatingAppSettings(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => _pages[_currentIndex.value]),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          unselectedItemColor: Colors.grey,
          selectedItemColor: AppColors.primaryColor,
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex.value,
          onTap: (value) {
            _currentIndex.value = value;
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(
                FontAwesomeIcons.house,
                size: 21,
              ),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                FontAwesomeIcons.solidThumbsUp,
                size: 22,
              ),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                FontAwesomeIcons.solidHeart,
                size: 21,
              ),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                FontAwesomeIcons.solidMessage,
                size: 20,
              ),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                FontAwesomeIcons.solidUser,
                size: 20,
              ),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                FontAwesomeIcons.gear,
                size: 20,
              ),
              label: "",
            ),
          ],
        ),
      ),
    );
  }
}
