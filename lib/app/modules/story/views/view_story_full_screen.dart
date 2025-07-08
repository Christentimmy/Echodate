import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:echodate/app/controller/story_controller.dart';
import 'package:echodate/app/controller/user_controller.dart';
import 'package:echodate/app/models/story_model.dart';
import 'package:echodate/app/modules/story/controller/view_story_full_screen_controller.dart';
import 'package:echodate/app/modules/story/widgets/create_story_widgets.dart';
import 'package:echodate/app/modules/story/widgets/story_video_player.dart';
import 'package:echodate/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ViewStoryFullScreen extends StatefulWidget {
  const ViewStoryFullScreen({super.key});

  @override
  State<ViewStoryFullScreen> createState() => _ViewStoryFullScreenState();
}

class _ViewStoryFullScreenState extends State<ViewStoryFullScreen>
    with TickerProviderStateMixin, RouteAware {
  final _userController = Get.find<UserController>();
  final _storyController = Get.find<StoryController>();
  final _viewStoryScreenController = Get.find<ViewStoryFullScreenController>();

  // Animation and Timer controllers
  late AnimationController _progressAnimationController;
  late Animation<double> _progressAnimation;
  Timer? _storyTimer;

  // Gesture and state management
  bool _isPaused = false;
  double _dragOffset = 0.0;
  bool _isDragging = false;

  // Story duration constants
  static const Duration _defaultStoryDuration = Duration(seconds: 5);
  static const double _dragThreshold = 0.2; // 20% of screen height

  // Video player reference
  GlobalKey<VideoPlayerWidgetState> _videoPlayerKey = GlobalKey();

  @override
  void didPop() async {
    await _storyController.markAllStoryViewed();
    super.didPop();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route is PageRoute) {
      routeObserver.subscribe(this, route);
    }
  }

  @override
  void initState() {
    super.initState();
    _viewStoryScreenController.init();
    _initializeProgressAnimation();
    _startStoryTimer();
  }

  @override
  void dispose() {
    _progressAnimationController.dispose();
    _storyTimer?.cancel();
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  void _initializeProgressAnimation() {
    _progressAnimationController = AnimationController(
      duration: _defaultStoryDuration,
      vsync: this,
    );

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_progressAnimationController);

    _progressAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed && !_isPaused) {
        _goToNextStory();
      }
    });
  }

  void _startStoryTimer() {
    if (!_hasValidStories()) return;

    final storyModel = _getCurrentStoryModel();
    final stories = storyModel.stories;
    if (stories == null || stories.isEmpty) return;

    final story = stories[_viewStoryScreenController.currentStoryIndex.value];

    _progressAnimationController.reset();

    if (story.mediaType == 'video') {
      _handleVideoStory(story);
    } else {
      _handleImageStory();
    }
  }

  void _handleVideoStory(Stories story) {
    // We'll set the duration when the video player calls onDurationChanged
    // For now, start with default duration as fallback
    _progressAnimationController.duration = _defaultStoryDuration;
    _progressAnimationController.forward();
  }

  void _onVideoDurationChanged(Duration duration) {
    // Update the animation controller with actual video duration
    _progressAnimationController.duration = duration;
    _progressAnimationController.reset();
    _progressAnimationController.forward();
  }

  void _onVideoCompleted() {
    // Auto advance when video completes
    if (!_isPaused) {
      _goToNextStory();
    }
  }

  void _handleImageStory() {
    _progressAnimationController.duration = _defaultStoryDuration;
    _progressAnimationController.forward();
  }

  void _pauseStory() {
    setState(() {
      _isPaused = true;
    });
    _progressAnimationController.stop();
    _storyTimer?.cancel();

    // Pause video if it's currently playing
    _videoPlayerKey.currentState?.pause();
  }

  void _resumeStory() {
    setState(() {
      _isPaused = false;
    });
    _progressAnimationController.forward();

    // Resume video if it exists
    _videoPlayerKey.currentState?.play();
  }

  void _goToNextStory() {
    _progressAnimationController.reset();
    _videoPlayerKey = GlobalKey(); // Reset video player key for new story
    _viewStoryScreenController.goToNextStory();
    if (_hasValidStories()) {
      _startStoryTimer();
    }
  }

  void _goToPreviousStory() {
    _progressAnimationController.reset();
    _videoPlayerKey = GlobalKey(); // Reset video player key for new story
    _viewStoryScreenController.goToPreviousStory();
    if (_hasValidStories()) {
      _startStoryTimer();
    }
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
        body: GestureDetector(
          onPanUpdate: (details) {
            setState(() {
              _isDragging = true;
              _dragOffset += details.delta.dy;
              if (_dragOffset < 0) _dragOffset = 0;
            });
          },
          onPanEnd: (details) {
            if (_dragOffset >
                MediaQuery.of(context).size.height * _dragThreshold) {
              Navigator.pop(context);
            } else {
              setState(() {
                _isDragging = false;
                _dragOffset = 0.0;
              });
            }
          },
          child: Transform.translate(
            offset: Offset(0, _dragOffset),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: _isDragging
                    ? BorderRadius.circular(20 * (_dragOffset / 100))
                    : BorderRadius.zero,
              ),
              child: Stack(
                children: [
                  _buildStoryMedia(story),
                  _buildGestureDetector(context, storyModel),
                  _buildAnimatedProgressIndicator(storyModel),
                  _buildStoryContent(story),
                  _buildStoryViewers(storyModel, story),
                ],
              ),
            ),
          ),
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
          ? VideoPlayerWidget(
              key: _videoPlayerKey,
              url: story.mediaUrl ?? "",
              onDurationChanged: _onVideoDurationChanged,
              onVideoCompleted: _onVideoCompleted,
              isPaused: _isPaused,
            )
          : CachedNetworkImage(
              imageUrl: story.mediaUrl ?? "",
              width: Get.width,
              height: Get.height * 0.67,
              // fit: BoxFit.cover,
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
      onLongPressStart: (_) => _pauseStory(),
      onLongPressEnd: (_) => _resumeStory(),
      onLongPress: () async {
        final userId = _userController.userModel.value?.id ?? "";
        final bool isSender = userId == storyModel.userId;
        if (!isSender) return;
        await displayDeleteStoryDialog(
          context: context,
          userId: userId,
          storyUserId: storyModel.userId ?? "",
          storyId: storyModel.id ?? "",
          controller: _storyController,
        );
      },
      onTapDown: (details) {
        if (_isDragging) return;

        final dx = details.globalPosition.dx;
        final screenWidth = Get.width;
        const edgeZoneWidth = 80.0;

        if (dx <= edgeZoneWidth) {
          _goToPreviousStory();
        } else if (dx >= screenWidth - edgeZoneWidth) {
          _goToNextStory();
        }
      },
    );
  }

  Widget _buildAnimatedProgressIndicator(StoryModel storyModel) {
    return Positioned(
      top: 40,
      left: 10,
      right: 10,
      child: Row(
        children: storyModel.stories!.asMap().entries.map((entry) {
          final index = entry.key;
          final currentIndex =
              _viewStoryScreenController.currentStoryIndex.value;

          return Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 1),
              height: 3,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(1.5),
                color: Colors.white.withOpacity(0.3),
              ),
              child: AnimatedBuilder(
                animation: _progressAnimation,
                builder: (context, child) {
                  double progress = 0.0;

                  if (index < currentIndex) {
                    progress = 1.0; // Completed stories
                  } else if (index == currentIndex) {
                    progress = _progressAnimation.value; // Current story
                  } else {
                    progress = 0.0; // Future stories
                  }

                  return LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.transparent,
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Colors.white),
                    minHeight: 3,
                  );
                },
              ),
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

  // Widget _buildPauseOverlay() {
  //   return Container(
  //     color: Colors.black.withOpacity(0.3),
  //     child: const Center(
  //       child: Icon(
  //         Icons.pause_circle_filled,
  //         color: Colors.white,
  //         size: 80,
  //       ),
  //     ),
  //   );
  // }
}
