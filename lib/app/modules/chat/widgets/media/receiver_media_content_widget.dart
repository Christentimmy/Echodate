import 'package:echodate/app/modules/chat/controller/receiver_card_controller.dart';
import 'package:echodate/app/modules/chat/widgets/animated/animated_widgets.dart';
import 'package:echodate/app/modules/chat/widgets/shared/base_media_content_widget.dart';
import 'package:echodate/app/modules/chat/widgets/shimmer/shimmer_widgets.dart';
import 'package:echodate/app/utils/get_thumbnail_network.dart';
import 'package:flutter/material.dart';

class ReceiverMediaContentWidget extends BaseMediaContentWidget {
  final ReceiverCardController controller;

  const ReceiverMediaContentWidget({
    super.key,
    required super.messageModel,
    required this.controller,
  }) : super(isReceiver: true);

  @override
  Widget buildVideoPreview() {
    return FutureBuilder(
      future: generateThumbnail(messageModel.mediaUrl ?? ""),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return buildShimmerVideoLoading(isSender: false);
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



}
