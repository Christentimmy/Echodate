import 'package:echodate/app/controller/story_controller.dart';
import 'package:echodate/app/controller/user_controller.dart';
import 'package:echodate/app/modules/story/controller/view_story_full_screen_controller.dart';
import 'package:echodate/app/modules/story/views/view_story_full_screen.dart';
import 'package:echodate/app/modules/story/widgets/story_card_widget.dart';
import 'package:echodate/app/modules/story/widgets/user_posted_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StoryCardBuilderWidget extends StatelessWidget {
  StoryCardBuilderWidget({super.key});

  final _storyController = Get.find<StoryController>();
  final _userController = Get.find<UserController>();
  final _viewStoryScreenController = Get.put(ViewStoryFullScreenController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (_storyController.allstoriesList.isEmpty) {
        return Align(
          alignment: Alignment.centerLeft,
          child: UserPostedStoryWidget(
            story: _storyController.emptyStoryModel,
            index: 0,
            allStories: const [],
          ),
        );
      }
      return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _storyController.allstoriesList.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return UserPostedStoryWidget(
              story: _storyController.allstoriesList.first,
              index: index,
              allStories: _storyController.allstoriesList,
            );
          }
          final storyIndex = index - 1;
          if (storyIndex >= _storyController.allstoriesList.length) {
            return const SizedBox.shrink();
          }
          final story = _storyController.allstoriesList[storyIndex];
          final userId = _userController.userModel.value?.id ?? "";

          if (story.stories == null || story.stories!.isEmpty) {
            return const SizedBox.shrink();
          }
          bool isSeen = story.stories
                  ?.every((s) => s.viewedBy?.contains(userId) ?? false) ??
              false;
          if (userId == story.userId) {
            return const SizedBox();
          }
          return StoryCard(
            story: story,
            allStories: _storyController.allstoriesList,
            index: index - 1,
            isSeen: isSeen,
            onTap: () {
              _viewStoryScreenController.tapIndexHomePage.value = index - 1;
              Get.to(() => const ViewStoryFullScreen());
            },
          );
        },
      );
    });
  }
}
