import 'package:echodate/app/models/message_model.dart';
import 'package:echodate/app/modules/chat/controller/sender_card_controller.dart';
import 'package:echodate/app/modules/chat/enums/message_enum_type.dart';
import 'package:echodate/app/modules/chat/views/view_medial_full_screen.dart';
import 'package:echodate/app/modules/chat/widgets/chat_widgets.dart';
import 'package:echodate/app/resources/colors.dart';
import 'package:echodate/app/utils/get_thumbnail_network.dart';
import 'package:echodate/app/widget/loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class MediaContentWidget extends StatelessWidget {
  final MessageModel messageModel;
  final SenderCardController controller;

  const MediaContentWidget({
    super.key,
    required this.messageModel,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    if (messageModel.status == "sending") {
      return _buildSendingState();
    }

    final messageType = getMessageType(messageModel.messageType);

    switch (messageType) {
      case MessageType.image:
        return _buildImageContent();
      case MessageType.video:
        return _buildVideoContent();
      default:
        return const SizedBox.shrink();
    }
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
              width: Get.width * 0.6,
              height: Get.height * 0.32,
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

  Widget _buildImageContent() {
    if (messageModel.mediaUrl?.isEmpty != false) {
      return const SizedBox.shrink();
    }

    return InkWell(
      onTap: () => _navigateToFullScreen(),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(7),
        child: AnimatedImagePreview(
          imageUrl: messageModel.mediaUrl!,
          width: Get.width * 0.6,
          height: Get.height * 0.32,
        ),
      ),
    );
  }

  Widget _buildVideoContent() {
    return InkWell(
      onTap: () async {
        if (controller.mediaController.videoController == null) {
          await controller.ensureControllerInitialized(messageModel);
        }
        _navigateToFullScreen();
      },
      child: Container(
        width: Get.width * 0.6,
        height: Get.height * 0.32,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.black.withOpacity(0.2),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            _buildVideoPreview(),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoPreview() {
    return FutureBuilder(
      future: generateThumbnail(messageModel.mediaUrl ?? ""),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildShimmerVideoLoading();
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

  Shimmer _buildShimmerVideoLoading() {
    return Shimmer.fromColors(
      highlightColor: AppColors.primaryColor,
      baseColor: Colors.grey.shade100.withOpacity(0.1),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          color: Colors.grey,
        ),
        width: double.infinity,
        height: double.infinity,
      ),
    );
  }

  void _navigateToFullScreen() {
    Get.to(
      transition: Transition.fadeIn,
      () => ViewMedialFullScreen(message: messageModel),
    );
  }
}
