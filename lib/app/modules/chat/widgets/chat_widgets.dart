import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:echodate/app/models/message_model.dart';
import 'package:echodate/app/modules/chat/views/view_medial_full_screen.dart';
import 'package:echodate/app/widget/shimmer_effect.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_player/video_player.dart';

class SenderCard extends StatefulWidget {
  final MessageModel messageModel;

  const SenderCard({
    super.key,
    required this.messageModel,
  });

  @override
  State<SenderCard> createState() => _SenderCardState();
}

class _SenderCardState extends State<SenderCard> {
  VideoPlayerController? _videoController;
  Rxn<Uint8List> uint8list = Rxn<Uint8List>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (widget.messageModel.messageType == 'video' &&
          widget.messageModel.status != 'sending' &&
          widget.messageModel.mediaUrl != null) {
        _initializeVideoController();
      }
      if (widget.messageModel.messageType == 'video' &&
          widget.messageModel.status == 'sending' &&
          widget.messageModel.tempFile != null) {
        uint8list.value = await VideoCompress.getByteThumbnail(
          widget.messageModel.tempFile?.path ?? "",
          quality: 50,
          position: -1,
        );
      }
    });
  }

  void _initializeVideoController() {
    _videoController?.dispose();
    _videoController = VideoPlayerController.networkUrl(
        Uri.parse(widget.messageModel.mediaUrl ?? ""))
      ..initialize().then((_) {
        setState(() {});
        _videoController!.setVolume(1.0);
      }).catchError((error) {
        print("Video initialization error: $error");
      });
  }

  @override
  void didUpdateWidget(SenderCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If the message status changed from 'sending' to something else,
    // and it's a video, initialize the video controller
    if (oldWidget.messageModel.status == 'sending' &&
        widget.messageModel.status != 'sending' &&
        widget.messageModel.messageType == 'video' &&
        widget.messageModel.mediaUrl != null) {
      _initializeVideoController();
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.all(10),
        constraints: BoxConstraints(
          maxWidth: Get.width * 0.6,
        ),
        decoration: BoxDecoration(
          color: Colors.orange,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Handle different message types and states
            if (widget.messageModel.messageType == "image" ||
                widget.messageModel.messageType == "video")
              _buildMediaContent(),

            // Text message content
            if (widget.messageModel.message?.isNotEmpty == true)
              Text(
                widget.messageModel.message ?? "",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),

            const SizedBox(height: 3),

            // Message timestamp or sending status
            widget.messageModel.status == 'sending'
                ? const Text(
                    "Sending...",
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.white70,
                    ),
                  )
                : Text(
                    widget.messageModel.createdAt != null
                        ? DateFormat("hh:mm a")
                            .format(widget.messageModel.createdAt!)
                        : "",
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.white70,
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildMediaContent() {
    // If message is in sending state with a temporary file
    if (widget.messageModel.status == 'sending' &&
        widget.messageModel.tempFile != null) {
      return Stack(
        alignment: Alignment.center,
        children: [
          // Show the temporary file
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: Get.width * 0.558,
              height: Get.height * 0.32,
              child: widget.messageModel.messageType == "video"
                  ? Stack(
                      alignment: Alignment.center,
                      children: [
                        Obx(() {
                          if (uint8list.value == null) {
                            return const SizedBox.shrink();
                          } else {
                            return Image.memory(
                              uint8list.value!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            );
                          }
                        }),
                        Icon(
                          Icons.play_circle_fill,
                          size: 40,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ],
                    )
                  : Image.file(
                      widget.messageModel.tempFile!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
            ),
          ),

          // Show loading overlay
          Container(
            width: Get.width * 0.558,
            height: Get.height * 0.32,
            color: Colors.black.withOpacity(0.3),
            child: const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 3,
              ),
            ),
          ),
        ],
      );
    }

    // For image message
    else if (widget.messageModel.messageType == "image" &&
        widget.messageModel.mediaUrl?.isNotEmpty == true) {
      return InkWell(
        onTap: () {
          Get.to(() => ViewMedialFullScreen(
                message: widget.messageModel,
              ));
        },
        child: CachedNetworkImage(
          imageUrl: widget.messageModel.mediaUrl ?? "",
          width: Get.width * 0.558,
          height: Get.height * 0.32,
          fit: BoxFit.cover,
          placeholder: (context, url) {
            return ShimmerEffect(
              child: SizedBox(
                width: Get.width * 0.558,
                height: Get.height * 0.32,
              ),
            );
          },
        ),
      );
    }

    // For video message
    else if (widget.messageModel.messageType == "video") {
      return _videoController != null && _videoController!.value.isInitialized
          ? InkWell(
              onTap: () {
                Get.to(() => ViewMedialFullScreen(
                      message: widget.messageModel,
                    ));
              },
              child: SizedBox(
                width: Get.width * 0.558,
                height: Get.height * 0.32,
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: Get.width * 0.558,
                    height: Get.height * 0.32,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: VideoPlayer(_videoController!),
                    ),
                  ),
                ),
              ),
            )
          : const Center(
              child: CircularProgressIndicator(
                color: Colors.orange,
              ),
            );
    }

    return const SizedBox.shrink();
  }
}

