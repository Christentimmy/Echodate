import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:echodate/app/controller/user_controller.dart';
import 'package:echodate/app/models/chat_list_model.dart';
import 'package:echodate/app/models/user_model.dart';
import 'package:echodate/app/modules/chat/views/chat_screen.dart';
import 'package:echodate/app/modules/echocoin/views/send_coins_screen.dart';
import 'package:echodate/app/modules/home/controller/tinder_card_controller.dart';
import 'package:echodate/app/modules/home/widgets/shimmer_loader.dart';
import 'package:echodate/app/resources/colors.dart';
import 'package:echodate/app/utils/age_calculator.dart';
import 'package:echodate/app/widget/animated_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class AltTinderCardDetails extends StatefulWidget {
  final UserModel userModel;
  const AltTinderCardDetails({
    super.key,
    required this.userModel,
  });

  @override
  State<AltTinderCardDetails> createState() => _AltTinderCardDetailsState();
}

class _AltTinderCardDetailsState extends State<AltTinderCardDetails> {
  final _tinderCardController = Get.put(TinderCardController());
  final _userController = Get.find<UserController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _tinderCardController.getUserDetails(id: widget.userModel.id ?? "");
    });
  }

  @override
  void dispose() {
    Get.delete<TinderCardController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Obx(
        () => _userController.isloading.value
            ? const EnhancedAltTinderCardShimmerLoader()
            : Stack(
                children: [
                  _buildImageWidget(),
                  _buildFilter(),
                  _buildTopActions(context),
                  _buildIndicator(),
                  _buildContent(),
                ],
              ),
      ),
    );
  }

  Container _buildContent() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 15,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            children: [
              Obx(() {
                final userModel = _tinderCardController.userModel.value;
                if (userModel == null) return const SizedBox.shrink();
                String firstName = userModel.fullName?.split(" ")[0] ?? "";
                String dob = userModel.dob ?? "";
                if (dob.isEmpty) return const SizedBox.shrink();
                int age = calculateAge(dob);
                return Text(
                  "$firstName, $age",
                  style: GoogleFonts.montserrat(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                );
              }),
              const Spacer(),
              Row(
                children: [
                  const Icon(
                    Icons.location_pin,
                    color: Colors.white,
                  ),
                  Text(
                    widget.userModel.location?.address ?? "",
                    style: GoogleFonts.montserrat(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 15),
          Obx(() {
            List? hobbies = _tinderCardController.userModel.value?.hobbies;
            if (hobbies == null || hobbies.isEmpty) {
              return const SizedBox.shrink();
            }
            return Wrap(
              spacing: 8,
              runSpacing: 8,
              children: hobbies.map((interest) {
                return _buildNewInterestCards(interest: interest);
              }).toList(),
            );
          }),
          const SizedBox(height: 15),
          _buildUserBio(),
          SwipeButtonsRow(
            userId: widget.userModel.id ?? "",
            onDislike: () async {
              await _userController.swipeDislike(
                swipedUserId: widget.userModel.id ?? "",
              );
              _userController.potentialMatchesList.removeWhere(
                (e) => e.id == widget.userModel.id,
              );
            },
            onLike: () async {
              await _userController.swipeLike(
                swipedUserId: widget.userModel.id ?? "",
              );
              _userController.potentialMatchesList.removeWhere(
                (e) => e.id == widget.userModel.id,
              );
            },
          ),
        ],
      ),
    );
  }

  Positioned _buildIndicator() {
    return Positioned(
      bottom: Get.height / 2.85,
      left: Get.width / 2.4,
      child: Obx(() {
        final userModel = _tinderCardController.userModel;
        if (userModel.value?.photos != null &&
            userModel.value!.photos!.isNotEmpty) {
          return Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 5,
              vertical: 2,
            ),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: AnimatedSmoothIndicator(
              activeIndex: _tinderCardController.activeIndex.value,
              count: _tinderCardController.cleanPhotos.length,
              effect: ExpandingDotsEffect(
                dotWidth: 8,
                dotHeight: 7,
                activeDotColor: AppColors.primaryColor,
                dotColor: Colors.grey.withOpacity(0.8),
                spacing: 4,
              ),
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      }),
    );
  }

  SizedBox _buildImageWidget() {
    return SizedBox(
      width: Get.width,
      height: Get.height,
      child: Obx(() {
        final activeIndex = _tinderCardController.activeIndex;
        final cleanPhotos = _tinderCardController.cleanPhotos;

        if (_userController.isloading.value) {
          return _buildShimmerLoader();
        }

        if (cleanPhotos.isNotEmpty) {
          return PageView.builder(
            onPageChanged: (value) {
              activeIndex.value = value;
            },
            itemCount: cleanPhotos.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final picture = cleanPhotos[index];
              return CachedNetworkImage(
                imageUrl: picture,
                fit: BoxFit.fitHeight,
                height: Get.height * 0.6,
                width: Get.width,
                placeholder: (context, url) {
                  return _buildShimmerLoader();
                },
                errorWidget: (context, url, error) {
                  return const Icon(Icons.broken_image);
                },
              );
            },
          );
        } else {
          return CachedNetworkImage(
            imageUrl: widget.userModel.avatar ?? "",
            fit: BoxFit.fitHeight,
            height: Get.height * 0.6,
            width: Get.width,
            placeholder: (context, url) {
              return _buildShimmerLoader();
            },
            errorWidget: (context, url, error) => const Icon(Icons.error),
          );
        }
      }),
    );
  }

  Widget _buildFilter() {
    return Obx(() {
      if (_tinderCardController.userModel.value == null) {
        return const SizedBox.shrink();
      } else {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: Get.height / 2.5,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.6),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [
                  0.0,
                  0.3,
                ],
              ),
            ),
          ),
        );
      }
    });
  }

  Widget _buildNewInterestCards({required String interest}) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.6),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        interest,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildUserBio() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              "About",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Colors.grey,
              ),
            ),
            const Spacer(),
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 10,
                  sigmaY: 10,
                ),
                child: InkWell(
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
                  child: Container(
                    height: 40,
                    width: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white.withOpacity(0.2),
                    ),
                    child: const Icon(
                      Icons.message,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Obx(() {
          final userModel = _tinderCardController.userModel.value;
          final maxBioLength = _tinderCardController.maxBioLength;
          bool isExpanded = _tinderCardController.isExpanded.value;

          if (userModel == null || userModel.bio == null) {
            return const SizedBox.shrink();
          }

          bool shouldTruncate = userModel.bio!.length > maxBioLength;
          String displayBio = shouldTruncate && !isExpanded
              ? "${userModel.bio!.substring(0, maxBioLength)}..."
              : userModel.bio!;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                displayBio,
                style: GoogleFonts.montserrat(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              if (shouldTruncate)
                GestureDetector(
                  onTap: () {
                    _tinderCardController.toggleShowFullBio();
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
        }),
      ],
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
              child: const Icon(
                Icons.close,
                size: 17,
                color: Colors.white,
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
                // Get.toNamed('/send-coins', arguments: {
                //   "recipientId": userModel?.id,
                //   "recipientName": userModel?.fullName,
                // });
                if (userModel == null) return;
                Get.to(
                  () => SendCoinsScreen(
                    recipientName: userModel.fullName!,
                    recipientId: userModel.id!,
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

  Widget _buildShimmerLoader() {
    return Shimmer.fromColors(
      baseColor: Colors.black.withOpacity(0.3),
      highlightColor: AppColors.primaryColor,
      child: const SizedBox(
        width: double.infinity,
        height: double.infinity,
      ),
    );
  }
}
