import 'package:echodate/app/modules/chat/controller/chat_controller.dart';
import 'package:echodate/app/modules/chat/widgets/media_picker_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatInputField extends StatelessWidget {
  final ChatController controller;
  final String receiverId;

  const ChatInputField({
    super.key,
    required this.controller,
    required this.receiverId,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Colors.grey.shade300,
          ),
        ),
      ),
      child: Row(
        children: [
          // Attachment button
          IconButton(
            icon: const Icon(
              Icons.attach_file_rounded,
              color: Colors.orange,
            ),
            onPressed: () => _showMediaPickerBottomSheet(context),
          ),

          // Text input field
          Expanded(
            child: TextField(
              minLines: 1,
              maxLines: 3,
              controller: controller.textMessageController,
              onChanged: controller.handleTyping,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              decoration: const InputDecoration(
                hintText: "Type a message...",
                border: InputBorder.none,
              ),
            ),
          ),

          // Send button or mic button
          Obx(() {
            if (controller.wordsTyped.value.isNotEmpty ||
                controller.mediaController.selectedFile.value != null ||
                controller.audioController.selectedFile.value != null) {
              return IconButton(
                icon: const Icon(
                  Icons.send,
                  color: Colors.orange,
                ),
                onPressed: controller.sendMessage,
              );
            } else {
              return IconButton(
                icon: Icon(
                  controller.audioController.isRecording.value
                      ? Icons.stop
                      : Icons.mic,
                  color: controller.audioController.isRecording.value
                      ? Colors.red
                      : Colors.orange,
                ),
                onPressed: controller.audioController.isRecording.value
                    ? controller.audioController.stopRecording
                    : controller.audioController.startRecording,
              );
            }
          }),
        ],
      ),
    );
  }

  void _showMediaPickerBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => MediaPickerBottomSheet(controller: controller),
    );
  }
}
