import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:echodate/app/controller/live_stream_controller.dart';
import 'package:echodate/app/controller/socket_controller.dart';
import 'package:echodate/app/models/live_stream_chat_model.dart';
import 'package:echodate/app/models/live_stream_model.dart';
import 'package:echodate/app/resources/colors.dart';
import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class BroadcastScreen extends StatefulWidget {
  final String channelName;
  final String tempToken;
  final String hostId;
  final LiveStreamModel liveStreamModel;

  const BroadcastScreen({
    super.key,
    required this.channelName,
    required this.tempToken,
    required this.hostId,
    required this.liveStreamModel,
  });

  @override
  _BroadcastScreenState createState() => _BroadcastScreenState();
}

class _BroadcastScreenState extends State<BroadcastScreen> {
  late RtcEngine _agoraEngine;
  bool _isBroadcasting = false;
  int? _remoteUid;
  final bool _isLocalVideoEnabled = true;
  bool _permissionsGranted = false;
  final _liveStreamController = Get.find<LiveStreamController>();
  final _socketController = Get.find<SocketController>();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _requestPermissions() async {
    // Request camera and microphone permissions
    final cameraStatus = await Permission.camera.request();
    final microphoneStatus = await Permission.microphone.request();

    if (cameraStatus.isGranted && microphoneStatus.isGranted) {
      setState(() {
        _permissionsGranted = true;
      });
      _initAgora(); // Initialize Agora after permissions are granted
    } else {
      // Handle the case where permissions are denied
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Camera and microphone permissions are required to broadcast.')),
      );
    }
  }

  Future<void> _initAgora() async {
    // Initialize Agora RTC Engine
    _agoraEngine = createAgoraRtcEngine();
    await _agoraEngine.initialize(const RtcEngineContext(
      appId:
          '3f2d4f1858c2486096f6007138a48e46', // Replace with your Agora App ID
    ));

    // Enable video
    await _agoraEngine.enableVideo();

    // Set up event handlers
    _agoraEngine.registerEventHandler(RtcEngineEventHandler(
      onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
        setState(() {
          _isBroadcasting = true;
        });
      },
      onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
        setState(() {
          _remoteUid = remoteUid;
        });
      },
      onUserOffline: (RtcConnection connection, int remoteUid,
          UserOfflineReasonType reason) {
        setState(() {
          _remoteUid = null;
        });
      },
    ));

    // Start local video preview
    await _agoraEngine.startPreview();

    // Join the channel
    await _agoraEngine.joinChannel(
      token: widget.tempToken,
      channelId: widget.channelName,
      uid: 0,
      options: const ChannelMediaOptions(
        channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
      ),
    );
  }

  @override
  void dispose() async {
    _agoraEngine.leaveChannel();
    _agoraEngine.release();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        floatingActionButton: _permissionsGranted
            ? FloatingActionButton(
                backgroundColor: AppColors.primaryColor,
                foregroundColor: Colors.white,
                onPressed: () async {
                  await _liveStreamController.endLiveStream(
                    widget.channelName,
                    widget.hostId,
                    context,
                  );
                },
                child: Icon(
                  _isLocalVideoEnabled ? Icons.videocam_off : Icons.videocam,
                ),
              )
            : const SizedBox.shrink(),
        body: _permissionsGranted
            ? Stack(
                children: [
                  Obx(
                    () => _liveStreamController.isEndingLoading.value
                        ? LinearProgressIndicator(
                            color: AppColors.primaryColor,
                          )
                        : const SizedBox.shrink(),
                  ),
                  // Local video preview
                  Center(
                    child: _isBroadcasting
                        ? AgoraVideoView(
                            controller: VideoViewController(
                              rtcEngine: _agoraEngine,
                              canvas: const VideoCanvas(uid: 0),
                            ),
                          )
                        : const CircularProgressIndicator(
                            color: Colors.orange,
                          ),
                  ),
                  // Remote video view (if another user joins)
                  if (_remoteUid != null)
                    Positioned(
                      top: 20,
                      right: 20,
                      child: SizedBox(
                        width: 100,
                        height: 150,
                        child: AgoraVideoView(
                          controller: VideoViewController.remote(
                            rtcEngine: _agoraEngine,
                            canvas: VideoCanvas(uid: _remoteUid),
                            connection: RtcConnection(
                              channelId: widget.channelName,
                            ),
                          ),
                        ),
                      ),
                    ),

                  HostInfoWidget(
                    widget: widget,
                    liveStreamController: _liveStreamController,
                  ),

                  Container(
                    height: Get.height,
                    width: Get.width,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.9),
                        ],
                        stops: const [
                          0.7,
                          1.0
                        ], // Adjust the stops to make the darker part take 80%
                      ),
                    ),
                  ),

                  // Live Chat Overlay (Instagram-style)
                  _buildChatMessages(),

                  Align(
                    alignment: Alignment.bottomCenter,
                    child: ConfettiWidget(
                      confettiController:
                          _liveStreamController.controllerBottomCenter,
                      blastDirection: -pi / 2,
                      emissionFrequency: 0.01,
                      numberOfParticles: 20,
                      maxBlastForce: 100,
                      minBlastForce: 80,
                      gravity: 0.3,
                    ),
                  )

                  // _buildEndLiveAndPauseButton(context),
                ],
              )
            : const Center(
                child: Text('Waiting for camera and microphone permissions...'),
              ),
      ),
    );
  }

  Widget _buildChatMessages() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        height: Get.height * 0.3,
        width: double.infinity,
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.only(bottom: 40),
        child: Obx(
          () => ListView.builder(
            reverse: false,
            controller: _scrollController,
            itemCount: _socketController.chatMessages.length,
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) {
              WidgetsBinding.instance.addPostFrameCallback(
                (_) => _scrollToBottom(),
              );
              final message = _socketController.chatMessages[index];
              return _buildChatMessageBubble(message);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildChatMessageBubble(LiveStreamChatModel message) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 14,
            backgroundImage: NetworkImage(message.userAvatar),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "${message.username}: ",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    TextSpan(
                      text: message.message,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HostInfoWidget extends StatelessWidget {
  const HostInfoWidget({
    super.key,
    required this.widget,
    required LiveStreamController liveStreamController,
  }) : _liveStreamController = liveStreamController;

  final BroadcastScreen widget;
  final LiveStreamController _liveStreamController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: Get.height * 0.05,
        horizontal: 15,
      ),
      child: Row(
        children: [
          Container(
            height: 45,
            width: Get.width * 0.5,
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.black.withOpacity(0.6),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(
                    widget.liveStreamModel.hostAvater,
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  widget.liveStreamModel.hostName.split(" ")[0],
                  style: const TextStyle(color: Colors.white),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 2,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.black.withOpacity(0.6),
            ),
            child: Row(
              children: [
                const Icon(Icons.person, color: Colors.white),
                Obx(
                  () => Text(
                    "${_liveStreamController.numberOfViewers.value}",
                    style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
