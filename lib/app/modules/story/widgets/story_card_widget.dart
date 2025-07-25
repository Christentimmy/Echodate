import 'package:cached_network_image/cached_network_image.dart';
import 'package:echodate/app/models/story_model.dart';
import 'package:echodate/app/resources/colors.dart';
import 'package:flutter/material.dart';

class StoryCard extends StatelessWidget {
  final StoryModel story;
  final List<StoryModel> allStories;
  final int index;
  final bool isSeen;
  final VoidCallback onTap;
  const StoryCard({
    super.key,
    required this.story,
    required this.allStories,
    required this.index,
    required this.isSeen,
    required this.onTap,
  });

  bool _isVideo(String url) {
    return url.endsWith(".mp4") ||
        url.endsWith(".mov") ||
        url.endsWith(".avi") ||
        url.endsWith(".mkv");
  }

  @override
  Widget build(BuildContext context) {
    if (story.stories == null || story.stories!.isEmpty) {
      return const SizedBox.shrink();
    }

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 32,
              backgroundColor: isSeen ? Colors.grey : AppColors.primaryColor,
              child: _buildMedia(),
            ),
            const SizedBox(height: 4),
            Text(
              story.fullName?.split(" ")[0].toString() ?? "",
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildMedia() {
    bool isVideo = _isVideo(story.stories?.first.mediaUrl ?? "");
    if (isVideo) {
      return _buildVideoThumbNail();
    } else {
      return _buildImage();
    }
  }

  CircleAvatar _buildImage() {
    return CircleAvatar(
      radius: 30,
      backgroundImage: CachedNetworkImageProvider(
        story.stories?.first.mediaUrl ?? "",
      ),
      onBackgroundImageError: (exception, stackTrace) {
        debugPrint('Story image load failed: $exception');
      },
      child: story.stories?.first.mediaUrl?.isEmpty ?? true
          ? const Icon(Icons.person, color: Colors.grey)
          : null,
    );
  }

  _buildVideoThumbNail() {
    return CircleAvatar(
      radius: 30,
      backgroundImage: CachedNetworkImageProvider(
        story.stories?.first.thumbnailUrl ?? "",
      ),
      onBackgroundImageError: (exception, stackTrace) {
        debugPrint('Story image load failed: $exception');
      },
      child: story.stories?.first.thumbnailUrl?.isEmpty ?? true
          ? const Icon(Icons.person, color: Colors.grey)
          : null,
    );
  }
}
