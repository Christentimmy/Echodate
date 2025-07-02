import 'package:echodate/app/models/message_model.dart';
import 'package:echodate/app/modules/chat/controller/sender_card_controller.dart';
import 'package:echodate/app/modules/chat/enums/message_enum_type.dart';
import 'package:echodate/app/modules/chat/widgets/media/audio_content_widget.dart';
import 'package:echodate/app/modules/chat/widgets/media/media_content_widget.dart';
import 'package:echodate/app/modules/chat/widgets/message_timestamp_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SenderCard extends StatefulWidget {
  final MessageModel messageModel;

  const SenderCard({
    super.key,
    required this.messageModel,
  });

  @override
  State<SenderCard> createState() => _SenderCardState();
}

class _SenderCardState extends State<SenderCard>
    with AutomaticKeepAliveClientMixin {
  late final SenderCardController controller;
  String? _oldMediaUrl;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    controller = Get.put(SenderCardController(), tag: widget.messageModel.id);
    _oldMediaUrl = widget.messageModel.mediaUrl;
  }

  @override
  void didUpdateWidget(SenderCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.messageModel.mediaUrl != widget.messageModel.mediaUrl) {
      controller.handleMediaUrlChange(
        widget.messageModel.mediaUrl,
        _oldMediaUrl,
      );
      _oldMediaUrl = widget.messageModel.mediaUrl;
    }
  }

  @override
  void dispose() {
    Get.delete<SenderCardController>(tag: widget.messageModel.id);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onLongPress: controller.onLongPress,
        child: Obx(() {
          final MessageType messageType =
              getMessageType(widget.messageModel.messageType);
          return AnimatedScale(
            scale: controller.scale.value,
            duration: const Duration(milliseconds: 100),
            curve: Curves.easeOut,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 5),
              padding: _getPadding(messageType),
              constraints: BoxConstraints(
                maxWidth: Get.width * 0.6,
              ),
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(10),
              ),
              child: IntrinsicWidth(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildContent(),
                    if (widget.messageModel.message?.isNotEmpty == true)
                      _buildMessageText(),
                    const SizedBox(height: 3),
                    Align(
                      alignment: Alignment.centerRight,
                      child: MessageTimestampWidget(
                        createdAt: widget.messageModel.createdAt,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildContent() {
    final messageType = getMessageType(widget.messageModel.messageType);

    switch (messageType) {
      case MessageType.image:
      case MessageType.video:
        return MediaContentWidget(
          messageModel: widget.messageModel,
          controller: controller,
        );
      case MessageType.audio:
        return AudioContentWidget(
          messageModel: widget.messageModel,
          controller: controller,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildMessageText() {
    final mType = getMessageType(widget.messageModel.messageType);
    return Padding(
      padding: mType == MessageType.image || mType == MessageType.video
          ? const EdgeInsets.only(left: 3.0)
          : EdgeInsets.zero,
      child: Text(
        widget.messageModel.message ?? "",
        style: const TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  EdgeInsets _imagePadding() {
    return const EdgeInsets.only(
      left: 0,
      right: 0,
      top: 0,
      bottom: 5,
    );
  }

  EdgeInsets _videoPadding() {
    return const EdgeInsets.only(
      left: 3,
      right: 3,
      top: 3,
      bottom: 5,
    );
  }

  EdgeInsets _getPadding(MessageType messageType) {
    switch (messageType) {
      case MessageType.image:
        return _imagePadding();
      case MessageType.video:
        return _videoPadding();
      default:
        return const EdgeInsets.symmetric(
          horizontal: 5,
          vertical: 6,
        );
    }
  }
}
