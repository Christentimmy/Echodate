import 'dart:typed_data';

import 'package:echodate/app/models/story_model.dart';
import 'package:echodate/app/resources/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_compress/video_compress.dart';

class StoryCard extends StatefulWidget {
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

  @override
  State<StoryCard> createState() => _StoryCardState();
}

class _StoryCardState extends State<StoryCard> {
  bool _isVideo(String url) {
    return url.endsWith(".mp4") ||
        url.endsWith(".mov") ||
        url.endsWith(".avi") ||
        url.endsWith(".mkv");
  }

  Rxn<Uint8List> uint8list = Rxn<Uint8List>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (_isVideo(widget.story.stories?.first.mediaUrl ?? "")) {
        uint8list.value = await VideoCompress.getByteThumbnail(
          widget.story.stories?.first.mediaUrl ?? "",
          quality: 50,
          position: -1,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 32,
              backgroundColor:
                  widget.isSeen ? Colors.grey : AppColors.primaryColor,
              child: _isVideo(widget.story.stories?.first.mediaUrl ?? "")
                  ? Obx(() {
                      if (uint8list.value != null) {
                        return CircleAvatar(
                          radius: 30,
                          backgroundImage: MemoryImage(uint8list.value!),
                        );
                      } else {
                        return const CircleAvatar(radius: 30);
                      }
                    })
                  : CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(
                        widget.story.stories?.first.mediaUrl ?? "",
                      ),
                    ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.story.fullName?.split(" ")[0].toString() ?? "",
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
}
