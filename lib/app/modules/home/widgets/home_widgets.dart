import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:echodate/app/controller/story_controller.dart';
import 'package:echodate/app/controller/user_controller.dart';
import 'package:echodate/app/models/chat_list_model.dart';
import 'package:echodate/app/models/story_model.dart';
import 'package:echodate/app/models/user_model.dart';
import 'package:echodate/app/modules/Interest/widgets/interest_widgets.dart';
import 'package:echodate/app/modules/chat/views/chat_screen.dart';
import 'package:echodate/app/modules/home/views/send_coins_screen.dart';
import 'package:echodate/app/modules/live/views/all_streams.dart';
import 'package:echodate/app/modules/story/views/create_story_screen.dart';
import 'package:echodate/app/modules/story/views/view_story_full_screen.dart';
import 'package:echodate/app/resources/colors.dart';
import 'package:echodate/app/utils/age_calculator.dart';
import 'package:echodate/app/widget/animations.dart';
import 'package:echodate/app/widget/delete_dialog.dart';
import 'package:echodate/app/widget/loader.dart';
import 'package:echodate/app/widget/shimmer_effect.dart';
import 'package:echodate/app/widget/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:video_compress/video_compress.dart';
import 'package:motion/motion.dart';
import 'package:animate_do/animate_do.dart';

