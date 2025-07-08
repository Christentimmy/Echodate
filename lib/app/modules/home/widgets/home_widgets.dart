import 'package:echodate/app/controller/user_controller.dart';
import 'package:echodate/app/modules/profile/views/alt_profile_screen.dart';
import 'package:echodate/app/resources/colors.dart';
import 'package:echodate/app/widget/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:appinio_swiper/appinio_swiper.dart';

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




