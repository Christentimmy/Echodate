// ignore_for_file: library_prefixes

import 'dart:async';
import 'package:echodate/app/controller/storage_controller.dart';
import 'package:echodate/app/controller/story_controller.dart';
// import 'package:echodate/app/controller/user_controller.dart';
import 'package:echodate/app/models/live_stream_chat_model.dart';
import 'package:echodate/app/utils/base_url.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketController extends GetxController {
  IO.Socket? socket;
  RxList<LiveStreamChatModel> chatMessages = <LiveStreamChatModel>[].obs;
  // RxList<ChatModel> chatModelList = <ChatModel>[].obs;
  RxBool isloading = false.obs;
  // final _userController = Get.find<UserController>();
  final _storyController = Get.find<StoryController>();
  int _reconnectAttempts = 0;
  final int _maxReconnectAttempts = 5;

  void initializeSocket() async {
    String? token = await StorageController().getToken();
    if (token == null) {
      return;
    }

    socket = IO.io(baseUrl, <String, dynamic>{
      'transports': ['websocket'],
      'extraHeaders': {'Authorization': 'Bearer $token'},
      'reconnection': true,
      "forceNew": true,
    });

    socket?.connect();

    socket?.onConnect((_) {
      print("Socket connected successfully");
      listenToEvents();
    });

    socket?.onDisconnect((_) {
      print("Socket disconnected");
      scheduleReconnect();
      if (_reconnectAttempts >= _maxReconnectAttempts) {
        disConnectListeners();
      }
    });

    socket?.on('connect_error', (_) {
      print("Connection error");
      scheduleReconnect();
    });
  }

  void listenToEvents() {
    socket?.on("userDetails", (data) {
      debugPrint(data.toString());
    });

    socket?.on('newChatMessage', (data) {
      final newMessage = LiveStreamChatModel.fromJson(data);
      chatMessages.insert(0, newMessage);
    });

    socket?.on("new-story", (data) {
      _storyController.getAllStories();
    });
  }

  void disConnectListeners() async {
    if (socket != null) {
      socket?.off("userDetails");
      socket?.off("newChatMessage");
    }
  }

  void disconnectSocket() {
    disConnectListeners();
    socket?.disconnect();
    socket = null;
    socket?.close();
    print('Socket disconnected and deleted');
  }

  void sendMessage({
    required String message,
    required String rideId,
  }) {
    final payload = {
      "rideId": rideId,
      "message": message,
    };
    socket?.emit('sendMessage', payload);
  }

  // void joinRoom({required String roomId}) {
  //   socket?.emit("joinRoom", {"roomId": roomId});
  // }

  void getChatHistory(String rideId) {
    socket?.emit("history", {"rideId": rideId});
  }

  void markRead({
    required String channedId,
    required String messageId,
  }) async {
    socket?.emit("MARK_MESSAGE_READ", {
      "channel_id": channedId,
      "message_ids": [messageId],
    });
  }

  void scheduleReconnect() {
    if (_reconnectAttempts >= _maxReconnectAttempts) {
      debugPrint("🚨 Max reconnection attempts reached. Stopping retry.");
      return;
    }

    int delay = 2 * _reconnectAttempts + 2;
    debugPrint("🔄 Reconnecting in $delay seconds...");

    Future.delayed(Duration(seconds: delay), () {
      _reconnectAttempts++;
      socket?.connect();
    });
  }

  void joinStream(String channelName) {
    socket?.emit('joinStream', channelName);
  }

  void sendChatMessage(
    String channelName,
    String message,
    String currentUserId,
  ) {
    socket?.emit('sendChatMessage', {
      'channelName': channelName,
      'userId': currentUserId,
      'message': message,
    });
  }

  @override
  void onClose() {
    socket?.dispose();
    super.onClose();
    socket = null;
  }
}
