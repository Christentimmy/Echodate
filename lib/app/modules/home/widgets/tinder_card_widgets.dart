import 'package:cached_network_image/cached_network_image.dart';
import 'package:echodate/app/controller/user_controller.dart';
import 'package:echodate/app/models/chat_list_model.dart';
import 'package:echodate/app/models/user_model.dart';
import 'package:echodate/app/modules/Interest/widgets/interest_widgets.dart';
import 'package:echodate/app/modules/chat/views/chat_screen.dart';
import 'package:echodate/app/modules/home/controller/tinder_card_controller.dart';
import 'package:echodate/app/modules/home/views/send_coins_screen.dart';
import 'package:echodate/app/modules/home/widgets/home_widgets.dart';
import 'package:echodate/app/resources/colors.dart';
import 'package:echodate/app/utils/age_calculator.dart';
import 'package:echodate/app/widget/animations.dart';
import 'package:echodate/app/widget/loader.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:motion/motion.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

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
  final _userController = Get.find<UserController>();
  final _tinderCardController = Get.put(TinderCardController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _tinderCardController.getUserDetails(id: widget.userModel.id ?? "");
    });
  }

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
                            final activeIndex =
                                _tinderCardController.activeIndex;
                            final cleanPhotos =
                                _tinderCardController.cleanPhotos;
                            if (_userController.isloading.value) {
                              return SizedBox(
                                height: Get.height * 0.6,
                                width: Get.width,
                                child: const Center(
                                  child: Loader(),
                                ),
                              );
                            }
                            if (cleanPhotos.isNotEmpty) {
                              return PageView.builder(
                                onPageChanged: (value) {
                                  activeIndex.value = value;
                                },
                                itemCount: cleanPhotos.length,
                                itemBuilder: (context, index) {
                                  String picture = cleanPhotos[index];
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
                                Obx(() {
                                  final userModel =
                                      _tinderCardController.userModel;
                                  if (_userController.isloading.value) {
                                    return const SizedBox.shrink();
                                  }
                                  if (userModel.value?.plan != "free") {
                                    return InkWell(
                                      onTap: () {
                                        Get.to(
                                          () => CoinTransferScreen(
                                            recipientName:
                                                userModel.value?.fullName ?? "",
                                            recipientId:
                                                userModel.value?.id ?? "",
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
                                    );
                                  }
                                  return const SizedBox.shrink();
                                })
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
                                    final userModel =
                                        _tinderCardController.userModel;
                                    if (userModel.value?.photos != null &&
                                        userModel.value?.photos?.isNotEmpty ==
                                            true) {
                                      return AnimatedSmoothIndicator(
                                        activeIndex: _tinderCardController
                                            .activeIndex.value,
                                        count: _tinderCardController
                                            .cleanPhotos.length,
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
                                      final userModel =
                                          _tinderCardController.userModel;
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
                    widget.userModel.matchPercentage == 0
                        ? const SizedBox.shrink()
                        : Center(
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
                          Obx(() {
                            final userModel =
                                _tinderCardController.userModel.value;
                            String age =
                                calculateAge(userModel?.dob ?? "").toString();
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${widget.userModel.fullName} ($age)",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(userModel?.location?.address ?? ""),
                              ],
                            );
                          }),
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
                              final userModel =
                                  _tinderCardController.userModel.value;
                              final maxBioLength =
                                  _tinderCardController.maxBioLength;
                              bool isExpanded =
                                  _tinderCardController.isExpanded.value;
                              if (userModel == null) {
                                return const SizedBox.shrink();
                              }
                              bool shouldTruncate =
                                  userModel.bio!.length > maxBioLength;
                              String displayBio = shouldTruncate && !isExpanded
                                  ? "${userModel.bio!.substring(0, maxBioLength)}..."
                                  : userModel.bio!;

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
                                      onTap: () {
                                        isExpanded = !isExpanded;
                                      },
                                      child: Text(
                                        isExpanded ? "Show less" : "Show more",
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
                              title: _tinderCardController
                                      .userModel.value?.gender
                                      ?.toUpperCase() ??
                                  "",
                            ),
                          ),
                          Obx(() {
                            final userModel = _tinderCardController.userModel;
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
