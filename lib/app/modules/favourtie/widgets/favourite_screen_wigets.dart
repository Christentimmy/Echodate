import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:echodate/app/controller/user_controller.dart';
import 'package:echodate/app/models/user_model.dart';
import 'package:echodate/app/modules/home/widgets/tinder_card_widget.dart';
import 'package:echodate/app/resources/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class LikeAndMatchCard extends StatelessWidget {
  final UserModel matchUserModel;
  LikeAndMatchCard({
    super.key,
    required UserController userController,
    required this.matchUserModel,
  });

  final UserController _userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (_userController.userModel.value?.plan != "free") {
          Get.to(
            () => TinderCardDetails(userModel: matchUserModel),
          );
        }
      },
      child: Container(
        height: Get.height * 0.3,
        width: Get.width * 0.47,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.primaryColor,
            width: 5,
          ),
        ),
        child: Stack(
          children: [
            _userController.userModel.value?.plan == "free"
                ? DisplayFreeCard(matchUserModel: matchUserModel)
                : DisplaySubCard(matchUserModel: matchUserModel),
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
            Padding(
              padding: const EdgeInsets.only(
                bottom: 12.0,
                left: 10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    matchUserModel.fullName ?? "",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    matchUserModel.location?.address ?? "",
                    style: const TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DisplaySubCard extends StatelessWidget {
  const DisplaySubCard({
    super.key,
    required this.matchUserModel,
  });

  final UserModel matchUserModel;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(13),
      child: CachedNetworkImage(
        imageUrl: matchUserModel.avatar ?? "",
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        placeholder: (context, url) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          );
        },
        errorWidget: (context, url, error) {
          return const Icon(Icons.error);
        },
      ),
    );
  }
}

class DisplayFreeCard extends StatelessWidget {
  const DisplayFreeCard({
    super.key,
    required this.matchUserModel,
  });

  final UserModel matchUserModel;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Stack(
        fit: StackFit.expand,
        children: [
          ImageFiltered(
            imageFilter: ImageFilter.blur(
              sigmaX: 5.0,
              sigmaY: 5.0,
            ),
            child: CachedNetworkImage(
              imageUrl: matchUserModel.avatar ?? "",
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
              placeholder: (context, url) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                );
              },
              errorWidget: (context, url, error) {
                return const Icon(Icons.error);
              },
            ),
          ),
          Container(
            color: Colors.black.withOpacity(0.2), // Optional overlay
          ),
        ],
      ),
    );
  }
}

Theme buildFilterIcon(BuildContext context, Function(String)? onSelectedMethod) {
  return Theme(
    data: Theme.of(context).copyWith(
      popupMenuTheme: PopupMenuThemeData(
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        textStyle: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    child: PopupMenuButton<String>(
      icon: const FaIcon(
        FontAwesomeIcons.filter,
        size: 20,
      ),
      onSelected: (value) {
        onSelectedMethod!(value);
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'recent',
          child: Text('Recent'),
        ),
        const PopupMenuItem(
          value: 'nearby',
          child: Text('Nearby'),
        ),
        const PopupMenuItem(
          value: 'likes-sent',
          child: Text('Active'),
        ),
        const PopupMenuItem(
          value: 'verified',
          child: Text('Verified'),
        ),
      ],
    ),
  );
}
