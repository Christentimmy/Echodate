import 'package:cached_network_image/cached_network_image.dart';
import 'package:echodate/app/controller/story_controller.dart';
import 'package:echodate/app/controller/user_controller.dart';
import 'package:echodate/app/models/story_model.dart';
import 'package:echodate/app/modules/story/controller/view_story_full_screen_controller.dart';
import 'package:echodate/app/modules/story/widgets/create_story_widgets.dart';
import 'package:echodate/app/modules/story/widgets/story_video_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ViewStoryFullScreen extends StatefulWidget {
  const ViewStoryFullScreen({super.key});

  @override
  State<ViewStoryFullScreen> createState() => _ViewStoryFullScreenState();
}

class _ViewStoryFullScreenState extends State<ViewStoryFullScreen> {
  final _userController = Get.find<UserController>();
  final _storyController = Get.find<StoryController>();
  final _viewStoryScreenController = Get.find<ViewStoryFullScreenController>();

  @override
  void initState() {
    super.initState();
    _viewStoryScreenController.init();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!_hasValidStories()) {
        return _buildNoStoriesView();
      }

      final storyModel = _getCurrentStoryModel();
      final stories = storyModel.stories;
      if (stories == null || stories.isEmpty) {
        return _buildNoStoriesView();
      }

      final story = stories[_viewStoryScreenController.currentStoryIndex.value];

      return Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            _buildStoryMedia(story),
            _buildGestureDetector(context, storyModel),
            _buildProgressIndicator(storyModel),
            _buildStoryContent(story),
            _buildStoryViewers(storyModel, story),
          ],
        ),
      );
    });
  }

  bool _hasValidStories() {
    if (_storyController.allstoriesList.isEmpty) return false;

    final index = _viewStoryScreenController.currentUserIndex.value;
    if (index >= _storyController.allstoriesList.length) {
      _viewStoryScreenController.currentUserIndex.value = 0;
    }
    return true;
  }

  StoryModel _getCurrentStoryModel() {
    final index = _viewStoryScreenController.currentUserIndex.value;
    return _storyController.allstoriesList[index];
  }

  Widget _buildNoStoriesView() {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Text(
          'No stories available',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildStoryMedia(Stories story) {
    return Center(
      child: story.mediaType == 'video'
          ? VideoPlayerWidget(url: story.mediaUrl ?? "")
          : CachedNetworkImage(
              imageUrl: story.mediaUrl ?? "",
              width: Get.width,
              height: Get.height * 0.67,
              fit: BoxFit.fitHeight,
              errorWidget: (context, url, error) =>
                  const Icon(Icons.broken_image),
              placeholder: (context, url) => const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
    );
  }

  Widget _buildGestureDetector(
    BuildContext context,
    StoryModel storyModel,
  ) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onLongPress: () async {
        final userId = _userController.userModel.value?.id ?? "";
        await displayDeleteStoryDialog(
          context: context,
          userId: userId,
          storyUserId: storyModel.userId ?? "",
          storyId: storyModel.id ?? "",
          controller: _storyController,
        );
      },
      onTapDown: (details) {
        final width = Get.width;
        if (details.globalPosition.dx < width / 2) {
          _viewStoryScreenController.goToPreviousStory();
        } else {
          _viewStoryScreenController.goToNextStory();
        }
      },
    );
  }

  Widget _buildProgressIndicator(
    StoryModel storyModel,
  ) {
    return Positioned(
      top: 40,
      left: 10,
      right: 10,
      child: Row(
        children: storyModel.stories!.map((s) {
          final index = storyModel.stories!.indexOf(s);
          return Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 1),
              height: 2,
              color: index < _viewStoryScreenController.currentStoryIndex.value
                  ? Colors.white
                  : index == _viewStoryScreenController.currentStoryIndex.value
                      ? Colors.white.withOpacity(0.8)
                      : Colors.white.withOpacity(0.3),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildStoryContent(Stories story) {
    return Positioned(
      bottom: Get.height * 0.15,
      left: 0,
      right: 0,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.6),
        ),
        child: Text(
          story.content ?? '',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.left,
        ),
      ),
    );
  }

  Widget _buildStoryViewers(
    StoryModel storyModel,
    Stories story,
  ) {
    return Obx(() => _userController.userModel.value?.id == storyModel.userId
        ? Align(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              onTap: () {},
              child: ViewSoryViewersWidget(
                stories: story,
                story: storyModel,
              ),
            ),
          )
        : const SizedBox.shrink());
  }
}
