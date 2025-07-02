import 'package:echodate/app/modules/chat/enums/message_enum_type.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MessageContainerWidget extends StatelessWidget {
  final Widget child;
  final bool isReceiver;
  final MessageType messageType;

  const MessageContainerWidget({
    super.key,
    required this.child,
    this.isReceiver = false,
    required this.messageType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: _getPadding(messageType),
      constraints: messageType == MessageType.audio
          ? null
          : BoxConstraints(maxWidth: Get.width * 0.6),
      width: messageType == MessageType.audio ? Get.width * 0.8 : null,
      decoration: BoxDecoration(
        color: isReceiver ? Colors.grey.shade300 : Colors.orange,
        borderRadius: BorderRadius.circular(10),
      ),
      child: child,
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
}
