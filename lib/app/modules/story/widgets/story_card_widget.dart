import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:echodate/app/models/story_model.dart';
import 'package:echodate/app/resources/colors.dart';
import 'package:flutter/material.dart';
import 'package:video_compress/video_compress.dart';

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

  Future<Uint8List?> _getThumbNail() async {
    final mediaUrl = story.stories?.first.mediaUrl;
    if (mediaUrl == null || mediaUrl.isEmpty) {
      return null;
    }

    try {
      return await VideoCompress.getByteThumbnail(
        mediaUrl,
        quality: 50,
        position: -1,
      );
    } catch (e) {
      debugPrint('Video thumbnail generation failed: $e');
    }
    return null;
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
              child: _isVideo(story.stories?.first.mediaUrl ?? "")
                  ? _buildVideoThumbNail()
                  : _buildImage(),
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

  FutureBuilder<Uint8List?> _buildVideoThumbNail() {
    return FutureBuilder(
      future: _getThumbNail(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircleAvatar(
            radius: 30,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          );
        }

        // HANDLE ERROR STATE:
        if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
          return const CircleAvatar(
            radius: 30,
            backgroundColor: Colors.grey,
            child: Icon(Icons.play_circle_outline, color: Colors.white),
          );
        }

        return CircleAvatar(
          radius: 30,
          backgroundImage: MemoryImage(snapshot.data!),
        );
      },
    );
  }
}
