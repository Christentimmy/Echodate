import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart'; // Add this import

class BroadcastScreen extends StatefulWidget {
  final String channelName;
  final String tempToken;

  const BroadcastScreen({super.key, required this.channelName, required this.tempToken});

  @override
  _BroadcastScreenState createState() => _BroadcastScreenState();
}

class _BroadcastScreenState extends State<BroadcastScreen> {
  late RtcEngine _agoraEngine;
  bool _isBroadcasting = false;
  int? _remoteUid;
  bool _isLocalVideoEnabled = true;
  bool _permissionsGranted = false;

  @override
  void initState() {
    super.initState();
    _requestPermissions();
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
        const SnackBar(content: Text('Camera and microphone permissions are required to broadcast.')),
      );
    }
  }

  Future<void> _initAgora() async {
    // Initialize Agora RTC Engine
    _agoraEngine = createAgoraRtcEngine();
    await _agoraEngine.initialize(const RtcEngineContext(
      appId: '3f2d4f1858c2486096f6007138a48e46', // Replace with your Agora App ID
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
      onUserOffline: (RtcConnection connection, int remoteUid, UserOfflineReasonType reason) {
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
  void dispose() {
    _agoraEngine.leaveChannel();
    _agoraEngine.release();
    super.dispose();
  }

  // Toggle local video (camera) on/off
  Future<void> _toggleLocalVideo() async {
    setState(() {
      _isLocalVideoEnabled = !_isLocalVideoEnabled;
    });
    await _agoraEngine.enableLocalVideo(_isLocalVideoEnabled);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Broadcasting'),
      ),
      body: _permissionsGranted
          ? Stack(
              children: [
                // Local video preview
                Center(
                  child: _isBroadcasting
                      ? AgoraVideoView(
                          controller: VideoViewController(
                            rtcEngine: _agoraEngine,
                            canvas: const VideoCanvas(uid: 0),
                          ),
                        )
                      : const CircularProgressIndicator(),
                ),
                // Remote video view (if another user joins)
                if (_remoteUid != null)
                  Positioned(
                    top: 20,
                    right: 20,
                    child: Container(
                      width: 100,
                      height: 150,
                      child: AgoraVideoView(
                        controller: VideoViewController.remote(
                          rtcEngine: _agoraEngine,
                          canvas: VideoCanvas(uid: _remoteUid),
                          connection: RtcConnection(channelId: widget.channelName),
                        ),
                      ),
                    ),
                  ),
              ],
            )
          : const Center(
              child: Text('Waiting for camera and microphone permissions...'),
            ),
      floatingActionButton: _permissionsGranted
          ? FloatingActionButton(
              onPressed: _toggleLocalVideo,
              child: Icon(
                _isLocalVideoEnabled ? Icons.videocam_off : Icons.videocam,
              ),
            )
          : null,
    );
  }
}