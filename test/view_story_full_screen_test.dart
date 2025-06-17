import 'package:echodate/app/controller/storage_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:echodate/app/controller/story_controller.dart';
import 'package:echodate/app/controller/user_controller.dart';
import 'package:echodate/app/modules/story/controller/view_story_full_screen_controller.dart';
import 'package:echodate/app/modules/story/views/view_story_full_screen.dart';

void main() {
  late StoryController storyController;
  late UserController userController;
  late ViewStoryFullScreenController viewStoryController;

  setUp(() {
    Get.put(StorageController());
    storyController = Get.put(StoryController());
    userController = Get.put(UserController());
    viewStoryController = Get.put(ViewStoryFullScreenController());
  });

  tearDown(() {
    Get.reset();
  });

  testWidgets('should show no stories message when no stories are available',
      (WidgetTester tester) async {
    // Arrange
    storyController.allstoriesList.clear();

    // Act
    await tester.pumpWidget(
      const MaterialApp(
        home: ViewStoryFullScreen(),
      ),
    );

    // Assert
    expect(find.text('No stories available'), findsOneWidget);
  });
}
