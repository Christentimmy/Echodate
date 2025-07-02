import 'package:echodate/app/models/message_model.dart';
import 'package:echodate/app/modules/chat/controller/chat_controller.dart';
import 'package:echodate/app/modules/chat/widgets/chat_input_field_widget.dart';
import 'package:echodate/app/modules/chat/widgets/media_preview_widget.dart';
import 'package:echodate/app/modules/chat/widgets/sender_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:echodate/app/modules/home/widgets/tinder_card_widget.dart';
import 'package:echodate/app/models/chat_list_model.dart';
import 'package:echodate/app/models/user_model.dart';
import 'package:echodate/app/resources/colors.dart';
import 'package:echodate/app/modules/chat/widgets/chat_widgets.dart';

class ChatScreen extends StatefulWidget {
  final ChatListModel chatHead;

  const ChatScreen({
    super.key,
    required this.chatHead,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatController _chatController = Get.put(ChatController());

  @override
  void initState() {
    super.initState();
    _chatController.initialize(widget.chatHead);
  }

  @override
  void dispose() {
    _chatController.closeScreen();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          const SizedBox(height: 10),
          _buildSecurityMessage(),
          const SizedBox(height: 10),
          Expanded(child: _buildMessageList()),
          // Media preview widgets
          Obx(() {
            if (_chatController.audioController.showAudioPreview.value) {
              return AudioPreviewWidget(
                controller: _chatController.audioController,
              );
            }
            return const SizedBox();
          }),
          Obx(() {
            if (_chatController.mediaController.showMediaPreview.value) {
              return MediaPreviewWidget(
                controller: _chatController.mediaController,
              );
            }
            return const SizedBox();
          }),

          // Message input field
          ChatInputField(
            controller: _chatController,
            receiverId: widget.chatHead.userId ?? "",
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      titleSpacing: 0.0,
      leading: InkWell(
        child: const Icon(Icons.arrow_back_ios),
        onTap: () => Get.back(),
      ),
      title: Row(
        children: [
          InkWell(
            onTap: () {
              Get.to(() => TinderCardDetails(
                    userModel: UserModel(
                      id: widget.chatHead.userId,
                      avatar: widget.chatHead.avatar,
                      fullName: widget.chatHead.fullName,
                    ),
                  ));
            },
            child: CircleAvatar(
              radius: 22,
              backgroundImage: CachedNetworkImageProvider(
                widget.chatHead.avatar ?? "",
              ),
            ),
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.chatHead.fullName ?? "",
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                widget.chatHead.online == true ? "Online" : "Offline",
                style: const TextStyle(
                  color: Colors.green,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityMessage() {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Row(
        children: [
          Icon(Icons.lock, size: 18, color: Colors.grey),
          SizedBox(width: 5),
          Expanded(
            child: Text(
              "Messages are end-to-end encrypted. No one outside of this chat, not even TLC, can read or listen to them.",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return Obx(() {
      final messageController = _chatController.messageController;
      final savedChatToAvoidLoading = messageController.savedChatToAvoidLoading;
      List<MessageModel> oldChats =
          savedChatToAvoidLoading[widget.chatHead.userId] ?? [];
      final chatHistoryAndLiveMessage =
          messageController.chatHistoryAndLiveMessage;
      if (oldChats.isEmpty && messageController.isloading.value) {
        return Center(
          child: CircularProgressIndicator(
            color: AppColors.primaryColor,
          ),
        );
      }

      if (oldChats.isNotEmpty && messageController.isloading.value) {
        return _buildMessageListView(oldChats);
      }

      if (chatHistoryAndLiveMessage.isEmpty && oldChats.isEmpty) {
        return const Center(
          child: Text("No Message"),
        );
      }

      return _buildMessageListView(chatHistoryAndLiveMessage);
    });
  }

  Widget _buildMessageListView(List<MessageModel> messages) {
    return ListView.builder(
      key: PageStorageKey<String>('chat_list_${widget.chatHead.userId}'),
      controller: _chatController.messageController.scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      itemCount: messages.length,
      reverse: true,
      cacheExtent: 1000,
      physics: const AlwaysScrollableScrollPhysics(),
      addRepaintBoundaries: true,
      addAutomaticKeepAlives: true,
      itemBuilder: (context, index) {
        final reversedIndex = messages.length - 1 - index;
        final message = messages[reversedIndex];
        final isSent = message.senderId ==
            _chatController.userController.userModel.value!.id;
        final bubble = isSent
            ? RepaintBoundary(child: SenderCard(messageModel: message))
            : RepaintBoundary(child: ReceiverCard(messageModel: message));
        if (index == 0) {
          return TweenAnimationBuilder<Offset>(
            key: ValueKey(
              message.id ?? message.createdAt?.toIso8601String() ?? index,
            ),
            tween: Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ),
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOutCubic,
            builder: (context, offset, child) {
              return Transform.translate(
                offset: Offset(0, offset.dy * 50),
                child: child,
              );
            },
            child: bubble,
          );
        } else {
          return bubble;
        }
      },
    );
  }
}
