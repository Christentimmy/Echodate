// import 'dart:math';
// import 'package:agora_rtc_engine/agora_rtc_engine.dart';
// import 'package:confetti/confetti.dart';
// import 'package:echodate/app/controller/live_stream_controller.dart';
// import 'package:echodate/app/controller/socket_controller.dart';
// import 'package:echodate/app/controller/user_controller.dart';
// import 'package:echodate/app/models/live_stream_chat_model.dart';
// import 'package:echodate/app/models/live_stream_model.dart';
// import 'package:echodate/app/widget/custom_textfield.dart';
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:get/get.dart';

// class WatchLiveScreen extends StatefulWidget {
//   final String channelName;
//   final String token;
//   final int uid;
//   final LiveStreamModel liveStreamModel;

//   const WatchLiveScreen({
//     super.key,
//     required this.channelName,
//     required this.token,
//     required this.uid,
//     required this.liveStreamModel,
//   });

//   @override
//   _WatchLiveScreenState createState() => _WatchLiveScreenState();
// }

// class _WatchLiveScreenState extends State<WatchLiveScreen> {
//   late RtcEngine _agoraEngine;
//   bool _isJoined = false;
//   int? _remoteUid;
//   final _commentController = TextEditingController();
//   final _liveStreamController = Get.find<LiveStreamController>();
//   final ScrollController _scrollController = ScrollController();
//   final _socketController = Get.find<SocketController>();
//   final _userController = Get.find<UserController>();

//   @override
//   void initState() {
//     super.initState();
//     _initAgora();
//     _socketController.joinStream(widget.channelName);
//   }

//   Future<void> _initAgora() async {
//     try {
//       _agoraEngine = createAgoraRtcEngine();
//       await _agoraEngine.initialize(const RtcEngineContext(
//         appId: '3f2d4f1858c2486096f6007138a48e46',
//       ));

//       await _agoraEngine.enableVideo(); // Ensure video is enabled

//       _agoraEngine.registerEventHandler(RtcEngineEventHandler(
//         onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
//           print("✅ Joined channel: ${connection.channelId}");
//           setState(() {
//             _isJoined = true;
//           });
//         },
//         onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
//           print("🎥 Remote user joined: $remoteUid");
//           setState(() {
//             _remoteUid = remoteUid;
//           });
//           _agoraEngine.setRemoteVideoStreamType(
//             streamType: VideoStreamType.videoStreamHigh,
//             uid: remoteUid,
//           );
//         },
//         onUserOffline: (RtcConnection connection, int remoteUid,
//             UserOfflineReasonType reason) {
//           print("❌ Remote user left: $remoteUid, Reason: $reason");
//           setState(() {
//             _remoteUid = null;
//           });
//         },
//         onError: (err, msg) {
//           print("❗ Agora Error: $err, Message: $msg");
//         },
//       ));

//       await _agoraEngine.joinChannel(
//         token: widget.token,
//         channelId: widget.channelName,
//         uid: widget.uid,
//         options: const ChannelMediaOptions(
//           channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
//           clientRoleType: ClientRoleType.clientRoleAudience,
//         ),
//       );
//     } catch (e) {
//       print("❌ Error initializing Agora: $e");
//     }
//   }

//   @override
//   void dispose()  {
//     print("🚪 Leaving channel...");
//     _agoraEngine.leaveChannel();
//     _agoraEngine.release();
//     print("✅ Agora Engine released");
//     _commentController.clear();
//     super.dispose();
//     super.dispose();
//   }

//   Widget _buildVideoView() {
//     if (!_isJoined) {
//       return const Center(child: CircularProgressIndicator());
//     }

//     if (_remoteUid == null) {
//       return const Center(
//         child: Text(
//           'Waiting for the host to start streaming...',
//           style: TextStyle(color: Colors.white),
//         ),
//       );
//     }

