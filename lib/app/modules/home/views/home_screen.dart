import 'package:echodate/app/controller/story_controller.dart';
import 'package:echodate/app/controller/user_controller.dart';
import 'package:echodate/app/modules/home/widgets/home_widgets.dart';
import 'package:echodate/app/resources/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _storyController = Get.find<StoryController>();
  final _userController = Get.find<UserController>();

  @override
  void initState() {
    super.initState();
    if (!_userController.isUserDetailsFetched.value) {
      _userController.getUserDetails();
    }
    if (!_storyController.isStoryFetched.value) {
      _storyController.getAllStories();
      _storyController.getUserPostedStories();
    }
    if (!_userController.isPotentialMatchFetched.value) {
      _userController.getPotentialMatches();
    }
    saveUserOneSignalId();
  }

  void saveUserOneSignalId() async {
    String? subId = OneSignal.User.pushSubscription.id;
    if (subId != null) {
      await _userController.saveUserOneSignalId(oneSignalId: subId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        color: AppColors.primaryColor,
        onRefresh: () async {
          await _storyController.getUserPostedStories();
          await _storyController.getAllStories();
          await _userController.getPotentialMatches();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SafeArea(
            child: Column(
              children: [
                const HeaderHomeWidget(),
                SizedBox(
                  height: 90,
                  child: Row(
                    children: [
                      UserPostedStoryWidget(),
                      StoryCardBuilderWidget(),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                GetPotentialMatchesBuilder(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
