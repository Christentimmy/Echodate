import 'package:echodate/app/models/chat_list_model.dart';
import 'package:echodate/app/models/message_model.dart';
import 'package:echodate/app/modules/chat/controller/chat_controller.dart';
import 'package:echodate/app/modules/chat/controller/sender_card_controller.dart';
import 'package:echodate/app/modules/chat/enums/message_enum_type.dart';
import 'package:echodate/app/modules/chat/widgets/media/sender_audio_content_widget.dart';
import 'package:echodate/app/modules/chat/widgets/media/sender_media_content_widget.dart';
import 'package:echodate/app/modules/chat/widgets/shared/reply_to_content_widget.dart';
import 'package:echodate/app/modules/chat/widgets/shared/message_container_widget.dart';
import 'package:echodate/app/modules/chat/widgets/shared/message_timestamp_widget.dart';
import 'package:echodate/app/modules/chat/widgets/shared/swipeable_widget.dart';
import 'package:echodate/app/resources/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SenderCard extends StatefulWidget {
  final MessageModel messageModel;
  final ChatListModel chatHead;

  const SenderCard({
    super.key,
    required this.messageModel,
    required this.chatHead,
  });

  @override
  State<SenderCard> createState() => _SenderCardState();
}

class _SenderCardState extends State<SenderCard>
    with AutomaticKeepAliveClientMixin {
  late final SenderCardController controller;
  String? _oldMediaUrl;
  late final ChatController _chatController;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _chatController = Get.find<ChatController>(
      tag: widget.messageModel.receiverId,
    );
    controller = Get.put(
      SenderCardController(messageModel: widget.messageModel),
      tag: widget.messageModel.id,
    );
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
            child: SwipeableMessage(
              isSender: true,
              onSwipe: () {
                _chatController.replyToMessage.value = widget.messageModel;
                _chatController.replyToMessage.refresh();
              },
              child: MessageContainerWidget(
                messageType: messageType,
                messageModel: widget.messageModel,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.messageModel.replyToMessage != null)
                      ReplyToContent(
                        controller: _chatController,
                        chatHead: widget.chatHead,
                        messageModel: widget.messageModel.replyToMessage,
                        isSender: true,
                      ),
                    _buildContent(messageType),
                    if (widget.messageModel.message?.isNotEmpty == true)
                      _buildMessageText(),
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

  Widget _buildContent(MessageType messageType) {
    switch (messageType) {
      case MessageType.image:
      case MessageType.video:
        return SenderMediaContentWidget(
          messageModel: widget.messageModel,
          controller: controller,
        );
      case MessageType.audio:
        return SenderAudioContentWidget(
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
          color: AppColors.senderText,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