//     return AgoraVideoView(
//       controller: VideoViewController.remote(
//         rtcEngine: _agoraEngine,
//         canvas: VideoCanvas(uid: _remoteUid),
//         connection: RtcConnection(channelId: widget.channelName),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return PopScope(
//       canPop: false,
//       child: Scaffold(
//         resizeToAvoidBottomInset: true,
//         body: Stack(
//           children: [
//             _buildVideoView(),
//             Container(
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                   stops: const [0.5, 1.0],
//                   colors: [
//                     Colors.black.withOpacity(0.1),
//                     Colors.black,
//                   ],
//                 ),
//               ),
//             ),
//             Padding(
//               padding: EdgeInsets.symmetric(
//                 vertical: Get.height * 0.05,
//                 horizontal: 15,
//               ),
//               child: Row(
//                 children: [
//                   Container(
//                     height: 45,
//                     width: Get.width * 0.5,
//                     padding: const EdgeInsets.all(2),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(20),
//                       color: Colors.black.withOpacity(0.6),
//                     ),
//                     child: Row(
//                       children: [
//                         CircleAvatar(
//                           radius: 20,
//                           backgroundImage: NetworkImage(
//                             widget.liveStreamModel.hostAvater,
//                           ),
//                         ),
//                         const SizedBox(width: 5),
//                         Text(
//                           widget.liveStreamModel.hostName,
//                           style: const TextStyle(color: Colors.white),
//                         ),
//                       ],
//                     ),
//                   ),
//                   const Spacer(),
//                   IconButton(
//                     onPressed: () async {
//                       await _liveStreamController.leaveStream(
//                         widget.channelName,
//                         context,
//                       );
//                     },
//                     icon: const Icon(
//                       FontAwesomeIcons.x,
//                       color: Colors.white,
//                       size: 20,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             _buildChatMessages(),
//             Align(
//               alignment: Alignment.bottomCenter,
//               child: Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 10),
//                 height: Get.height * 0.075,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: [
//                     Column(
//                       children: [
//                         InkWell(
//                           onTap: () {
//                             showGiftConfirmationDialog(context, "50");
//                           },
//                           child: const Icon(
//                             Icons.star,
//                             size: 22,
//                             color: Colors.white,
//                           ),
//                         ),
//                         const Text(
//                           "50",
//                           style: TextStyle(
//                             fontSize: 13,
//                             fontWeight: FontWeight.w600,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(
//                       width: Get.width * 0.45,
//                       child: CustomTextField(
//                         fieldHeight: 40,
//                         textStyle: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 11,
//                         ),
//                         suffixIcon: Icons.send,
//                         onSuffixTap: () {
//                           _socketController.sendChatMessage(
//                             widget.channelName,
//                             _commentController.text,
//                             _userController.userModel.value?.id ?? "",
//                           );
//                           _commentController.clear();
//                         },
//                         enabledBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(20),
//                           borderSide: BorderSide.none,
//                         ),
//                         bgColor: const Color.fromARGB(255, 31, 31, 31),
//                         controller: _commentController,
//                         hintText: "Type here..",
//                         hintStyle: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 10,
//                         ),
//                       ),
//                     ),
//                     Column(
//                       children: [
//                         InkWell(
//                           onTap: () async {
//                             showGiftConfirmationDialog(context, "100");
//                           },
//                           child: const Icon(
//                             FontAwesomeIcons.fan,
//                             size: 22,
//                             color: Colors.red,
//                           ),
//                         ),
//                         const Text(
//                           "100",
//                           style: TextStyle(
//                             fontSize: 13,
//                             fontWeight: FontWeight.w600,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ],
//                     ),
//                     Column(
//                       children: [
//                         InkWell(
//                           onTap: () async {
//                             showGiftConfirmationDialog(context, "200");
//                           },
//                           child: const Icon(
//                             FontAwesomeIcons.gift,
//                             size: 22,
//                             color: Colors.red,
//                           ),
//                         ),
//                         const Text(
//                           "200",
//                           style: TextStyle(
//                             fontSize: 13,
//                             fontWeight: FontWeight.w600,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             Align(
//               alignment: Alignment.bottomCenter,
//               child: ConfettiWidget(
//                 confettiController:
//                     _liveStreamController.controllerBottomCenter,
//                 blastDirection: -pi / 2,
//                 emissionFrequency: 0.01,
//                 numberOfParticles: 20,
//                 maxBlastForce: 100,
//                 minBlastForce: 80,
//                 gravity: 0.3,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildChatMessages() {
//     return Align(
//       alignment: Alignment.bottomLeft,
//       child: Container(
//         height: Get.height * 0.3,
//         width: double.infinity,
//         padding: const EdgeInsets.all(8),
//         margin: const EdgeInsets.only(bottom: 40),
//         child: Obx(
//           () => ListView.builder(
//             controller: _scrollController,
//             itemCount: _socketController.chatMessages.length,
//             padding: EdgeInsets.zero,
//             itemBuilder: (context, index) {
//               final message = _socketController.chatMessages[index];
//               return _buildChatMessageBubble(message);
//             },
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildChatMessageBubble(LiveStreamChatModel message) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           CircleAvatar(
//             radius: 14,
//             backgroundImage: NetworkImage(message.userAvatar),
//           ),
//           const SizedBox(width: 8),
//           Flexible(
//             child: Container(
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: Colors.white.withOpacity(0.2),
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: RichText(
//                 text: TextSpan(
//                   children: [
//                     TextSpan(
//                       text: "${message.username}: ",
//                       style: const TextStyle(
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                     ),
//                     TextSpan(
//                       text: message.message,
//                       style: const TextStyle(color: Colors.white),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void showGiftConfirmationDialog(BuildContext context, String giftAmount) {
//     showDialog(
//       context: context,
//       builder: (BuildContext dialogContext) {
//         return AlertDialog(
//           title: const Text("Confirm Gift"),
//           content: Text(
//             "Are you sure you want to send $giftAmount to the streamer?",
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(dialogContext);
//               },
//               child: const Text("Cancel"),
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 Navigator.pop(dialogContext);
//                 await _userController.sendGift(
//                   coins: giftAmount,
//                   streamerId: widget.liveStreamModel.hostId,
//                 );
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.orange,
//               ),
//               child: Obx(
//                 () => _userController.isloading.value
//                     ? const CircularProgressIndicator(
//                         color: Colors.white,
//                       )
//                     : const Text(
//                         "Yes, Send",
//                         style: TextStyle(
//                           color: Colors.white,
//                         ),
//                       ),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
