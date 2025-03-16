import 'dart:io';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:echodate/app/controller/message_controller.dart';
import 'package:echodate/app/controller/socket_controller.dart';
import 'package:echodate/app/controller/user_controller.dart';
import 'package:echodate/app/models/chat_list_model.dart';
import 'package:echodate/app/models/message_model.dart';
import 'package:echodate/app/modules/chat/widgets/chat_widgets.dart';
import 'package:echodate/app/resources/colors.dart';
import 'package:echodate/app/services/message_service.dart';
import 'package:echodate/app/utils/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:video_compress/video_compress.dart';

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
  final _socketController = Get.find<SocketController>();
  final _messageController = Get.find<MessageController>();
  final _userController = Get.find<UserController>();
  RxBool isTyping = false.obs;
  Rxn<Uint8List> uint8list = Rxn<Uint8List>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (_socketController.socket != null ||
          _socketController.socket!.connected) {
        _socketController.initializeSocket();
        _socketController.markMessageRead(widget.chatHead.userId ?? "");
        await _messageController.getMessageHistory(
          receiverUserId: widget.chatHead.userId ?? "",
        );

        _socketController.socket?.on("typing", (data) {
          if (data["senderId"] == widget.chatHead.userId) {
            isTyping.value = true;
          }
        });

        _socketController.socket?.on("stop-typing", (data) {
          if (data["senderId"] == widget.chatHead.userId) {
            isTyping.value = false;
          }
        });
      }
    });
  }

  final TextEditingController _textMessageController = TextEditingController();
  final _scrollController = ScrollController();
  final Rxn<File> _selectedFile = Rxn<File>(null);

  bool _isVideoFile(String path) {
    return path.toLowerCase().endsWith('.mp4') ||
        path.toLowerCase().endsWith('.mov') ||
        path.toLowerCase().endsWith('.avi') ||
        path.toLowerCase().endsWith('.wmv') ||
        path.toLowerCase().endsWith('.mkv');
  }

  final RxBool _isUploading = false.obs;
  final RxBool _isShowPreview = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 0.0,
        leading: InkWell(
          child: const Icon(Icons.arrow_back_ios),
          onTap: () => Get.back(),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundImage: CachedNetworkImageProvider(
                widget.chatHead.avatar ?? "",
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
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Container(
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
          ),
          const SizedBox(height: 10),

          Expanded(
            child: Obx(() {
              if (_messageController.isloading.value) {
                return Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryColor,
                  ),
                );
              }
              if (_messageController.chatHistoryAndLiveMessage.isEmpty) {
                return const Center(
                  child: Text("No Message"),
                );
              }
              return ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                itemCount: _messageController.chatHistoryAndLiveMessage.length,
                itemBuilder: (context, index) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (_scrollController.hasClients) {
                      _scrollController.animateTo(
                        _scrollController.position.maxScrollExtent,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                      );
                    }
                  });
                  final message =
                      _messageController.chatHistoryAndLiveMessage[index];
                  return message.senderId == _userController.userModel.value!.id
                      ? SenderCard(messageModel: message)
                      : ReceiverCard(messageModel: message);
                },
              );
            }),
          ),

          Obx(
            () => isTyping.value
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Lottie.asset(
                        "assets/images/typing.json",
                        height: 50,
                      ),
                    ),
                  )
                : const SizedBox(),
          ),

          Obx(() => _selectedFile.value != null && _isShowPreview.value
              ? Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    border: Border(
                      top: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: SizedBox(
                                height: 100,
                                child: _isVideoFile(_selectedFile.value!.path)
                                    ? Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Obx(() {
                                            if (uint8list.value == null) {
                                              return const SizedBox.shrink();
                                            } else {
                                              return Image.memory(
                                                uint8list.value!,
                                                fit: BoxFit.cover,
                                                width: double.infinity,
                                              );
                                            }
                                          }),
                                          Icon(
                                            Icons.play_circle_fill,
                                            size: 40,
                                            color:
                                                Colors.white.withOpacity(0.8),
                                          ),
                                        ],
                                      )
                                    : Image.file(
                                        _selectedFile.value!,
                                        fit: BoxFit.cover,
                                        width: Get.width * 0.2,
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.red),
                        onPressed: () {
                          _selectedFile.value = null;
                        },
                      ),
                    ],
                  ),
                )
              : const SizedBox()),

          // Message Input Field
          Container(
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
                IconButton(
                  icon: const Icon(
                    Icons.attach_file_rounded,
                    color: Colors.orange,
                  ),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _buildProfileSettingTiles(
                                title: "Send Image",
                                onTap: () async {
                                  _selectedFile.value = await pickImage();
                                  _isShowPreview.value = true;
                                  Navigator.pop(context);
                                },
                                bgColor: Colors.orange,
                                iconColor: Colors.white,
                                icon: Icons.image,
                              ),
                              const SizedBox(height: 10),
                              _buildProfileSettingTiles(
                                title: "Send Video",
                                onTap: () async {
                                  _selectedFile.value = await pickVideo();
                                  _isShowPreview.value = true;
                                  uint8list.value =
                                      await VideoCompress.getByteThumbnail(
                                    _selectedFile.value?.path ?? "",
                                    quality: 50,
                                    position: -1,
                                  );
                                  Navigator.pop(context);
                                },
                                bgColor: Colors.green,
                                iconColor: Colors.white,
                                icon: Icons.video_camera_back_sharp,
                              ),
                              const SizedBox(height: 10),
                              // _buildProfileSettingTiles(
                              //   title: "Send Audio",
                              //   onTap: () {},
                              //   bgColor: Colors.deepPurpleAccent,
                              //   iconColor: Colors.white,
                              //   icon: Icons.audiotrack_sharp,
                              // ),
                              // const SizedBox(height: 10),
                              // _buildProfileSettingTiles(
                              //   title: "Send Document",
                              //   onTap: () {},
                              //   bgColor: Colors.lightBlueAccent,
                              //   iconColor: Colors.white,
                              //   icon: Icons.document_scanner,
                              // ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
                Expanded(
                  child: TextField(
                    controller: _textMessageController,
                    onChanged: (value) {
                      String receiverId = widget.chatHead.userId ?? "";
                      if (value.isNotEmpty) {
                        _socketController.typing(receiverId: receiverId);
                      } else {
                        _socketController.stopTyping(receiverId: receiverId);
                      }
                    },
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
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.orange),
                  onPressed: () async {
                    FocusManager.instance.primaryFocus?.unfocus();
                    _isShowPreview.value = false;
                    final messageModel = MessageModel(
                      receiverId: widget.chatHead.userId ?? "",
                      message: _textMessageController.text,
                      messageType: "text",
                    );

                    if (_selectedFile.value != null) {
                      _isUploading.value = true;
                      final tempMessage = MessageModel(
                        receiverId: widget.chatHead.userId ?? "",
                        message: _textMessageController.text,
                        messageType: _isVideoFile(_selectedFile.value!.path)
                            ? "video"
                            : "image",
                        senderId: _userController.userModel.value!.id,
                        status: "sending",
                        tempFile: _selectedFile.value,
                      );
                      _messageController.chatHistoryAndLiveMessage
                          .add(tempMessage);
                      // Scroll to bottom
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (_scrollController.hasClients) {
                          _scrollController.animateTo(
                            _scrollController.position.maxScrollExtent,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOut,
                          );
                        }
                      });

                      String? mediaUrl = await MessageService().uploadMedia(
                        _selectedFile.value!,
                      );
                      _isUploading.value = false;
                      if (mediaUrl != null && mediaUrl.isNotEmpty) {
                        bool isVideo = mediaUrl.contains("video");
                        messageModel.mediaUrl = mediaUrl;
                        messageModel.messageType = isVideo ? "video" : "image";

                        _messageController.chatHistoryAndLiveMessage
                            .removeWhere((msg) =>
                                msg.status == "sending" && msg == tempMessage);
                      }
                    }

                    _socketController.sendMessage(message: messageModel);
                    _textMessageController.clear();
                    _selectedFile.value = null;
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ListTile _buildProfileSettingTiles({
    required String title,
    required VoidCallback onTap,
    required Color bgColor,
    required Color iconColor,
    required IconData icon,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      minTileHeight: 20,
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
      leading: Container(
        height: 40,
        width: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: bgColor,
        ),
        child: Icon(
          icon,
          color: iconColor,
          size: 20,
        ),
      ),
    );
  }
}