Widget actionButton(
  IconData icon,
  Color color,
  bool isCenter,
  VoidCallback onTap,
) {
  return InkWell(
    onTap: onTap,
    child: Container(
      height: isCenter ? 70 : 55,
      width: isCenter ? 70 : 55,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isCenter ? Colors.white : Colors.white.withOpacity(0.8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 6,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Icon(
        icon,
        color: color,
        size: 25,
      ),
    ),
  );
}

class TinderCard extends StatelessWidget {
  final UserModel profile;
  const TinderCard({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return FadeIn(
      duration: const Duration(milliseconds: 500),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(width: 3, color: Colors.orange),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(17),
              child: CachedNetworkImage(
                width: double.infinity,
                height: double.infinity,
                imageUrl: profile.avatar ?? "",
                fit: BoxFit.cover,
                placeholder: (context, url) {
                  return ShimmerEffect(
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  );
                },
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
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
                    child: Bounce(
                      from: 10,
                      duration: const Duration(milliseconds: 500),
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
                  ),
                )
              : const SizedBox.shrink(),
          Positioned(
            top: 0,
            left: MediaQuery.of(context).size.width * 0.32,
            child: FadeInDown(
              from: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: const BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                child: Text(
                  "${profile.matchPercentage.toString()}% Match",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
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
                FadeInLeft(
                  from: 20,
                  child: Text(
                    profile.fullName ?? "",
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                FadeInLeft(
                  from: 40,
                  delay: const Duration(milliseconds: 300),
                  child: Text(
                    profile.location?.address ?? "",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TinderCardDetails extends StatefulWidget {
  final UserModel userModel;
  const TinderCardDetails({
    super.key,
    required this.userModel,
  });

  @override
  State<TinderCardDetails> createState() => _TinderCardDetailsState();
}

class _TinderCardDetailsState extends State<TinderCardDetails> {
  final userModel = Rxn<UserModel>();
  final _userController = Get.find<UserController>();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getUserDetails();
    });
  }

  void getUserDetails() async {
    final response = await _userController.getUserWithId(
      userId: widget.userModel.id ?? "",
    );
    if (response != null) {
      userModel.value = response;
    }
  }

  final RxInt _activeIndex = 0.obs;
  final RxBool isExpanded = false.obs;
  static const int maxBioLength = 250;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Obx(
            () => Opacity(
              opacity: _userController.isloading.value ? 0.4 : 1,
              child: SingleChildScrollView(
                child: AnimatedListWrapper(
                  children: [
                    SizedBox(
                      height: Get.height * 0.6,
                      width: Get.width,
                      child: Stack(
                        children: [
                          Obx(() {
                            if (_userController.isloading.value) {
                              return SizedBox(
                                height: Get.height * 0.6,
                                width: Get.width,
                                child: const Center(
                                  child: Loader(),
                                ),
                              );
                            }
                            if (userModel.value?.photos != null &&
                                userModel.value!.photos!.isNotEmpty) {
                              return PageView.builder(
                                onPageChanged: (value) {
                                  _activeIndex.value = value;
                                },
                                itemCount: widget.userModel.photos?.length,
                                itemBuilder: (context, index) {
                                  String picture =
                                      userModel.value?.photos?[index] ?? "";
                                  return Image.network(
                                    picture,
                                    fit: BoxFit.cover,
                                    alignment: Alignment.topCenter,
                                    height: Get.height * 0.6,
                                    width: Get.width,
                                  );
                                },
                              );
                            } else {
                              return CachedNetworkImage(
                                imageUrl: widget.userModel.avatar ?? "",
                                fit: BoxFit.cover,
                                height: Get.height * 0.6,
                                width: Get.width,
                                placeholder: (context, url) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                },
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              );
                            }
                          }),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: Get.height * 0.08,
                            ),
                            child: Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    Get.back();
                                  },
                                  child: CircleAvatar(
                                    radius: 18,
                                    backgroundColor:
                                        Colors.grey.withOpacity(0.8),
                                    child: const Icon(
                                      FontAwesomeIcons.x,
                                      size: 15,
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                Obx(
                                  () => _userController.isloading.value
                                      ? const SizedBox.shrink()
                                      : userModel.value?.plan != "free"
                                          ? InkWell(
                                              onTap: () {
                                                Get.to(
                                                  () => CoinTransferScreen(
                                                    recipientName: userModel
                                                            .value?.fullName ??
                                                        "",
                                                    recipientId:
                                                        userModel.value?.id ??
                                                            "",
                                                  ),
                                                );
                                              },
                                              child: Container(
                                                height: 45,
                                                width: 45,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: AppColors.primaryColor,
                                                ),
                                                child: const Icon(
                                                  FontAwesomeIcons.wallet,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            )
                                          : const SizedBox.shrink(),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            bottom: Get.height * 0.02,
                            child: Container(
                              padding: const EdgeInsets.only(right: 10),
                              height: 50,
                              width: Get.width,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Obx(() {
                                    if (userModel.value?.photos != null &&
                                        userModel.value?.photos?.isNotEmpty ==
                                            true) {
                                      return AnimatedSmoothIndicator(
                                        activeIndex: _activeIndex.value,
                                        count:
                                            userModel.value?.photos?.length ??
                                                0,
                                        effect: ExpandingDotsEffect(
                                          dotWidth: 10,
                                          dotHeight: 10,
                                          activeDotColor:
                                              AppColors.primaryColor,
                                        ),
                                      );
                                    } else {
                                      return const SizedBox.shrink();
                                    }
                                  }),
                                  SizedBox(width: Get.width / 4.8),
                                  InkWell(
                                    onTap: () async {
                                      ChatListModel chatHead = ChatListModel(
                                        userId: userModel.value?.id ?? "",
                                        fullName:
                                            userModel.value?.fullName ?? "",
                                        lastMessage: "",
                                        avatar: userModel.value?.avatar ?? "",
                                        unreadCount: 0,
                                        online: false,
                                      );
                                      Get.to(
                                        () => ChatScreen(chatHead: chatHead),
                                      );
                                    },
                                    child: Motion(
                                      shadow: null,
                                      glare: null,
                                      child: CircleAvatar(
                                        radius: 30,
                                        backgroundColor:
                                            Colors.white.withOpacity(0.8),
                                        child: Icon(
                                          Icons.chat,
                                          color: AppColors.primaryColor,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 25,
                          vertical: 5,
                        ),
                        decoration: const BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                        ),
                        child: Text(
                          "${widget.userModel.matchPercentage}% match",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Obx(
                            () => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${widget.userModel.fullName} (${calculateAge(userModel.value?.dob ?? "").toString()})",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(widget.userModel.location?.address ?? ""),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            "About",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Obx(
                            () {
                              if (userModel.value == null) {
                                return const SizedBox.shrink();
                              }
                              bool shouldTruncate =
                                  userModel.value!.bio!.length > maxBioLength;
                              String displayBio = shouldTruncate &&
                                      !isExpanded.value
                                  ? "${userModel.value!.bio!.substring(0, maxBioLength)}..."
                                  : userModel.value!.bio!;

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    displayBio,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  if (shouldTruncate)
                                    GestureDetector(
                                      onTap: () => isExpanded.toggle(),
                                      child: Text(
                                        isExpanded.value
                                            ? "Show less"
                                            : "Show more",
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.orange,
                                        ),
                                      ),
                                    ),
                                ],
                              );
                            },
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            "Basic Information",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Obx(
                            () => buildBasicInfoTile(
                              leading: "Gender: ",
                              title:
                                  userModel.value?.gender?.toUpperCase() ?? "",
                            ),
                          ),
                          Obx(() {
                            String dob = userModel.value?.dob ?? "";
                            if (dob.isEmpty) return const SizedBox.shrink();
                            int age = calculateAge(dob);
                            return buildBasicInfoTile(
                              leading: "Age: ",
                              title: "${age.toString()} Years Old",
                            );
                          }),
                          const SizedBox(height: 30),
                          const Text(
                            "Hobbies",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: Colors.black,
                            ),
                          ),
                          Obx(() {
                            List? hobbies =
                                _userController.userModel.value?.hobbies;
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
                          const SizedBox(height: 20),
                          TinderCardDetailsButton(
                            userId: widget.userModel.id ?? "",
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.flag, color: Colors.white),
                              label: const Text("Report"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                                textStyle: const TextStyle(fontSize: 18),
                              ),
                              onPressed: () => _showReportBottomSheet(context),
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Obx(() {
            if (_userController.isloading.value) {
              return SizedBox(
                height: Get.height * 1,
                width: Get.width,
                child: Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryColor,
                  ),
                ),
              );
            } else {
              return const SizedBox.shrink();
            }
          })
        ],
      ),
    );
  }

  void _showReportBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return ReportBottomSheet();
      },
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
  const StoryCard({
    super.key,
    required this.story,
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
      onTap: () {
        Get.to(() => ViewStoryFullScreen(story: widget.story));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 32,
              backgroundColor: AppColors.primaryColor,
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
  const HeaderHomeWidget({
    super.key,
  });

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
              InkWell(
                onTap: () async {
                  Get.to(() => const LiveStreamListScreen());
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
    );
  }
}

class StoryCardBuilderWidget extends StatelessWidget {
  StoryCardBuilderWidget({super.key});

  final _storyController = Get.find<StoryController>();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Obx(() {
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
      }),
    );
  }
}

class UserPostedStoryWidget extends StatelessWidget {
  UserPostedStoryWidget({super.key});
  final _userController = Get.find<UserController>();
  final _storyController = Get.find<StoryController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
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
    });
  }
}

class SwiperActionButtonsWidget extends StatelessWidget {
  final CardSwiperController controller;

  SwiperActionButtonsWidget({super.key, required this.controller});

  final _userController = Get.find<UserController>();

  // State variables to track animation triggers
  final RxBool isLiking = false.obs;
  final RxBool isDisliking = false.obs;
  final RxBool isSuperLiking = false.obs;

  void _triggerAnimation(CardSwiperDirection direction,
      {bool isSuperLike = false}) {
    if (direction == CardSwiperDirection.right) {
      if (isSuperLike) {
        isSuperLiking.value = true;
      } else {
        isLiking.value = true;
      }
    } else if (direction == CardSwiperDirection.left) {
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
                  // DISLIKE BUTTON (❌) - Swipes Left
                  Obx(
                    () => AnimatedOpacity(
                      duration: const Duration(milliseconds: 200),
                      opacity: isDisliking.value ? 1.0 : 0.7,
                      child: Bounce(
                        from: isDisliking.value ? 20 : 10,
                        child: actionButton(
                          FontAwesomeIcons.xmark,
                          Colors.white,
                          false,
                          () {
                            _triggerAnimation(CardSwiperDirection.left);
                            controller.swipe(CardSwiperDirection.left);
                          },
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 20),

                  // LIKE BUTTON (❤️) - Swipes Right
                  Obx(
                    () => AnimatedScale(
                      scale: isLiking.value ? 1.2 : 1.0,
                      duration: const Duration(milliseconds: 200),
                      child: Bounce(
                        from: isLiking.value ? 30 : 15,
                        child: actionButton(
                          FontAwesomeIcons.solidHeart,
                          Colors.orange,
                          true,
                          () {
                            _triggerAnimation(CardSwiperDirection.right);
                            controller.swipe(CardSwiperDirection.right);
                          },
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 20),

                  // SUPER LIKE BUTTON (⭐) - Swipes Right
                  Obx(
                    () => AnimatedScale(
                      scale: isSuperLiking.value ? 1.2 : 1.0,
                      duration: const Duration(milliseconds: 200),
                      child: Bounce(
                        from: isSuperLiking.value ? 25 : 10,
                        delay: const Duration(milliseconds: 400),
                        child: actionButton(
                          Icons.star_border,
                          Colors.white,
                          false,
                          () {
                            _triggerAnimation(CardSwiperDirection.right,
                                isSuperLike: true);
                            controller.swipe(CardSwiperDirection.right);
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class GetPotentialMatchesBuilder extends StatelessWidget {
  GetPotentialMatchesBuilder({super.key});
  final _userController = Get.find<UserController>();
  final _cardSwipeController = CardSwiperController();

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
              return FadeIn(
                duration: const Duration(milliseconds: 500),
                child: const Center(
                  child: Text(
                    "No matches found",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              );
            }

            return CardSwiper(
              controller: _cardSwipeController,
              isLoop: false,
              cardsCount: _userController.potentialMatchesList.length,
              onSwipe: (previousIndex, currentIndex, direction) {
                if (_userController.potentialMatchesList.isEmpty ||
                    previousIndex >=
                        _userController.potentialMatchesList.length) {
                  return false;
                }
                final userId =
                    _userController.potentialMatchesList[previousIndex].id ??
                        "";
                _userController.addSwipeToQueue(userId, direction);
                return true;
              },
              numberOfCardsDisplayed:
                  _userController.potentialMatchesList.length > 1
                      ? 2
                      : _userController.potentialMatchesList.length,
              allowedSwipeDirection: const AllowedSwipeDirection.symmetric(
                horizontal: true,
              ),
              onEnd: () {
                _userController.potentialMatchesList.clear();
              },
              cardBuilder: (
                context,
                index,
                horizontalOffsetPercentage,
                verticalOffsetPercentage,
              ) {
                if (index == _userController.potentialMatchesList.length - 2 &&
                    _userController.hasNextPage) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _userController.getPotentialMatches(loadMore: true);
                  });
                }

                final profile = _userController.potentialMatchesList[index];
                return ElasticIn(
                  child: InkWell(
                    onTap: () {
                      Get.to(
                        () => TinderCardDetails(
                          userModel: profile,
                        ),
                      );
                    },
                    child: TinderCard(profile: profile),
                  ),
                );
              },
            );
          }),
          SwiperActionButtonsWidget(controller: _cardSwipeController),
        ],
      ),
    );
  }
}

class ReportBottomSheet extends StatefulWidget {
  const ReportBottomSheet({super.key});

  @override
  _ReportBottomSheetState createState() => _ReportBottomSheetState();
}

class _ReportBottomSheetState extends State<ReportBottomSheet> {
  bool _isLoading = false;

  final List<String> _reportReasons = [
    "No reason",
    "I'm not interested in this person",
    "Profile is fake, spam, or scammer",
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
    return Obx(
      () => _userController.potentialMatchesList.isEmpty
          ? const SizedBox.shrink()
          : Container(
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
                      bool isSwiped = await _userController.swipeDislike(
                          swipedUserId: userId);
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
