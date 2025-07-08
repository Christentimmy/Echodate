import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:echodate/app/controller/story_controller.dart';
import 'package:echodate/app/controller/user_controller.dart';
import 'package:echodate/app/models/story_model.dart';
import 'package:echodate/app/models/user_model.dart';
import 'package:echodate/app/modules/home/views/send_coins_screen.dart';
import 'package:echodate/app/modules/home/widgets/tinder_card_widget.dart';
import 'package:echodate/app/modules/profile/views/alt_profile_screen.dart';
import 'package:echodate/app/modules/story/controller/view_story_full_screen_controller.dart';
import 'package:echodate/app/modules/story/views/create_story_screen.dart';
import 'package:echodate/app/modules/story/views/view_story_full_screen.dart';
import 'package:echodate/app/resources/colors.dart';
import 'package:echodate/app/widget/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_compress/video_compress.dart';
import 'package:appinio_swiper/appinio_swiper.dart';

class TinderCard extends StatelessWidget {
  final UserModel profile;
  const TinderCard({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(60),
            border: Border.all(width: 3, color: Colors.orange),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(57),
            child: CachedNetworkImage(
              width: double.infinity,
              height: double.infinity,
              imageUrl: profile.avatar ?? "",
              fit: BoxFit.cover,
              placeholder: (context, url) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                );
              },
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(57),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: const [0.6, 1.0],
              colors: [
                Colors.black.withOpacity(0.1),
                Colors.black.withOpacity(0.8),
              ],
            ),
          ),
        ),
        profile.plan != "free"
            ? Positioned(
                top: 20,
                right: 10,
                child: InkWell(
                  onTap: () {
                    Get.to(
                      () => CoinTransferScreen(
                        recipientName: profile.fullName ?? "",
                        recipientId: profile.id ?? "",
                      ),
                    );
                  },
                  child: Container(
                    height: 45,
                    width: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColors.primaryColor,
                    ),
                    child: const Icon(
                      FontAwesomeIcons.wallet,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            : const SizedBox.shrink(),
        Positioned(
          top: 0,
          left: MediaQuery.of(context).size.width * 0.27,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 25,
              vertical: 5,
            ),
            decoration: const BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(22),
                bottomRight: Radius.circular(22),
              ),
            ),
            child: Text(
              "${profile.matchPercentage.toString()}% Match",
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: Get.height * 0.12,
          left: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    profile.fullName ?? "",
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ).animate().fadeIn(),
                  const SizedBox(width: 5),
                  profile.isVerified == true
                      ? const Icon(
                          Icons.verified,
                          color: Colors.blue,
                          size: 18,
                        )
                      : const SizedBox.shrink(),
                ],
              ),
              Text(
                profile.location?.address ?? "",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ).animate().fadeIn(),
            ],
          ),
        ),
      ],
    ).animate().fadeIn(
          duration: const Duration(milliseconds: 500),
        );
  }
}

Widget buildBasicInfoTile({
  required String title,
  required String leading,
}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Text(
        leading,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Colors.blueGrey,
        ),
      ),
      const SizedBox(width: 10),
      Expanded(
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
    ],
  );
}

class StoryCard extends StatefulWidget {
  final StoryModel story;
  final List<StoryModel> allStories;
  final int index;
  final bool isSeen;
  final VoidCallback onTap;
  const StoryCard({
    super.key,
    required this.story,
    required this.allStories,
    required this.index,
    required this.isSeen,
    required this.onTap,
  });

  @override
  State<StoryCard> createState() => _StoryCardState();
}

class _StoryCardState extends State<StoryCard> {
  bool _isVideo(String url) {
    return url.endsWith(".mp4") ||
        url.endsWith(".mov") ||
        url.endsWith(".avi") ||
        url.endsWith(".mkv");
  }

