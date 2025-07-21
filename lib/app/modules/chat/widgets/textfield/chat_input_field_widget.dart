import 'package:echodate/app/models/chat_list_model.dart';
import 'package:echodate/app/modules/chat/controller/chat_controller.dart';
import 'package:echodate/app/modules/chat/widgets/media/media_picker_bottom_sheet.dart';
import 'package:echodate/app/modules/chat/widgets/shared/reply_to_content_widget.dart';
import 'package:echodate/app/modules/chat/widgets/textfield/audio_input_widget.dart';
import 'package:echodate/app/modules/chat/widgets/textfield/input_decoration.dart';
import 'package:echodate/app/resources/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class NewChatInputFields extends StatelessWidget {
  final ChatController controller;
  final ChatListModel chatHead;

  const NewChatInputFields({
    super.key,
    required this.controller,
    required this.chatHead,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isRecording = controller.audioController.isRecording.value;
      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: isRecording
            ? AudioInputPreview(controller: controller)
            : _buildInputFieldRow(context),
      );
    });
  }

  Widget _buildInputFieldRow(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          constraints: BoxConstraints(
            maxWidth: Get.width * 0.845,
            minHeight: 45,
          ),
          margin: const EdgeInsets.all(2.5),
          decoration: chatInputFieldDecoration(),
          child: Column(
            children: [
              ReplyToContent(
                controller: controller,
                chatHead: chatHead,
                isSender: false,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const FaIcon(
                      FontAwesomeIcons.solidFaceSmile,
                      color: Colors.grey,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      minLines: 1,
                      maxLines: 3,
                      cursorColor: AppColors.primaryColor,
                      controller: controller.textMessageController,
                      onChanged: controller.handleTyping,
                      style: Get.textTheme.labelMedium,
                      decoration: InputDecoration(
                        hintText: "Type a message...",
                        hintStyle: Get.textTheme.labelMedium,
                        border: InputBorder.none,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.attach_file_rounded,
                      color: Colors.grey,
                    ),
                    onPressed: () => _showMediaPickerBottomSheet(context),
                  ),
                ],
              ),
            ],
          ),
        ),
        Obx(() {
          if (controller.wordsTyped.value.isNotEmpty ||
              controller.mediaController.selectedFile.value != null ||
              controller.audioController.selectedFile.value != null ||
              controller.mediaController.multipleMediaSelected.isNotEmpty) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 2.0),
              child: CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.primaryColor,
                child: IconButton(
                  icon: const Icon(
                    Icons.send,
                    color: Colors.white,
                    size: 18,
                  ),
                  onPressed: controller.sendMessage,
                ),
              ),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.only(bottom: 2.0),
              child: CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.primaryColor,
                child: IconButton(
                  icon: const Icon(
                    Icons.mic,
                    color: Colors.white,
                  ),
                  onPressed: controller.audioController.startRecording,
                ),
              ),
            );
          }
        }),
      ],
    );
  }

  void _showMediaPickerBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => MediaPickerBottomSheet(controller: controller),
    );
  }
}
