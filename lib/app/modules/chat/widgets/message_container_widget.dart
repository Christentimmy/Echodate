import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MessageContainerWidget extends StatelessWidget {
  final Widget child;
  final bool isReceiver;

  const MessageContainerWidget({
    super.key,
    required this.child,
    this.isReceiver = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.all(10),
      constraints: BoxConstraints(maxWidth: Get.width * 0.6),
      decoration: BoxDecoration(
        color: isReceiver ? Colors.grey.shade300 : Colors.orange,
        borderRadius: BorderRadius.circular(10),
      ),
      child: child,
    );
  }
}