  Rxn<Uint8List> uint8list = Rxn<Uint8List>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (_isVideo(widget.story.stories?.first.mediaUrl ?? "")) {
        uint8list.value = await VideoCompress.getByteThumbnail(
          widget.story.stories?.first.mediaUrl ?? "",
          quality: 50,
          position: -1,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 32,
              backgroundColor:
                  widget.isSeen ? Colors.grey : AppColors.primaryColor,
              child: _isVideo(widget.story.stories?.first.mediaUrl ?? "")
                  ? Obx(() {
                      if (uint8list.value != null) {
                        return CircleAvatar(
                          radius: 30,
                          backgroundImage: MemoryImage(uint8list.value!),
                        );
                      } else {
                        return const CircleAvatar(radius: 30);
                      }
                    })
                  : CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(
                        widget.story.stories?.first.mediaUrl ?? "",
                      ),
                    ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.story.fullName?.split(" ")[0].toString() ?? "",
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class HeaderHomeWidget extends StatelessWidget {
  const HeaderHomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 8.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "ECHODATE",
            style: GoogleFonts.acme(
              fontSize: 20,
              color: AppColors.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              // InkWell(
              //   onTap: () async {
              //     // Get.to(() => const LiveStreamListScreen());
              //   },
              //   child: const Icon(
              //     FontAwesomeIcons.hive,
              //     color: Colors.black,
              //     size: 20,
              //   ),
              // ),
              // const SizedBox(width: 10),
              CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.lightGrey,
                child: IconButton(
                  onPressed: () {
                    Get.to(() => const ProfileScreen());
                  },
                  icon: Icon(
                    Icons.person,
                    color: AppColors.primaryColor,
                    size: 17,
                  ),
                ),
              )

              // const SizedBox(width: 20),
              // InkWell(
              //   onTap: () {
              //     showDialog(
              //       barrierColor: Colors.black.withOpacity(0.7),
              //       context: context,
              //       builder: (context) {
              //         return GoLiveWidget();
              //       },
              //     );
              //   },
              //   child: const Icon(
              //     Icons.live_tv,
              //     color: Colors.black,
              //   ),
              // ),
            ],
          )
        ],
      ),
    );
  }
}

class StoryCardBuilderWidget extends StatelessWidget {
  StoryCardBuilderWidget({super.key});

  final _storyController = Get.find<StoryController>();
  final _userController = Get.find<UserController>();
  final _viewStoryScreenController = Get.put(ViewStoryFullScreenController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (_storyController.allstoriesList.isEmpty) {
        return Align(
          alignment: Alignment.centerLeft,
          child: UserPostedStoryWidget(
            story: _storyController.emptyStoryModel,
            index: 0,
            allStories: const [],
          ),
        );
      }
      return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _storyController.allstoriesList.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return UserPostedStoryWidget(
              story: _storyController.allstoriesList.first,
              index: index,
              allStories: _storyController.allstoriesList,
            );
          }
          final story = _storyController.allstoriesList[index - 1];
          final userId = _userController.userModel.value?.id ?? "";
          bool isSeen = story.stories
                  ?.every((s) => s.viewedBy?.contains(userId) ?? false) ??
              false;
          if (userId == story.userId) {
            return const SizedBox();
          }
          return StoryCard(
            story: story,
            allStories: _storyController.allstoriesList,
            index: index - 1,
            isSeen: isSeen,
            onTap: () {
              _viewStoryScreenController.tapIndexHomePage.value = index - 1;
              Get.to(() => const ViewStoryFullScreen());
            },
          );
        },
      );
    });
  }
}

