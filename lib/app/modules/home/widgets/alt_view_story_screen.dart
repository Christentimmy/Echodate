import 'package:echodate/app/models/story_model.dart';
import 'package:flutter/material.dart';

class StoryViewer extends StatefulWidget {
  final List<StoryModel> users;
  final int index;

  const StoryViewer({super.key, required this.users, required this.index});

  @override
  _StoryViewerState createState() => _StoryViewerState();
}

class _StoryViewerState extends State<StoryViewer> {
  int currentUserIndex = 0;
  int currentStoryIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        currentUserIndex = widget.index;
      });
    });
  }

  void goToNextStory() {
    final stories = widget.users[currentUserIndex].stories;
    if (stories == null || stories.isEmpty == true) {
      return Navigator.pop(context);
    }

    if (currentStoryIndex < stories.length - 1) {
      setState(() => currentStoryIndex++);
    } else if (currentUserIndex < widget.users.length - 1) {
      setState(() {
        currentUserIndex++;
        currentStoryIndex = 0;
      });
    } else {
      Navigator.pop(context); // end of all stories
    }
  }

  void goToPreviousStory() {
    if (currentStoryIndex > 0) {
      setState(() => currentStoryIndex--);
    } else if (currentUserIndex > 0) {
      setState(() {
        currentUserIndex--;
        currentStoryIndex = widget.users[currentUserIndex].stories!.length - 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.users[currentUserIndex];
    final story = user.stories![currentStoryIndex];

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
              child: story.mediaType == 'image'
                  ? Image.network(
                      story.mediaUrl!,
                      fit: BoxFit.contain,
                      height: double.infinity,
                      width: double.infinity,
                    )
                  : const Text("Video")
              // : VideoPlayerWidget(url: story.mediaUrl), // custom video widget
              ),

          // Gesture detection
          GestureDetector(
            behavior: HitTestBehavior.translucent,
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
              children: user.stories!.map((s) {
                final index = user.stories!.indexOf(s);
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

          // User name
          Positioned(
            top: 50,
            left: 16,
            child: Text(
              user.fullName ?? "",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }
}
