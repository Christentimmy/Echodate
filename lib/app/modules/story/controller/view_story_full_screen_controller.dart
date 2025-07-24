import 'package:echodate/app/controller/story_controller.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class ViewStoryFullScreenController extends GetxController {
  RxInt currentUserIndex = 0.obs;
  RxInt currentStoryIndex = 0.obs;
  RxInt tapIndexHomePage = 0.obs;

  final _storyController = Get.find<StoryController>();

  // Callback for when story changes (used by the view to restart timers)
  Function()? onStoryChanged;

  void init() {
    currentUserIndex.value = tapIndexHomePage.value;
    if (_storyController.allstoriesList.isEmpty) {
      return;
    }
    if (currentUserIndex.value >= _storyController.allstoriesList.length) {
      currentUserIndex.value = 0;
    }
    final userStory = _storyController.allstoriesList[currentUserIndex.value];
    if (userStory.stories?.isNotEmpty ?? false) {
      final story = userStory.stories![currentStoryIndex.value];
      _storyController.markStoryAsSeen(
        userStory.id,
        story.id,
        userStory.userId,
      );
    }
  }

  void goToNextStory() {
    // ADD BOUNDS CHECKING:
    if (currentUserIndex.value >= _storyController.allstoriesList.length) {
      return Navigator.pop(Get.context!);
    }

    final storyModel = _storyController.allstoriesList[currentUserIndex.value];
    final stories = storyModel.stories;
    final allStories = _storyController.allstoriesList;

    if (stories == null || stories.isEmpty) {
      return Navigator.pop(Get.context!);
    }

    if (currentStoryIndex.value < stories.length - 1) {
      currentStoryIndex.value++;
      // ADD BOUNDS CHECK HERE TOO:
      if (currentStoryIndex.value < stories.length) {
        final story = stories[currentStoryIndex.value];
        _storyController.markStoryAsSeen(
          storyModel.id,
          story.id ?? "",
          storyModel.userId ?? "",
        );
      }
    } else if (currentUserIndex.value < allStories.length - 1) {
      currentUserIndex.value++;
      currentStoryIndex.value = 0;
      // ADD SAFETY CHECK:
      if (currentUserIndex.value < allStories.length) {
        final nextStoryModel = allStories[currentUserIndex.value];
        if (nextStoryModel.stories?.isNotEmpty ?? false) {
          final story = nextStoryModel.stories![0];
          _storyController.markStoryAsSeen(
            nextStoryModel.id,
            story.id ?? "",
            nextStoryModel.userId ?? "",
          );
        }
      }
    } else {
      Navigator.pop(Get.context!);
    }

    onStoryChanged?.call();
  }

  void goToPreviousStory() {
    final storyModel = _storyController.allstoriesList[currentUserIndex.value];
    final stories = storyModel.stories;
    final allStories = _storyController.allstoriesList;

    if (stories == null || stories.isEmpty) {
      return;
    }

    if (currentStoryIndex.value > 0) {
      currentStoryIndex.value--;
      final story = stories[currentStoryIndex.value];
      _storyController.markStoryAsSeen(
        storyModel.id ?? "",
        story.id ?? "",
        storyModel.userId ?? "",
      );
    } else if (currentUserIndex.value > 0) {
      currentUserIndex.value--;
      final prevStoryModel = allStories[currentUserIndex.value];
      currentStoryIndex.value = (prevStoryModel.stories?.length ?? 1) - 1;
      if (prevStoryModel.stories?.isNotEmpty ?? false) {
        final story = prevStoryModel.stories![currentStoryIndex.value];
        _storyController.markStoryAsSeen(
          prevStoryModel.id ?? "",
          story.id ?? "",
          prevStoryModel.userId ?? "",
        );
      }
    }

    // Notify view that story changed
    onStoryChanged?.call();
  }
}
