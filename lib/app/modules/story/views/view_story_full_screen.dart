import 'package:cached_network_image/cached_network_image.dart';
import 'package:echodate/app/controller/story_controller.dart';
import 'package:echodate/app/controller/user_controller.dart';
import 'package:echodate/app/models/story_model.dart';
import 'package:echodate/app/modules/story/widgets/create_story_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class ViewStoryFullScreen extends StatefulWidget {
  final List<StoryModel> users;
  final int index;
  const ViewStoryFullScreen({
    super.key,
    required this.users,
    required this.index,
  });

  @override
  State<ViewStoryFullScreen> createState() => _ViewStoryFullScreenState();
}

class _ViewStoryFullScreenState extends State<ViewStoryFullScreen> {
  final PageController _pageController = PageController();
  final _userController = Get.find<UserController>();
  final _storyController = Get.find<StoryController>();
  VideoPlayerController? _videoController;
  int currentUserIndex = 0;
  int currentStoryIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setState(() {
        currentUserIndex = widget.index;
      });
      final user = widget.users[currentUserIndex];
      final story = user.stories![currentStoryIndex];
      _storyController.markStoryAsSeen(user.id, story.id, user.userId);
    });
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _pageController.dispose();
    _storyController.viewStory();
    super.dispose();
  }

  void goToNextStory() {
    final stories = widget.users[currentUserIndex].stories;
    if (stories == null || stories.isEmpty == true) {
      return Navigator.pop(context);
    }

    if (currentStoryIndex < stories.length - 1) {
      setState(() => currentStoryIndex++);
      final story = stories[currentStoryIndex];
      _storyController.markStoryAsSeen(
        widget.users[currentUserIndex].id ?? "",
        story.id ?? "",
        widget.users[currentUserIndex].userId ?? "",
      );
    } else if (currentUserIndex < widget.users.length - 1) {
      setState(() {
        currentUserIndex++;
        currentStoryIndex = 0;
      });
      final story = widget.users[currentUserIndex].stories![0];
      _storyController.markStoryAsSeen(
        widget.users[currentUserIndex].id ?? "",
        story.id ?? "",
        widget.users[currentUserIndex].userId ?? "",
      );
    } else {
      Navigator.pop(context); // end of all stories
    }
  }

  void goToPreviousStory() {
    if (currentStoryIndex > 0) {
      setState(() => currentStoryIndex--);
      final story = widget.users[currentUserIndex].stories![currentStoryIndex];
      _storyController.markStoryAsSeen(
        widget.users[currentUserIndex].id ?? "",
        story.id ?? "",
        widget.users[currentUserIndex].userId ?? "",
      );
    } else if (currentUserIndex > 0) {
      setState(() {
        currentUserIndex--;
        currentStoryIndex = widget.users[currentUserIndex].stories!.length - 1;
      });
      final story = widget.users[currentUserIndex].stories![currentStoryIndex];
      _storyController.markStoryAsSeen(
        widget.users[currentUserIndex].id ?? "",
        story.id ?? "",
        widget.users[currentUserIndex].userId ?? "",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final storyModel = widget.users[currentUserIndex];
    final story = storyModel.stories![currentStoryIndex];
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          story.mediaType == 'video'
              ? VideoPlayerWidget(url: story.mediaUrl ?? "")
              : Center(
                  child: CachedNetworkImage(
                    imageUrl: story.mediaUrl ?? "",
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.67,
                    fit: BoxFit.fitHeight,
                    errorWidget: (context, url, error) {
                      return const Icon(Icons.broken_image);
                    },
                    placeholder: (context, url) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      );
                    },
                  ),
                ),

          // Gesture detection
          GestureDetector(
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
              final width = MediaQuery.of(context).size.width;
              if (details.globalPosition.dx < width / 2) {
                goToPreviousStory();
              } else {
                goToNextStory();
              }
            },
          ),

          // Progress Indicator (optional)
          Positioned(
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
                    color: index < currentStoryIndex
                        ? Colors.white
                        : index == currentStoryIndex
                            ? Colors.white.withOpacity(0.8)
                            : Colors.white.withOpacity(0.3),
                  ),
                );
              }).toList(),
            ),
          ),

          Positioned(
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
          ),

          _userController.userModel.value?.id == storyModel.userId
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
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final String url;

  const VideoPlayerWidget({super.key, required this.url});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.url)
      ..initialize().then((_) {
        _controller.play();
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          )
        : const Center(child: CircularProgressIndicator());
  }
}