class ReceiverCard extends StatefulWidget {
  final MessageModel messageModel;

  const ReceiverCard({
    super.key,
    required this.messageModel,
  });

  @override
  State<ReceiverCard> createState() => _ReceiverCardState();
}

class _ReceiverCardState extends State<ReceiverCard> {
  VideoPlayerController? _videoController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (widget.messageModel.messageType == 'video' &&
          widget.messageModel.mediaUrl != null) {
        _initializeVideoController();
      }
    });
  }

  void _initializeVideoController() {
    _videoController?.dispose();
    _videoController = VideoPlayerController.networkUrl(
        Uri.parse(widget.messageModel.mediaUrl ?? ""))
      ..initialize().then((_) {
        setState(() {});
        _videoController!.setVolume(1.0);
      }).catchError((error) {
        print("Video initialization error: $error");
      });
  }

  @override
  void didUpdateWidget(ReceiverCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.messageModel.mediaUrl != widget.messageModel.mediaUrl &&
        widget.messageModel.messageType == 'video' &&
        widget.messageModel.mediaUrl != null) {
      _initializeVideoController();
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.all(10),
        constraints: BoxConstraints(
          maxWidth: Get.width * 0.6,
        ),
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Build media content based on message type
            if (widget.messageModel.messageType == "image" ||
                widget.messageModel.messageType == "video")
              _buildMediaContent(),

            // Text message
            if (widget.messageModel.message?.isNotEmpty == true)
              Text(
                widget.messageModel.message ?? "",
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),

            const SizedBox(height: 3),

            // Timestamp
            Text(
              widget.messageModel.createdAt != null
                  ? DateFormat("hh:mm a").format(widget.messageModel.createdAt!)
                  : "",
              style: const TextStyle(
                fontSize: 10,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMediaContent() {
    // For image message
    if (widget.messageModel.messageType == "image" &&
        widget.messageModel.mediaUrl?.isNotEmpty == true) {
      return InkWell(
        onTap: () {
          Get.to(() => ViewMedialFullScreen(
                message: widget.messageModel,
              ));
        },
        child: CachedNetworkImage(
          imageUrl: widget.messageModel.mediaUrl ?? "",
          width: Get.width * 0.558,
          height: Get.height * 0.32,
          fit: BoxFit.cover,
          placeholder: (context, url) {
            return ShimmerEffect(
              child: SizedBox(
                width: Get.width * 0.558,
                height: Get.height * 0.32,
              ),
            );
          },
        ),
      );
    }

    // For video message
    else if (widget.messageModel.messageType == "video") {
      return _videoController != null && _videoController!.value.isInitialized
          ? InkWell(
              onTap: () {
                Get.to(() => ViewMedialFullScreen(
                      message: widget.messageModel,
                    ));
              },
              child: SizedBox(
                width: Get.width * 0.558,
                height: Get.height * 0.32,
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: VideoPlayer(_videoController!),
                ),
              ),
            )
          : const Center(
              child: CircularProgressIndicator(
                color: Colors.orange,
              ),
            );
    }

    return const SizedBox.shrink();
  }
}
