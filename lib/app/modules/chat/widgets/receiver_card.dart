import 'package:echodate/app/models/message_model.dart';
import 'package:echodate/app/modules/chat/controller/receiver_card_controller.dart';
import 'package:echodate/app/modules/chat/enums/message_enum_type.dart';
import 'package:echodate/app/modules/chat/widgets/shared/message_container_widget.dart';
import 'package:echodate/app/modules/chat/widgets/shared/message_timestamp_widget.dart';
import 'package:echodate/app/modules/chat/widgets/media/receiver_audio_content_widget.dart';
import 'package:echodate/app/modules/chat/widgets/media/receiver_media_content_widget.dart';
import 'package:echodate/app/modules/chat/widgets/shared/typing_indicator_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReceiverCard extends StatefulWidget {
  final MessageModel messageModel;

  const ReceiverCard({
    super.key,
    required this.messageModel,
  });

  @override
  State<ReceiverCard> createState() => _ReceiverCardState();
}

class _ReceiverCardState extends State<ReceiverCard>
    with AutomaticKeepAliveClientMixin {
  late final ReceiverCardController controller;
  String? _oldMediaUrl;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    controller = Get.put(
      ReceiverCardController(messageModel: widget.messageModel),
      tag: widget.messageModel.id,
    );
    _oldMediaUrl = widget.messageModel.mediaUrl;
  }

  @override
  void didUpdateWidget(ReceiverCard oldWidget) {
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
    Get.delete<ReceiverCardController>(tag: widget.messageModel.id);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final isTyping = widget.messageModel.status == "typing";
    return isTyping ? const TypingIndicatorWidget() : _buildMessageCard();
  }

  Widget _buildMessageCard() {
    return Align(
      alignment: Alignment.centerLeft,
      child: GestureDetector(
        onLongPress: controller.onLongPress,
        child: Obx(() {
          final messageType = getMessageType(widget.messageModel.messageType);
          return AnimatedScale(
            scale: controller.scale.value,
            duration: const Duration(milliseconds: 100),
            curve: Curves.easeOut,
            child: MessageContainerWidget(
              isReceiver: true,
              messageType: messageType,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildContent(messageType),
                  if (widget.messageModel.message?.isNotEmpty == true)
                    _buildMessageText(),
                  // const SizedBox(height: 3),
                  MessageTimestampWidget(
                    createdAt: widget.messageModel.createdAt,
                    isReceiver: true,
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildContent(MessageType messageType) {
    if (messageType == MessageType.audio) {
      return ReceiverAudioContentWidget(
        messageModel: widget.messageModel,
        controller: controller,
      );
    }

    if (messageType == MessageType.image || messageType == MessageType.video) {
      return ReceiverMediaContentWidget(
        messageModel: widget.messageModel,
        controller: controller,
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildMessageText() {
    return Text(
      widget.messageModel.message ?? "",
      style: const TextStyle(
        color: Colors.black,
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
