import 'package:echodate/app/models/story_model.dart';
import 'package:echodate/app/modules/story/widgets/create_story_widgets.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ViewStoryFullScreen extends StatefulWidget {
  final StoryModel story;

  const ViewStoryFullScreen({super.key, required this.story});

  @override
  State<ViewStoryFullScreen> createState() => _ViewStoryFullScreenState();
}

class _ViewStoryFullScreenState extends State<ViewStoryFullScreen> {
  final PageController _pageController = PageController();
  VideoPlayerController? _videoController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _initializeMedia(_currentIndex);
  }

  void _initializeMedia(int index) {
    if (widget.story.stories?[index].mediaType == 'video') {
      _videoController?.dispose();
      _videoController = VideoPlayerController.networkUrl(
        Uri.parse(widget.story.stories?[index].mediaUrl ?? ""),
      )..initialize().then((_) {
          setState(() {}); // Ensures the widget updates
          _videoController!.setVolume(1.0);
          _videoController!.play();
        }).catchError((error) {
          print("Video initialization error: $error");
        });
    } else {
      _videoController?.dispose();
      _videoController = null; // Reset if switching to an image
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Story Media Viewer
          PageView.builder(
            controller: _pageController,
            itemCount: widget.story.stories?.length ?? 0,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
                _initializeMedia(index);
              });
            },
            itemBuilder: (context, index) {
              final storiesModel = widget.story.stories?[index] ?? Stories();
              return ViewStoryFullSceenCard(
                pageController: _pageController,
                story: widget.story,
                storiesModel: storiesModel,
                videoController: _videoController,
              );
            },
          ),

          // Close Button (Top Left)
          Positioned(
            top: 40,
            left: 10,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}
