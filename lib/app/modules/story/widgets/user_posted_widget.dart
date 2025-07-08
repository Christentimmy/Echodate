import 'package:echodate/app/controller/user_controller.dart';
import 'package:echodate/app/models/story_model.dart';
import 'package:echodate/app/modules/story/views/create_story_screen.dart';
import 'package:echodate/app/modules/story/views/view_story_full_screen.dart';
import 'package:echodate/app/modules/story/widgets/story_card_widget.dart';
import 'package:echodate/app/resources/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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