import 'dart:io';
import 'dart:typed_data';
import 'package:audio_waveforms/audio_waveforms.dart';
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
import 'package:echodate/app/widget/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
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
  final RxString wordsTyped = "".obs;
  String? _audioFilePath;
  final RecorderController _recorderController = RecorderController();
  final PlayerController _audioPlayerController = PlayerController();
  bool _isRecording = false;
  bool _isPlaying = false;
  final RxBool _isUploading = false.obs;
  final RxBool _isShowPreview = false.obs;
  final TextEditingController _textMessageController = TextEditingController();
  final _scrollController = ScrollController();
  final Rxn<File> _selectedFile = Rxn<File>(null);

  // Function to start recording
  Future<void> _startRecording() async {
    try {
      PermissionStatus status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        CustomSnackbar.showErrorSnackBar("Permission denied");
        return;
      }

      final directory = await getApplicationDocumentsDirectory();
      _audioFilePath =
          '${directory.path}/voice_message_${DateTime.now().millisecondsSinceEpoch}.aac';

      // Start recording with waveform
      await _recorderController.record(
        path: _audioFilePath,
        // sampleRate: 44100,
        bitRate: 128000,
      );

      setState(() {
        _isRecording = true;
        _isShowPreview.value = true;
      });
    } catch (e) {
      print("Error starting recording: $e");
      CustomSnackbar.showErrorSnackBar("Failed to start recording");
      setState(() => _isRecording = false);
    }
  }

  Future<void> _stopRecording() async {
    try {
      final path = await _recorderController.stop();
      setState(() => _isRecording = false);

      if (path != null) {
        _selectedFile.value = File(path);
        _isShowPreview.value = true;

        // Prepare player with the recorded audio file
        await _audioPlayerController.preparePlayer(
          path: path,
          noOfSamples: 100, // Try a smaller number first
          shouldExtractWaveform: true,
        );
      }
    } catch (e) {
      print("Error stopping recording: $e");
      CustomSnackbar.showErrorSnackBar("Failed to process recording");
      setState(() => _isRecording = false);
    }
  }

  Future<void> _togglePlayback() async {
    try {
      final currentState = _audioPlayerController.playerState;

      if (currentState == PlayerState.playing) {
        await _audioPlayerController.pausePlayer();
        setState(() => _isPlaying = false);
      } else {
        if (currentState == PlayerState.stopped ||
            _audioPlayerController.onCompletion == const Stream.empty()) {
          await _audioPlayerController.seekTo(0);
        }

        // Ensure player is properly prepared
        if (currentState != PlayerState.initialized &&
            currentState != PlayerState.paused) {
          // Re-prepare the player with the file
          await _audioPlayerController.preparePlayer(
            path: _selectedFile.value!.path,
            noOfSamples: 44100, // Standard sample rate for high-quality audio
            shouldExtractWaveform: true,
          );
        }

        // Start playback
        await _audioPlayerController.startPlayer();
        setState(() => _isPlaying = true);
      }
    } catch (e) {
      print("Error toggling playback: $e");
      // If error occurs, try to completely reset the player
      if (_selectedFile.value != null &&
          _isAudioFile(_selectedFile.value!.path)) {
        await _audioPlayerController.stopPlayer();
        await _audioPlayerController.preparePlayer(
            path: _selectedFile.value!.path);
        await _audioPlayerController.startPlayer();
        setState(() => _isPlaying = true);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await _messageController.getMessageHistory(
        receiverUserId: widget.chatHead.userId ?? "",
      );
    });

    WidgetsBinding.instance.addPostFrameCallback((e) async {
      if (_socketController.socket == null ||
          _socketController.socket?.disconnected == true) {
        _socketController.initializeSocket();
      }

      _socketController.markMessageRead(widget.chatHead.userId ?? "");
      _scrollToBottom();

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
    });

    _selectedFile.value = null;
    _messageController.chatHistoryAndLiveMessage.listen((e) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    });

    _audioPlayerController.onCompletion.listen((_) async {
      setState(() => _isPlaying = false);
      if (_selectedFile.value != null &&
          _isAudioFile(_selectedFile.value!.path)) {
        await _audioPlayerController.stopPlayer();
        await _audioPlayerController.preparePlayer(
          path: _selectedFile.value!.path,
        );
      }
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  bool _isVideoFile(String path) {
    return path.toLowerCase().endsWith('.mp4') ||
        path.toLowerCase().endsWith('.mov') ||
        path.toLowerCase().endsWith('.avi') ||
        path.toLowerCase().endsWith('.wmv') ||
        path.toLowerCase().endsWith('.mkv');
  }

  bool _isAudioFile(String path) {
    return path.toLowerCase().endsWith('.aac') ||
        path.toLowerCase().endsWith('.mp3') ||
        path.toLowerCase().endsWith('.wav');
  }

  @override
  void dispose() {
    _recorderController.dispose();
    _audioPlayerController.dispose();
    _messageController.chatHistoryAndLiveMessage.clear();
    super.dispose();
  }

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
          // Audio recording UI and preview
          Obx(
            () => _isRecording ||
                    (_selectedFile.value != null &&
                        _isAudioFile(_selectedFile.value!.path))
                ? Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      border: Border(
                        top: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                    child: Column(
                      children: [
                        _isRecording
                            ? AudioWaveforms(
                                enableGesture: true,
                                size: Size(
                                  MediaQuery.of(context).size.width * 0.8,
                                  50,
                                ),
                                recorderController: _recorderController,
                                waveStyle: const WaveStyle(
                                  waveColor: Colors.orange,
                                  extendWaveform: true,
                                  showMiddleLine: false,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.0),
                                  color: Colors.white,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                              )
                            : _selectedFile.value != null
                                ? AudioFileWaveforms(
                                    size: Size(
                                      MediaQuery.of(context).size.width * 0.8,
                                      50,
                                    ),
                                    playerController: _audioPlayerController,
                                    enableSeekGesture: true,
                                    continuousWaveform: true,
                                    waveformType: WaveformType.fitWidth,
                                    playerWaveStyle: const PlayerWaveStyle(
                                      fixedWaveColor: Colors.blue,
                                      liveWaveColor: Colors.orange,
                                      spacing: 6.0,
                                    ),
                                  )
                                : const SizedBox(),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (_selectedFile.value != null)
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      _isPlaying
                                          ? Icons.pause
                                          : Icons.play_arrow,
                                      color: Colors.blue,
                                      size: 30,
                                    ),
                                    onPressed: _togglePlayback,
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                      size: 30,
                                    ),
                                    onPressed: () {
                                      _selectedFile.value = null;
                                      _isShowPreview.value = false;
                                    },
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ],
                    ),
                  )
                : const SizedBox(),
          ),
          // Other media preview
          Obx(
            () => _selectedFile.value != null &&
                    _isShowPreview.value &&
                    !_isAudioFile(_selectedFile.value!.path)
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
                            _isShowPreview.value = false;
                          },
                        ),
                      ],
                    ),
                  )
                : const SizedBox(),
          ),
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
                              const SizedBox(height: 15),
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
                              const SizedBox(height: 15),
                              _buildProfileSettingTiles(
                                title: "Send Audio",
                                onTap: () async {
                                  await _startRecording();
                                  Navigator.pop(context);
                                },
                                bgColor: Colors.deepPurpleAccent,
                                iconColor: Colors.white,
                                icon: Icons.audiotrack_sharp,
                              ),
                              const SizedBox(height: 15),
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
                      wordsTyped.value = value;
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
                Obx(() {
                  if (wordsTyped.value.isNotEmpty ||
                      _selectedFile.value != null) {
                    return IconButton(
                      icon: const Icon(
                        Icons.send,
                        color: Colors.orange,
                      ),
                      onPressed: () async {
                        FocusManager.instance.primaryFocus?.unfocus();
                        _isShowPreview.value = false;
                        if (_isPlaying) {
                          await _audioPlayerController.pausePlayer();
                          setState(() => _isPlaying = false);
                        }

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
                                : _isAudioFile(_selectedFile.value!.path)
                                    ? "audio"
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

                          dynamic res = await MessageService().uploadMedia(
                            _selectedFile.value!,
                          );
                          String? mediaUrl = res["mediaUrl"];
                          String? messageType = res["messageType"];
                          _isUploading.value = false;
                          if (mediaUrl != null && mediaUrl.isNotEmpty) {
                            messageModel.mediaUrl = mediaUrl;
                            messageModel.messageType = messageType;

                            _messageController.chatHistoryAndLiveMessage
                                .removeWhere((msg) =>
                                    msg.status == "sending" &&
                                    msg == tempMessage);
                          }
                        }

                        _socketController.sendMessage(message: messageModel);
                        _textMessageController.clear();
                        wordsTyped.value = "";
                        _selectedFile.value = null;
                      },
                    );
                  } else {
                    return IconButton(
                      icon: Icon(
                        _isRecording ? Icons.stop : Icons.mic,
                        color: _isRecording ? Colors.red : Colors.orange,
                      ),
                      onPressed:
                          _isRecording ? _stopRecording : _startRecording,
                    );
                  }
                }),
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
