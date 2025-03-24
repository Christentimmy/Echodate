import 'package:cached_network_image/cached_network_image.dart';
import 'package:echodate/app/controller/message_controller.dart';
import 'package:echodate/app/controller/socket_controller.dart';
import 'package:echodate/app/modules/chat/views/chat_screen.dart';
import 'package:echodate/app/resources/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final _messageController = Get.find<MessageController>();
  final _socketController = Get.find<SocketController>();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _socketController.getOnlineUser();
      if (!_messageController.isChattedListFetched.value) {
        _messageController.getChatList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Messages',
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: RefreshIndicator(
        color: AppColors.primaryColor,
        onRefresh: () async {
          await _messageController.refreshChatList();
          _socketController.getOnlineUser();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(
                  () => _messageController.activeFriends.isEmpty
                      ? const Text(
                          "My Matches",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : const Text(
                          "Online",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 80,
                  child: Obx(() {
                    if (_messageController.isloading.value) {
                      return const SizedBox.shrink();
                    }
                    if (_messageController.activeFriends.isEmpty &&
                        _messageController.allChattedUserList.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    if (_messageController.activeFriends.isEmpty &&
                        _messageController.allChattedUserList.isNotEmpty) {
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _messageController.allChattedUserList.length,
                        itemBuilder: (context, index) {
                          final activeFriend =
                              _messageController.allChattedUserList[index];
                          return InkWell(
                            onTap: () {
                              Get.to(
                                () => ChatScreen(chatHead: activeFriend),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(right: 5),
                              child: CircleAvatar(
                                radius: 30,
                                backgroundImage: CachedNetworkImageProvider(
                                  activeFriend.avatar ?? "",
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _messageController.activeFriends.length,
                      itemBuilder: (context, index) {
                        final activeFriend =
                            _messageController.activeFriends[index];
                        return InkWell(
                          onTap: () {
                            Get.to(() => ChatScreen(chatHead: activeFriend));
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 5),
                            child: Stack(
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  backgroundImage: CachedNetworkImageProvider(
                                    activeFriend.avatar ?? "",
                                  ),
                                ),
                                const Positioned(
                                  top: 2,
                                  right: 2,
                                  child: CircleAvatar(
                                    radius: 8,
                                    backgroundColor: Colors.white,
                                    child: CircleAvatar(
                                      radius: 5,
                                      backgroundColor: Colors.green,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }),
                ),
                const Divider(height: 1),
                const SizedBox(height: 10),
                const Text(
                  "My Chats",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                // Chat List Section
                Obx(() {
                  if (_messageController.isChatListLoading.value) {
                    return SizedBox(
                      height: Get.height * 0.45,
                      width: Get.width,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primaryColor,
                        ),
                      ),
                    );
                  }
                  if (_messageController.allChattedUserList.isEmpty) {
                    return SizedBox(
                      height: Get.height * 0.45,
                      width: Get.width,
                      child: const Center(
                        child: Text(
                          'No chats available yet.',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    );
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _messageController.allChattedUserList.length,
                    itemBuilder: (context, index) {
                      final messageModel =
                          _messageController.allChattedUserList[index];
                      return ListTile(
                        onTap: () {
                          Get.to(() => ChatScreen(
                                chatHead: messageModel,
                              ));
                        },
                        contentPadding: EdgeInsets.zero,
                        leading: Stack(
                          children: [
                            CircleAvatar(
                              radius: 25,
                              backgroundImage: CachedNetworkImageProvider(
                                messageModel.avatar ?? "",
                              ),
                            ),
                            messageModel.online == true
                                ? const Positioned(
                                    top: 1,
                                    right: 1,
                                    child: CircleAvatar(
                                      radius: 8,
                                      backgroundColor: Colors.white,
                                      child: CircleAvatar(
                                        radius: 5,
                                        backgroundColor: Colors.green,
                                      ),
                                    ),
                                  )
                                : const SizedBox.shrink()
                          ],
                        ),
                        title: Text(
                          messageModel.fullName ?? "",
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          messageModel.lastMessage ?? "",
                          style: const TextStyle(fontSize: 11),
                        ),
                        trailing: messageModel.unreadCount == 0
                            ? const SizedBox.shrink()
                            : CircleAvatar(
                                radius: 13,
                                backgroundColor: AppColors.primaryColor,
                                child: Text(
                                  messageModel.unreadCount.toString(),
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                      );
                    },
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
