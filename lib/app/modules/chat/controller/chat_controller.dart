import 'package:echodate/app/modules/chat/controller/audio_controller.dart';
import 'package:echodate/app/modules/chat/controller/chat_media_controller.dart';
import 'package:echodate/app/widget/snack_bar.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:echodate/app/controller/message_controller.dart';
import 'package:echodate/app/controller/socket_controller.dart';
import 'package:echodate/app/controller/user_controller.dart';
import 'package:echodate/app/models/chat_list_model.dart';
import 'package:echodate/app/models/message_model.dart';
import 'package:echodate/app/services/message_service.dart';
import 'package:uuid/uuid.dart';

class ChatController extends GetxController {
  final MessageController messageController = Get.find<MessageController>();
  final SocketController socketController = Get.find<SocketController>();
  final UserController userController = Get.find<UserController>();

  late AudioController audioController;
  late ChatMediaPickerHelper mediaController;

  final TextEditingController textMessageController = TextEditingController();
  final RxString wordsTyped = "".obs;
  final RxBool isUploading = false.obs;
  late ChatListModel chatHead;

  @override
  void onInit() {
    super.onInit();
    audioController = Get.put(AudioController());
    mediaController = Get.put(ChatMediaPickerHelper());
  }

  void initialize(ChatListModel chat) {
    chatHead = chat;
    if (socketController.socket == null ||
        socketController.socket?.disconnected == true) {
      socketController.initializeSocket();
    }
    _setupSocketListeners();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await messageController.getMessageHistory(
        receiverUserId: chatHead.userId ?? "",
      );
    });
    messageController.chatHistoryAndLiveMessage.listen((_) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        messageController.scrollToBottom();
        socketController.markMessageRead(chatHead.userId ?? "");
      });
    });
  }

  void _setupSocketListeners() {
    socketController.socket?.on("typing", (data) {
      if (data["senderId"] == chatHead.userId) {
        final messages = messageController.chatHistoryAndLiveMessage;
        if (messages.isNotEmpty && messages.last.status == "typing") {
          return;
        }
        messageController.chatHistoryAndLiveMessage.add(
          MessageModel(status: "typing", receiverId: chatHead.userId),
        );
      }
    });

    socketController.socket?.on("stop-typing", (data) {
      if (data["senderId"] == chatHead.userId) {
        final messages = messageController.chatHistoryAndLiveMessage;
        if (messages.isNotEmpty && messages.last.status == "typing") {
          // Remove typing indicator without triggering full rebuilds
          messageController.chatHistoryAndLiveMessage.removeWhere(
            (msg) => msg.status == "typing",
          );
        }
      }
    });
  }

  void handleTyping(String value) {
    wordsTyped.value = value;
    String receiverId = chatHead.userId ?? "";
    if (value.isNotEmpty) {
      socketController.typing(receiverId: receiverId);
    } else {
      socketController.stopTyping(receiverId: receiverId);
    }
  }

  Future<void> sendMessage() async {
    HapticFeedback.lightImpact();
    FocusManager.instance.primaryFocus?.unfocus();
    mediaController.showMediaPreview.value = false;
    audioController.showAudioPreview.value = false;

    if (audioController.isPlaying.value) {
      await audioController.togglePlayback();
    }

    final String messageText = textMessageController.text.trim();
    if (messageText.isEmpty &&
        mediaController.selectedFile.value == null &&
        audioController.selectedFile.value == null) {
      return;
    }

    if (chatHead.userId == null) {
      CustomSnackbar.showErrorSnackBar("User not found");
      return;
    }

    final tempId = const Uuid().v4();
    final messageModel = MessageModel(
      receiverId: chatHead.userId ?? "",
      message: messageText,
      messageType: "text",
      clientGeneratedId: tempId,
    );

    final selectedFile = mediaController.selectedFile.value ??
        audioController.selectedFile.value;
    if (selectedFile != null) {
      isUploading.value = true;
      final messageType = mediaController.getFileType(selectedFile.path) ??
          audioController.getFileType(selectedFile.path) ??
          "image";

      final tempMessage = MessageModel(
        receiverId: chatHead.userId ?? "",
        message: messageText,
        messageType: messageType,
        senderId: userController.userModel.value!.id,
        status: "sending",
        tempFile: selectedFile,
        clientGeneratedId: tempId,
      );

      messageController.chatHistoryAndLiveMessage.add(tempMessage);

      dynamic res = await MessageService().uploadMedia(selectedFile);
      if (res == null) {
        isUploading.value = false;
        CustomSnackbar.showErrorSnackBar("Error Uploading Media");
        return;
      }
      String? mediaUrl = res["mediaUrl"];
      String? uploadedMessageType = res["messageType"];
      String? mediaIv = res["mediaIv"];

      isUploading.value = false;

      if (mediaUrl != null && mediaUrl.isNotEmpty) {
        messageModel.mediaUrl = mediaUrl;
        messageModel.messageType = uploadedMessageType;
        messageModel.mediaIv = mediaIv;

        tempMessage.mediaUrl = mediaUrl;
        tempMessage.messageType = uploadedMessageType;
        tempMessage.mediaIv = mediaIv;
        tempMessage.status = "sent";
        // messageController.chatHistoryAndLiveMessage.refresh();
      }
    }

    // Send the message
    socketController.sendMessage(message: messageModel);
    messageController.scrollToBottom();
    socketController.stopTyping(receiverId: messageModel.receiverId ?? "");

    // Clear input
    textMessageController.clear();
    wordsTyped.value = "";
    mediaController.resetState();
    audioController.resetState();
  }

  void closeScreen() {
    messageController.getChatList(showLoading: false);
    socketController.stopTyping(receiverId: chatHead.userId ?? "");
    final userId = chatHead.userId;
    if (userId != null && userId.isNotEmpty) {
      final clonedMessages = [...messageController.chatHistoryAndLiveMessage];
      messageController.savedChatToAvoidLoading[userId] =
          RxList<MessageModel>.from(
        clonedMessages,
      );
    }
    messageController.chatHistoryAndLiveMessage.clear();
    textMessageController.clear();
  }

  @override
  void onClose() {
    closeScreen();
    super.onClose();
  }
}
