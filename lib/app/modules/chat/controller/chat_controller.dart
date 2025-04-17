
 import 'package:echodate/app/modules/chat/controller/audio_controller.dart';
import 'package:echodate/app/modules/chat/controller/chat_media_controller.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:echodate/app/controller/message_controller.dart';
import 'package:echodate/app/controller/socket_controller.dart';
import 'package:echodate/app/controller/user_controller.dart';
import 'package:echodate/app/models/chat_list_model.dart';
import 'package:echodate/app/models/message_model.dart';
import 'package:echodate/app/services/message_service.dart';

class ChatController extends GetxController {
  final MessageController messageController = Get.find<MessageController>();
  final SocketController socketController = Get.find<SocketController>();
  final UserController userController = Get.find<UserController>();
  
  late AudioController audioController;
  late ChatMediaController mediaController;

  final TextEditingController textMessageController = TextEditingController();
  final RxString wordsTyped = "".obs;
  final RxBool isUploading = false.obs;
  late ChatListModel chatHead;

  @override
  void onInit() {
    super.onInit();
    audioController = Get.put(AudioController());
    mediaController = Get.put(ChatMediaController());
  }

  void initialize(ChatListModel chat) {
    chatHead = chat;
    
    // Initialize socket
    if (socketController.socket == null || socketController.socket?.disconnected == true) {
      socketController.initializeSocket();
    }

    // Setup typing listeners
    _setupSocketListeners();

    // Load message history
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await messageController.getMessageHistory(
        receiverUserId: chatHead.userId ?? "",
      );
    });

    // Listen for message changes and scroll to bottom
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
        if (messageController.chatHistoryAndLiveMessage.last.status == "typing") {
          return;
        }
        messageController.chatHistoryAndLiveMessage.add(
          MessageModel(status: "typing", receiverId: chatHead.userId),
        );
      }
    });
    
    socketController.socket?.on("stop-typing", (data) {
      if (data["senderId"] == chatHead.userId &&
          messageController.chatHistoryAndLiveMessage.last.status == "typing") {
        messageController.chatHistoryAndLiveMessage.removeLast();
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
    FocusManager.instance.primaryFocus?.unfocus();
    
    // Stop audio playback if playing
    if (audioController.isPlaying.value) {
      await audioController.togglePlayback();
    }
    
    // Prepare message model
    final messageModel = MessageModel(
      receiverId: chatHead.userId ?? "",
      message: textMessageController.text,
      messageType: "text",
    );

    // Handle media file if selected
    final selectedFile = mediaController.selectedFile.value ?? audioController.selectedFile.value;
    if (selectedFile != null) {
      isUploading.value = true;
      final messageType = mediaController.getFileType(selectedFile.path) ?? 
                          audioController.getFileType(selectedFile.path) ?? 
                          "image";
      
      // Create temporary message with "sending" status
      final tempMessage = MessageModel(
        receiverId: chatHead.userId ?? "",
        message: textMessageController.text,
        messageType: messageType,
        senderId: userController.userModel.value!.id,
        status: "sending",
        tempFile: selectedFile,
      );
      
      messageController.chatHistoryAndLiveMessage.add(tempMessage);
      
      // Upload the media file
      dynamic res = await MessageService().uploadMedia(selectedFile);
      String? mediaUrl = res["mediaUrl"];
      String? uploadedMessageType = res["messageType"];
      
      isUploading.value = false;
      
      if (mediaUrl != null && mediaUrl.isNotEmpty) {
        messageModel.mediaUrl = mediaUrl;
        messageModel.messageType = uploadedMessageType;
        
        // Remove the temporary message
        messageController.chatHistoryAndLiveMessage.removeWhere(
          (msg) => msg.status == "sending" && msg == tempMessage
        );
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

  @override
  void onClose() {
    socketController.stopTyping(receiverId: chatHead.userId ?? "");
    
    // Save chat to avoid reloading
    final userId = chatHead.userId;
    if (userId != null && userId.isNotEmpty) {
      final clonedMessages = [...messageController.chatHistoryAndLiveMessage];
      messageController.savedChatToAvoidLoading[userId] = RxList<MessageModel>.from(clonedMessages);
    }
    
    messageController.chatHistoryAndLiveMessage.clear();
    textMessageController.dispose();
    super.onClose();
  }
}