class UserPostedStoryWidget extends StatelessWidget {
  final StoryModel story;
  final int index;
  final List<StoryModel> allStories;
  UserPostedStoryWidget({
    super.key,
    required this.story,
    required this.index,
    required this.allStories,
  });
  final _userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final userModel = _userController.userModel.value;
      final storyModel = story;
      if (userModel == null) {
        return CircleAvatar(
          radius: 32,
          backgroundColor: AppColors.primaryColor,
        );
      }
      if (storyModel.stories?.isEmpty == true ||
          story.userId != _userController.userModel.value?.id) {
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
                    bottom: -2,
                    right: -2,
                    child: InkWell(
                      onTap: () {
                        Get.to(() => CreateStoryScreen());
                      },
                      child: Container(
                        height: 25,
                        width: 25,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: Colors.white,
                          ),
                          color: AppColors.primaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                userModel.fullName?.split(" ")[0].toString() ?? "",
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
            story: storyModel,
            allStories: allStories,
            index: index,
            isSeen: false,
            onTap: () {
              Get.to(() => const ViewStoryFullScreen());
            },
          ),
          Positioned(
            bottom: 20,
            right: 5,
            child: InkWell(
              onTap: () {
                Get.to(() => CreateStoryScreen());
              },
              child: Container(
                height: 25,
                width: 25,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 2,
                    color: Colors.white,
                  ),
                  color: AppColors.primaryColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 12,
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}

class SwiperActionButtonsWidget extends StatelessWidget {
  final AppinioSwiperController controller;

  SwiperActionButtonsWidget({super.key, required this.controller});

  final _userController = Get.find<UserController>();

  // State variables to track animation triggers
  final RxBool isLiking = false.obs;
  final RxBool isDisliking = false.obs;
  final RxBool isSuperLiking = false.obs;

  void _triggerAnimation({
    bool? isSuperLike = false,
    bool? isDislike = false,
    bool? isLike = false,
  }) {
    if (isSuperLike == true) {
      isSuperLiking.value = true;
    }
    if (isLike == true) {
      isLiking.value = true;
    }
    if (isDislike == true) {
      isDisliking.value = true;
    }
    // Reset animation after a short delay
    Future.delayed(const Duration(milliseconds: 300), () {
      isLiking.value = false;
      isDisliking.value = false;
      isSuperLiking.value = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => _userController.potentialMatchesList.isEmpty
          ? const SizedBox.shrink()
          : Positioned(
              bottom: Get.height * 0.05,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Obx(
                    () => AnimatedScale(
                      duration: const Duration(milliseconds: 200),
                      scale: isDisliking.value ? 1.2 : 1.0,
                      child: actionButton(
                        icon: FontAwesomeIcons.xmark,
                        onTap: () {
                          _triggerAnimation(isDislike: true);
                          controller.swipeLeft();
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Obx(
                    () => AnimatedScale(
                      scale: isSuperLiking.value ? 1.2 : 1.0,
                      duration: const Duration(milliseconds: 200),
                      child: actionButton(
                        containerSize: 73,
                        iconSize: 30,
                        bgColor: Colors.white,
                        iconColor: AppColors.primaryColor,
                        icon: FontAwesomeIcons.solidHeart,
                        onTap: () async {
                          _triggerAnimation(isSuperLike: true);
                          controller.swipeUp();
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Obx(
                    () => AnimatedScale(
                      scale: isLiking.value ? 1.2 : 1.0,
                      duration: const Duration(milliseconds: 200),
                      child: actionButton(
                        icon: Icons.star,
                        iconSize: 25,
                        onTap: () {
                          _triggerAnimation(isLike: true);
                          controller.swipeRight();
                        },
                      ).animate().scale(
                            duration: 1000.ms,
                            curve: Curves.elasticOut,
                            begin: const Offset(0.2, 0.2),
                            end: const Offset(1.0, 1.0),
                          ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget actionButton({
    required IconData icon,
    Color? bgColor,
    Color? iconColor,
    required VoidCallback onTap,
    double? containerSize,
    double? iconSize,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: containerSize ?? 55,
        width: containerSize ?? 55,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: bgColor ?? Colors.grey,
        ),
        child: Icon(
          icon,
          color: iconColor ?? Colors.white,
          size: iconSize ?? 25,
        ),
      ),
    );
  }
}

class GetPotentialMatchesBuilder extends StatelessWidget {
  GetPotentialMatchesBuilder({super.key});
  final _userController = Get.find<UserController>();
  final _cardSwipeController = AppinioSwiperController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
              return _buildEmptySwipeCardWidget();
            }

            // return SizedBox();
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 20,
              ),
              child: AppinioSwiper(
                cardCount: _userController.potentialMatchesList.length,
                loop: false,
                controller: _cardSwipeController,
                onEnd: () async {
                  if (_userController.hasNextPage) {
                    await _userController.getPotentialMatches(loadMore: true);
                  } else {
                    _userController.potentialMatchesList.clear();
                  }
                },
                onSwipeEnd: (previousIndex, targetIndex, activity) {
                  if (_userController.potentialMatchesList.isEmpty ||
                      previousIndex >=
                          _userController.potentialMatchesList.length) {
                    return;
                  }
                  final userId =
                      _userController.potentialMatchesList[previousIndex].id ??
                          "";
                  if (activity.direction == AxisDirection.right) {
                    _userController.swipeLike(swipedUserId: userId);
                  } else if (activity.direction == AxisDirection.left) {
                    _userController.swipeDislike(swipedUserId: userId);
                  } else if (activity.direction == AxisDirection.up) {
                    _userController.swipeSuperLike(swipedUserId: userId);
                  }
                },
                cardBuilder: (context, index) {
                  final profile = _userController.potentialMatchesList[index];
                  return InkWell(
                    onTap: () {
                      Get.to(
                        () => TinderCardDetails(userModel: profile),
                      );
                    },
                    child: TinderCard(profile: profile),
                  );
                },
              ),
            );
          }),
          Obx(() {
            if (_userController.isloading.value) {
              return const SizedBox.shrink();
            }
            if (_userController.potentialMatchesList.isEmpty) {
              return const SizedBox.shrink();
            }
            return SwiperActionButtonsWidget(controller: _cardSwipeController);
          }),
        ],
      ),
    );
  }

  AnimationConfiguration _buildEmptySwipeCardWidget() {
    return const AnimationConfiguration.synchronized(
      duration: Duration(milliseconds: 200),
      child: SlideAnimation(
        verticalOffset: 50.0,
        child: FadeInAnimation(
          child: Center(
            child: Text(
              "No matches found",
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),
      ),
    );
  }
}

class ReportBottomSheet extends StatefulWidget {
  const ReportBottomSheet({super.key});

  @override
  State<ReportBottomSheet> createState() => _ReportBottomSheetState();
}

class _ReportBottomSheetState extends State<ReportBottomSheet> {
  bool _isLoading = false;

  final List<String> _reportReasons = [
    "No reason",
    "I'm not interested in this person",
    "Profile isDisliking fake, spam, or scammer",
    "Inappropriate content",
    "Underage or minor",
    "Off-Hinge behavior",
    "Someone is in danger"
  ];

  void _reportUser(String reason) async {
    setState(() {
      _isLoading = true;
    });

    // Simulate a network request delay
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    // Close the bottom sheet after reporting
    Navigator.pop(context);

    // Show confirmation message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Report submitted: $reason"),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: _isLoading
          ? const Center(child: CircularProgressIndicator()) // Show loading
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: _reportReasons
                  .map((reason) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[200],
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            minimumSize: const Size(double.infinity, 50),
                          ),
                          onPressed: () => _reportUser(reason),
                          child: Text(reason),
                        ),
                      ))
                  .toList(),
            ),
    );
  }
}

class TinderCardDetailsButton extends StatelessWidget {
  final String userId;

  TinderCardDetailsButton({
    super.key,
    required this.userId,
  });

  final _userController = Get.find<UserController>();

  // State variables to track animation triggers
  final RxBool isLiking = false.obs;
  final RxBool isDisliking = false.obs;
  final RxBool isSuperLiking = false.obs;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(bottom: Get.height * 0.02),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // DISLIKE BUTTON (X)
          buildAnimatedButton(
            icon: FontAwesomeIcons.xmark,
            color: Colors.red,
            size: 28,
            animationTrigger: isDisliking,
            onPressed: () async {
              isDisliking.value = true;
              await Future.delayed(const Duration(milliseconds: 300));
              isDisliking.value = false;
              bool isSwiped =
                  await _userController.swipeDislike(swipedUserId: userId);
              if (isSwiped) {
                CustomSnackbar.showSuccessSnackBar(
                  "Profile Disliked successfully",
                );
              }
            },
            rotationEffect: true,
          ),

          const SizedBox(width: 24),

          // SUPER LIKE BUTTON (⭐)
          buildAnimatedButton(
            icon: Icons.star,
            color: Colors.blue,
            size: 32,
            animationTrigger: isSuperLiking,
            onPressed: () async {
              isSuperLiking.value = true;
              await Future.delayed(const Duration(milliseconds: 300));

              isSuperLiking.value = false;
              bool isSwiped = await _userController.swipeSuperLike(
                swipedUserId: userId,
              );
              if (isSwiped) {
                CustomSnackbar.showSuccessSnackBar(
                  "Profile Super-like successfully",
                );
              }
            },
            pulseEffect: true,
            glowEffect: true,
          ),

          const SizedBox(width: 24),

          // LIKE BUTTON (❤️)
          buildAnimatedButton(
            icon: FontAwesomeIcons.heart,
            color: Colors.green,
            size: 28,
            animationTrigger: isLiking,
            onPressed: () async {
              isLiking.value = true;
              await Future.delayed(const Duration(milliseconds: 300));

              isLiking.value = false;
              bool isSwiped = await _userController.swipeLike(
                swipedUserId: userId,
              );
              if (isSwiped) {
                CustomSnackbar.showSuccessSnackBar(
                  "Profile liked successfully",
                );
              }
            },
            floatEffect: true,
          ),
        ],
      ),
    );
  }

