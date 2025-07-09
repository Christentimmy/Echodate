import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:echodate/app/controller/user_controller.dart';
import 'package:echodate/app/modules/home/views/alt_tinder_card_details.dart';
import 'package:echodate/app/modules/home/widgets/home_widgets.dart';
import 'package:echodate/app/modules/home/widgets/tinder_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

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
                  await swipeEnd();
                },
                onSwipeEnd: (previousIndex, targetIndex, activity) {
                  swipe(previousIndex, targetIndex, activity);
                },
                cardBuilder: (context, index) {
                  final profile = _userController.potentialMatchesList[index];
                  return InkWell(
                    child: TinderCard(profile: profile),
                    onTap: () {
                      Get.to(() => AltTinderCardDetails(userModel: profile));
                    },
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

  Widget _buildEmptySwipeCardWidget() {
    return const Center(
      child: Text(
        "No matches found",
        style: TextStyle(color: Colors.black),
      ),
    ).animate(
      effects: [
        const Effect(curve: Curves.ease),
      ],
      delay: const Duration(milliseconds: 500),
    );
  }

  void swipe(previousIndex, targetIndex, activity) {
    if (_userController.potentialMatchesList.isEmpty ||
        previousIndex >= _userController.potentialMatchesList.length) {
      return;
    }
    final userId = _userController.potentialMatchesList[previousIndex].id ?? "";
    if (activity.direction == AxisDirection.right) {
      _userController.swipeLike(swipedUserId: userId);
    } else if (activity.direction == AxisDirection.left) {
      _userController.swipeDislike(swipedUserId: userId);
    } else if (activity.direction == AxisDirection.up) {
      _userController.swipeSuperLike(swipedUserId: userId);
    }
  }

  Future<void> swipeEnd() async {
    if (_userController.hasNextPage) {
      await _userController.getPotentialMatches(loadMore: true);
    } else {
      _userController.potentialMatchesList.clear();
    }
  }
}
