import 'package:echodate/app/controller/user_controller.dart';
import 'package:echodate/app/modules/home/widgets/preference_bottomsheet.dart';
import 'package:echodate/app/modules/profile/views/alt_profile_screen.dart';
import 'package:echodate/app/resources/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:appinio_swiper/appinio_swiper.dart';

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
              Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color:
                      Get.isDarkMode ? const Color(0xFF2D2D2D) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: IconButton(
                  onPressed: () => PreferenceBottomSheet.show(context),
                  icon: Icon(
                    Icons.tune,
                    color: AppColors.primaryColor,
                  ),
                  tooltip: "Preferences",
                ),
              ),
              Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color:
                      Get.isDarkMode ? const Color(0xFF2D2D2D) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: IconButton(
                  onPressed: () {
                    Get.to(() => const ProfileScreen());
                  },
                  icon: Icon(
                    Icons.person,
                    color: AppColors.primaryColor,
                    size: 17,
                  ),
                  tooltip: "Profile",
                ),
              ),

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
