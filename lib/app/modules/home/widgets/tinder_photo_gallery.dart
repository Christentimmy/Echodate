import 'package:cached_network_image/cached_network_image.dart';
import 'package:echodate/app/controller/user_controller.dart';
import 'package:echodate/app/models/user_model.dart';
import 'package:echodate/app/modules/chat/views/chat_screen.dart';
import 'package:echodate/app/modules/home/controller/tinder_card_controller.dart';
import 'package:echodate/app/resources/colors.dart';
import 'package:echodate/app/widget/loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../../app/models/chat_list_model.dart';

class TinderPhotoGallery extends StatelessWidget {
  final UserModel fallbackUser;

  TinderPhotoGallery({super.key, required this.fallbackUser});

  final TinderCardController _tinderCardController = Get.find();
  final UserController _userController = Get.find();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Get.height * 0.6,
      width: Get.width,
      child: Stack(
        children: [
          Obx(() {
            final activeIndex = _tinderCardController.activeIndex;
            final cleanPhotos = _tinderCardController.cleanPhotos;

            if (_userController.isloading.value) {
              return const Center(child: Loader());
            }

            if (cleanPhotos.isNotEmpty) {
              return PageView.builder(
                onPageChanged: (value) {
                  activeIndex.value = value;
                },
                itemCount: cleanPhotos.length,
                itemBuilder: (context, index) {
                  final picture = cleanPhotos[index];
                  return CachedNetworkImage(
                    imageUrl: picture,
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                    height: Get.height * 0.6,
                    width: Get.width,
                    placeholder: (context, url) {
                      return Center(
                        child: Loader(
                          color: AppColors.primaryColor,
                        ),
                      );
                    },
                  );
                },
              );
            } else {
              return CachedNetworkImage(
                imageUrl: fallbackUser.avatar ?? "",
                fit: BoxFit.cover,
                height: Get.height * 0.6,
                width: Get.width,
                placeholder: (context, url) {
                  return Center(
                    child: Loader(
                      color: AppColors.primaryColor,
                    ),
                  );
                },
                errorWidget: (context, url, error) => const Icon(Icons.error),
              );
            }
          }),
          // Top actions (back & wallet)
          _buildTopActions(context),

          // Indicator + chat button
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
                    final userModel = _tinderCardController.userModel;
                    if (userModel.value?.photos != null &&
                        userModel.value!.photos!.isNotEmpty) {
                      return AnimatedSmoothIndicator(
                        activeIndex: _tinderCardController.activeIndex.value,
                        count: _tinderCardController.cleanPhotos.length,
                        effect: ExpandingDotsEffect(
                          dotWidth: 10,
                          dotHeight: 10,
                          activeDotColor: AppColors.primaryColor,
                        ),
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  }),
                  SizedBox(width: Get.width / 4.8),
                  InkWell(
                    onTap: () {
                      final userModel = _tinderCardController.userModel;
                      final chatHead = ChatListModel(
                        userId: userModel.value?.id ?? "",
                        fullName: userModel.value?.fullName ?? "",
                        lastMessage: "",
                        avatar: userModel.value?.avatar ?? "",
                        unreadCount: 0,
                        online: false,
                      );
                      Get.to(() => ChatScreen(chatHead: chatHead));
                    },
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white.withOpacity(0.8),
                      child: Icon(
                        Icons.chat,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopActions(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 15,
        vertical: Get.height * 0.08,
      ),
      child: Row(
        children: [
          InkWell(
            onTap: () => Get.back(),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: Colors.grey.withOpacity(0.8),
              child: Icon(
                Icons.close,
                size: 17,
                color: AppColors.primaryColor,
              ),
            ),
          ),
          const Spacer(),
          Obx(() {
            final userModel = _tinderCardController.userModel.value;
            if (_userController.isloading.value || userModel?.plan == "free") {
              return const SizedBox.shrink();
            }
            return InkWell(
              onTap: () {
                Get.toNamed('/send-coins', arguments: {
                  "recipientId": userModel?.id,
                  "recipientName": userModel?.fullName,
                });
              },
              child: Container(
                height: 45,
                width: 45,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.primaryColor,
                ),
                child: const Icon(
                  Icons.account_balance_wallet,
                  color: Colors.white,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
