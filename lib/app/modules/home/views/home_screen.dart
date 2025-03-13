import 'package:echodate/app/controller/story_controller.dart';
import 'package:echodate/app/controller/user_controller.dart';
import 'package:echodate/app/models/story_model.dart';
import 'package:echodate/app/modules/home/widgets/home_widgets.dart';
import 'package:echodate/app/modules/live/views/all_streams.dart';
import 'package:echodate/app/modules/story/views/create_story_screen.dart';
import 'package:echodate/app/resources/colors.dart';
import 'package:echodate/app/widget/delete_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

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
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        "assets/images/ECHODATE.png",
                        width: Get.width * 0.2,
                        height: 30,
                        fit: BoxFit.fitWidth,
                      ),
                      Row(
                        children: [
                          InkWell(
                            onTap: () async {
                              Get.to(() => LiveStreamListScreen());
                            },
                            child: const Icon(
                              FontAwesomeIcons.hive,
                              color: Colors.black,
                              size: 20,
                            ),
                          ),
                          // const SizedBox(width: 10),
                          // const Icon(Icons.notifications, color: Colors.black),
                          const SizedBox(width: 20),
                          InkWell(
                            onTap: () {
                              showDialog(
                                barrierColor: Colors.black.withOpacity(0.7),
                                context: context,
                                builder: (context) {
                                  return GoLiveWidget();
                                },
                              );
                            },
                            child: const Icon(
                              Icons.live_tv,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 90,
                  child: Row(
                    children: [
                      Obx(() {
                        final userModel = _userController.userModel.value;
                        final storyModel = _storyController.userPostedStory.value;
                        if (userModel == null) {
                          return CircleAvatar(
                            radius: 32,
                            backgroundColor: AppColors.primaryColor,
                          );
                        }
                        if (storyModel == null || storyModel.stories?.isEmpty == true) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    CircleAvatar(
                                      radius: 32,
                                      backgroundColor: AppColors.primaryColor,
                                      child: CircleAvatar(
                                        radius: 30,
                                        backgroundImage: NetworkImage(
                                          userModel.avatar ?? "",
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: -5,
                                      right: -5,
                                      child: InkWell(
                                        onTap: () {
                                          Get.to(() => CreateStoryScreen());
                                        },
                                        child: Container(
                                          height: 35,
                                          width: 35,
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.all(7),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              width: 2,
                                              color: Colors.white,
                                            ),
                                            color: AppColors.primaryColor,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.camera_alt,
                                            color: Colors.white,
                                            size: 18,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  userModel.fullName
                                          ?.split(" ")[0]
                                          .toString() ??
                                      "",
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )
                              ],
                            ),
                          );
                        }
                        return Stack(
                          clipBehavior: Clip.none,
                          children: [
                            StoryCard(
                              story: _storyController.userPostedStory.value ?? StoryModel(),
                            ),
                            Positioned(
                              bottom: 15,
                              right: 5,
                              child: InkWell(
                                onTap: () {
                                  Get.to(() => CreateStoryScreen());
                                },
                                child: Container(
                                  height: 35,
                                  width: 35,
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.all(7),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 2,
                                      color: Colors.white,
                                    ),
                                    color: AppColors.primaryColor,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                      Expanded(
                        child: Obx(() {
                          if (_storyController.allstoriesList.isEmpty) {
                            return const SizedBox.shrink();
                          }
                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _storyController.allstoriesList.length,
                            itemBuilder: (context, index) {
                              final story =
                                  _storyController.allstoriesList[index];
                              return StoryCard(story: story);
                            },
                          );
                        }),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                SizedBox(
                  height: Get.height * 0.65,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Obx(() {
                        if (_userController.isloading.value) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          );
                        }

                        if (_userController.potentialMatchesList.isEmpty) {
                          return const Center(
                            child: Text(
                              "No matches found",
                              style: TextStyle(color: Colors.black),
                            ),
                          );
                        }

                        return CardSwiper(
                          cardsCount:
                              _userController.potentialMatchesList.length,
                          numberOfCardsDisplayed:
                              _userController.potentialMatchesList.length < 3
                                  ? _userController.potentialMatchesList.length
                                  : 2,
                          cardBuilder: (
                            context,
                            index,
                            horizontalOffsetPercentage,
                            verticalOffsetPercentage,
                          ) {
                            final profile =
                                _userController.potentialMatchesList[index];
                            return InkWell(
                              onTap: () {
                                Get.to(
                                  () => TinderCardDetails(
                                    userId: profile.id ?? "",
                                  ),
                                );
                              },
                              child: TinderCard(profile: profile),
                            );
                          },
                        );
                      }),
                      Obx(
                        () => _userController.potentialMatchesList.isEmpty
                            ? const SizedBox.shrink()
                            : Positioned(
                                bottom: Get.height * 0.05,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    actionButton(
                                      FontAwesomeIcons.xmark,
                                      Colors.white,
                                      false,
                                    ),
                                    const SizedBox(width: 20),
                                    actionButton(
                                      FontAwesomeIcons.solidHeart,
                                      Colors.orange,
                                      true,
                                    ),
                                    const SizedBox(width: 20),
                                    actionButton(
                                      Icons.star_border,
                                      Colors.white,
                                      false,
                                    ),
                                  ],
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
