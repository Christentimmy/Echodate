import 'package:echodate/app/controller/story_controller.dart';
import 'package:echodate/main.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class ViewStoryFullScreenController extends GetxController with RouteAware {
  RxInt currentUserIndex = 0.obs;
  RxInt currentStoryIndex = 0.obs;
  RxInt tapIndexHomePage = 0.obs;

  final _storyController = Get.find<StoryController>();

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
    final route = ModalRoute.of(Get.context!);
    if (route is PageRoute) {
      routeObserver.subscribe(this, route);
    }
  }

  void goToNextStory() {
    final storyModel = _storyController.allstoriesList[currentUserIndex.value];
    final stories = storyModel.stories;
    final allStories = _storyController.allstoriesList;

    if (stories == null || stories.isEmpty) {
      return Navigator.pop(Get.context!);
    }

    if (currentStoryIndex.value < stories.length - 1) {
      currentStoryIndex.value++;
      final story = stories[currentStoryIndex.value];
      _storyController.markStoryAsSeen(
        storyModel.id,
        story.id ?? "",
        storyModel.userId ?? "",
      );
    } else if (currentUserIndex.value < allStories.length - 1) {
      currentUserIndex.value++;
      currentStoryIndex.value = 0;
      final nextStoryModel = allStories[currentUserIndex.value];
      if (nextStoryModel.stories?.isNotEmpty ?? false) {
        final story = nextStoryModel.stories![0];
        _storyController.markStoryAsSeen(
          nextStoryModel.id,
          story.id ?? "",
          nextStoryModel.userId ?? "",
        );
      }
    } else {
      Navigator.pop(Get.context!);
      // If we're at the last story of the last user, go back to the first story
      // currentUserIndex.value = 0;
      // currentStoryIndex.value = 0;
      // final firstStoryModel = allStories[0];
      // if (firstStoryModel.stories?.isNotEmpty ?? false) {
      //   final story = firstStoryModel.stories![0];
      //   _storyController.markStoryAsSeen(
      //     firstStoryModel.id,
      //     story.id ?? "",
      //     firstStoryModel.userId ?? "",
      //   );
      // }
    }
  }

  // void goToPreviousStory() {
  //   final storyModel = _storyController.allstoriesList[currentUserIndex.value];
  //   final allStories = _storyController.allstoriesList;

  //   if (currentStoryIndex.value > 0) {
  //     currentStoryIndex.value--;
  //     final story = storyModel.stories![currentStoryIndex.value];
  //     _storyController.markStoryAsSeen(
  //       storyModel.id ?? "",
  //       story.id ?? "",
  //       storyModel.userId ?? "",
  //     );
  //   } else if (currentUserIndex.value > 0) {
  //     currentUserIndex.value--;
  //     final prevStoryModel = allStories[currentUserIndex.value];
  //     currentStoryIndex.value = (prevStoryModel.stories?.length ?? 1) - 1;
  //     if (prevStoryModel.stories?.isNotEmpty ?? false) {
  //       final story = prevStoryModel.stories![currentStoryIndex.value];
  //       _storyController.markStoryAsSeen(
  //         prevStoryModel.id ?? "",
  //         story.id ?? "",
  //         prevStoryModel.userId ?? "",
  //       );
  //     }
  //   }
  //   // Navigator.pop(Get.context!);
  //   else {
  //     // If we're at the first story of the first user, go to the last story
  //     currentUserIndex.value = allStories.length - 1;
  //     final lastStoryModel = allStories[currentUserIndex.value];
  //     currentStoryIndex.value = (lastStoryModel.stories?.length ?? 1) - 1;
  //     if (lastStoryModel.stories?.isNotEmpty ?? false) {
  //       final story = lastStoryModel.stories![currentStoryIndex.value];
  //       _storyController.markStoryAsSeen(
  //         lastStoryModel.id ?? "",
  //         story.id ?? "",
  //         lastStoryModel.userId ?? "",
  //       );
  //     }
  //   }
  // }

  void goToPreviousStory() {
    final storyModel = _storyController.allstoriesList[currentUserIndex.value];
    final stories = storyModel.stories;
    if (currentStoryIndex > 0) {
      currentStoryIndex.value--;
      final story = stories![currentStoryIndex.value];
      _storyController.markStoryAsSeen(
        storyModel.id ?? "",
        story.id ?? "",
        storyModel.userId ?? "",
      );
    } else if (currentUserIndex > 0) {
      currentUserIndex.value--;
      currentStoryIndex.value = stories!.length - 1;
      final story = stories[currentStoryIndex.value];
      _storyController.markStoryAsSeen(
        storyModel.id ?? "",
        story.id ?? "",
        storyModel.userId ?? "",
      );
    }
  }

  @override
  void onClose() {
    routeObserver.unsubscribe(this);
    super.onClose();
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPop() async {
    await _storyController.markAllStoryViewed();
  }
}
