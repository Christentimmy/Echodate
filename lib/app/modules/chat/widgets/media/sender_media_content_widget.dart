import 'package:echodate/app/modules/chat/controller/sender_card_controller.dart';
import 'package:echodate/app/modules/chat/widgets/animated/animated_widgets.dart';
import 'package:echodate/app/modules/chat/widgets/shared/base_media_content_widget.dart';
import 'package:echodate/app/modules/chat/widgets/shimmer/shimmer_widgets.dart';
import 'package:echodate/app/utils/get_thumbnail_network.dart';
import 'package:echodate/app/widget/loader.dart';
import 'package:flutter/material.dart';

class SenderMediaContentWidget extends BaseMediaContentWidget {
  final SenderCardController controller;

  const SenderMediaContentWidget({
    super.key,
    required super.messageModel,
    required this.controller,
  }) : super(isReceiver: false);

  @override
  Widget buildVideoPreview() {
    return FutureBuilder(
      future: generateThumbnail(messageModel.mediaUrl ?? ""),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return buildShimmerVideoLoading();
        }
        if (!snapshot.hasData) {
          return const AnimatedVideoPreview(
            child: Icon(
              Icons.play_circle_fill,
              color: Colors.white,
              size: 50,
            ),
          );
        }
        return ClipRRect(
          borderRadius: BorderRadius.circular(7),
          child: Stack(
            alignment: Alignment.center,
            children: [
              AnimatedVideoPreview(
                child: Image.memory(
                  snapshot.data!,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const Icon(
                Icons.play_circle_fill,
                color: Colors.white,
                size: 50,
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Future<void> onVideoTap() async {
    if (controller.mediaController.videoController == null) {
      await controller.ensureControllerInitialized(messageModel);
    }
    navigateToFullScreen();
  }

  @override
  Widget? buildSendingState() {
    return _buildSendingState();
  }

  Widget _buildSendingState() {
    final thumbnailData = controller.chatMediaController.thumbnailData.value;
    final tempFile = messageModel.tempFile;

    if (thumbnailData == null && tempFile == null) {
      return const SizedBox.shrink();
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        Opacity(
          opacity: 0.4,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Image.file(
              thumbnailData ?? tempFile!,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const Center(
          child: SizedBox(
            width: 45,
            child: Loader(),
          ),
        ),
      ],
    );
  }
}
