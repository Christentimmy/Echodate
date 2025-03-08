import 'package:echodate/app/controller/live_stream_controller.dart';
import 'package:echodate/app/controller/story_controller.dart';
import 'package:echodate/app/controller/user_controller.dart';
import 'package:echodate/app/modules/home/widgets/home_widgets.dart';
import 'package:echodate/app/modules/live/views/all_streams.dart';
import 'package:echodate/app/widget/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final _liveStreamController = Get.find<LiveStreamController>();
  final _storyController = Get.find<StoryController>();
  final _userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
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
                      const SizedBox(width: 10),
                      const Icon(Icons.notifications, color: Colors.black),
                      const SizedBox(width: 10),
                      InkWell(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 15,
                                ),
                                child: Center(
                                  child: CustomButton(
                                    child: Obx(
                                      () =>
                                          _liveStreamController.isLoading.value
                                              ? const CircularProgressIndicator(
                                                  color: Colors.white)
                                              : const Text(
                                                  "Go Live",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                    ),
                                    ontap: () async {
                                      await _liveStreamController
                                          .startLiveStream();
                                    },
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child: const Icon(
                          Icons.menu_rounded,
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
                  Obx(
                    () => StoryCard(
                      story: _storyController.userPostedStoryList.first,
                    ),
                  ),
                  Expanded(child: Obx(() {
                    if (_storyController.allstoriesList.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _storyController.allstoriesList.length,
                      itemBuilder: (context, index) {
                        final story = _storyController.allstoriesList[index];
                        return StoryCard(story: story);
                      },
                    );
                  })),
                ],
              ),
            ),
            const SizedBox(height: 15),
            Expanded(
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
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }

                    return CardSwiper(
                      cardsCount: _userController.potentialMatchesList.length,
                      numberOfCardsDisplayed:
                          _userController.potentialMatchesList.length < 3
                              ? _userController.potentialMatchesList.length
                              : 3,
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
                            Get.to(() =>
                                TinderCardDetails(userId: profile.id ?? ""));
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
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
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
    );
  }
}