  Widget buildAnimatedButton({
    required IconData icon,
    required Color color,
    required double size,
    required RxBool animationTrigger,
    required VoidCallback onPressed,
    bool rotationEffect = false,
    bool floatEffect = false,
    bool pulseEffect = false,
    bool glowEffect = false,
  }) {
    return Obx(
      () => GestureDetector(
        onTap: onPressed,
        child: Container(
          height: 64,
          width: 64,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: glowEffect && animationTrigger.value
                    ? color.withOpacity(0.5)
                    : Colors.black12,
                blurRadius: glowEffect && animationTrigger.value ? 15 : 5,
                spreadRadius: glowEffect && animationTrigger.value ? 3 : 1,
              ),
            ],
          ),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            transform: Matrix4.identity()
              ..scale(
                pulseEffect && animationTrigger.value ? 1.2 : 1.0,
              )
              ..translate(
                0.0,
                floatEffect && animationTrigger.value ? -10.0 : 0.0,
                0.0,
              ),
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(
                begin: 0,
                end: rotationEffect && animationTrigger.value ? 1.0 : 0.0,
              ),
              duration: const Duration(milliseconds: 300),
              builder: (context, value, child) {
                return Transform.rotate(
                  angle: value * 0.5 * 3.14,
                  child: Icon(
                    icon,
                    color:
                        animationTrigger.value ? color : color.withOpacity(0.7),
                    size: animationTrigger.value ? size * 1.2 : size,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
