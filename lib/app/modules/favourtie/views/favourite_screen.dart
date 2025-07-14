import 'package:echodate/app/controller/user_controller.dart';
import 'package:echodate/app/modules/favourtie/widgets/favourite_screen_wigets.dart';
import 'package:echodate/app/resources/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({super.key});

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  final _userController = Get.find<UserController>();

  
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_userController.isGetUserWhoLikesMeFetched.value) {
        _userController.getUserWhoLikesMe();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: const Text(
          "Likes",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          buildFilterIcon(
            context,
            (value) async {
              await _userController.getUserWhoLikesMe(filter: value);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.primaryColor,
          onRefresh: () async {
            await _userController.getUserWhoLikesMe();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 15,
              ),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Obx(() {
                    if (_userController.isloading.value) {
                      return SizedBox(
                        height: Get.height * 0.7,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primaryColor,
                          ),
                        ),
                      );
                    } else if (_userController.usersWhoLikesMeList.isEmpty) {
                      return SizedBox(
                        height: Get.height * 0.7,
                        child: const Center(
                          child: Text(
                            "No likes found.",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      );
                    } else {
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _userController.usersWhoLikesMeList.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.7,
                          crossAxisSpacing: 10.0,
                          mainAxisSpacing: 10.0,
                        ),
                        itemBuilder: (context, index) {
                          final matchUserModel =
                              _userController.usersWhoLikesMeList[index];
                          return LikeAndMatchCard(
                            userController: _userController,
                            matchUserModel: matchUserModel,
                          );
                        },
                      );
                    }
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
