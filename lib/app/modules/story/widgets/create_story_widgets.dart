import 'package:echodate/app/modules/story/controller/story_screen_controller.dart';
import 'package:echodate/app/resources/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:video_player/video_player.dart';

Future<dynamic> displayMediaOptionWidget(
  BuildContext context,
  StoryScreenController controller,
) {
  return showModalBottomSheet(
    context: context,
    builder: (context) => Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 10),
        ListTile(
          leading: Icon(
            Icons.videocam,
            color: AppColors.primaryColor,
          ),
          title: const Text(
            'Select a video',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          onTap: () {
            Navigator.pop(context);
            controller.selectVideo();
          },
        ),
        ListTile(
          leading: Icon(
            Icons.photo_library,
            color: AppColors.primaryColor,
          ),
          title: const Text(
            'Select from gallery',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          onTap: () {
            Navigator.pop(context);
            controller.selectImage();
          },
        ),
      ],
    ),
  );
}

class MediaDisplayCard extends StatelessWidget {
  final StoryScreenController storyScreenController;
  final int index;
  const MediaDisplayCard({
    super.key,
    required this.storyScreenController,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Stack(
          children: [
            MediaPreviewWidget(
              mediaFile: storyScreenController.selectedMedia[index],
            ),
            Positioned(
              top: 4,
              right: 4,
              child: GestureDetector(
                onTap: () => storyScreenController.removeMedia(index),
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: const BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MediaPreviewWidget extends StatefulWidget {
  final File mediaFile;

  const MediaPreviewWidget({
    super.key,
    required this.mediaFile,
  });

  @override
  State<MediaPreviewWidget> createState() => _MediaPreviewWidgetState();
}

class _MediaPreviewWidgetState extends State<MediaPreviewWidget> {
  VideoPlayerController? _videoController;
  bool _isVideo = false;
  bool _isLoading = true;
  final double previewWidth = 80;
  final double previewHeight = 100;

  @override
  void initState() {
    super.initState();
    _checkFileTypeAndInitialize();
  }

  Future<void> _checkFileTypeAndInitialize() async {
    final String extension =
        path.extension(widget.mediaFile.path).toLowerCase();
    _isVideo =
        ['.mp4', '.mov', '.avi', '.flv', '.wmv', '.3gp'].contains(extension);

    if (_isVideo) {
      _videoController = VideoPlayerController.file(widget.mediaFile)
        ..initialize().then((_) {
          setState(() {
            _isLoading = false;
          });

          _videoController!.setLooping(true);
          _videoController!.setVolume(0.0); // Mute the video
          _videoController!.play(); // Auto-play the video preview
        });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return SizedBox(
        width: previewWidth,
        height: previewHeight,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_isVideo &&
        _videoController != null &&
        _videoController!.value.isInitialized) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: previewWidth,
              height: previewHeight,
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _videoController!.value.size.width,
                  height: _videoController!.value.size.height,
                  child: VideoPlayer(_videoController!),
                ),
              ),
            ),
            Positioned(
              top: 4,
              right: 4,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.file(
          widget.mediaFile,
          width: previewWidth,
          height: previewHeight,
          fit: BoxFit.cover,
        ),
      );
    }
  }
}

class StoryVisibilityRadioWidget extends StatelessWidget {
  final RxString selectedVisibility;
  const StoryVisibilityRadioWidget({
    super.key,
    required this.selectedVisibility,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(
          () => ListTile(
            minTileHeight: 35,
            contentPadding: EdgeInsets.zero,
            title: const Text('Public'),
            leading: Radio<String>(
              value: 'public',
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              activeColor: AppColors.primaryColor,
              groupValue: selectedVisibility.value,
              onChanged: (String? value) {
                selectedVisibility.value = value!;
              },
            ),
          ),
        ),
        Obx(
          () => ListTile(
            minTileHeight: 35,
            contentPadding: EdgeInsets.zero,
            title: const Text('Matches Only'),
            leading: Radio<String>(
              value: 'matches-only',
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              activeColor: AppColors.primaryColor,
              groupValue: selectedVisibility.value,
              onChanged: (String? value) {
                selectedVisibility.value = value!;
              },
            ),
          ),
        ),
      ],
    );
  }
}
