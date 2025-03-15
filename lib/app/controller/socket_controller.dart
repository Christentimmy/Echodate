// ignore_for_file: library_prefixes

import 'dart:async';
import 'package:echodate/app/controller/live_stream_controller.dart';
import 'package:echodate/app/controller/message_controller.dart';
import 'package:echodate/app/controller/storage_controller.dart';
import 'package:echodate/app/controller/story_controller.dart';
import 'package:echodate/app/controller/user_controller.dart';
import 'package:echodate/app/models/chat_list_model.dart';
import 'package:echodate/app/models/live_stream_chat_model.dart';
import 'package:echodate/app/models/live_stream_model.dart';
import 'package:echodate/app/utils/base_url.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketController extends GetxController {
  IO.Socket? socket;
  RxList<LiveStreamChatModel> chatMessages = <LiveStreamChatModel>[].obs;
  RxBool isloading = false.obs;
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

    socket?.onConnect((_) async {
      getOnlineUser();
      const prefs = FlutterSecureStorage();
      final channelName = await prefs.read(key: 'channelName');
      if (channelName != null && channelName.isNotEmpty) {
        await Future.delayed(const Duration(seconds: 3), () {
          joinStream(channelName);
        });
      }

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
    socket?.on('newChatMessage', (data) {
      final newMessage = LiveStreamChatModel.fromJson(data);
      chatMessages.add(newMessage);
      chatMessages.refresh();
    });

    socket?.on("new-story", (data) {
      _storyController.getAllStories();
    });

    socket?.on("newstream", (data) async {
      LiveStreamModel newStream = LiveStreamModel.fromJson(data);
      final liveStreamController = Get.find<LiveStreamController>();
      liveStreamController.activeStreams.add(newStream);
      liveStreamController.activeStreams.refresh();
    });

    socket?.on("endedStream", (data) async {
      LiveStreamModel endedStream = LiveStreamModel.fromJson(data);
      final liveStreamController = Get.find<LiveStreamController>();
      liveStreamController.activeStreams
          .removeWhere((e) => e.channelName == endedStream.channelName);
      liveStreamController.activeStreams.refresh();
    });

    socket?.on("viewer-count-updated", (data) {
      final liveStreamController = Get.find<LiveStreamController>();
      int viewers = data ?? 0;
      liveStreamController.numberOfViewers.value = viewers;
      liveStreamController.numberOfViewers.refresh();
    });

    socket?.on("refresh", (data) {
      final userController = Get.find<UserController>();
      userController.getUserDetails();
    });

    socket?.on("update-online-chat-list", (data) {
      final response = List.from(data);
      if (response.isEmpty) return;
      print(response);
      List<ChatListModel> mapped =
          response.map((e) => ChatListModel.fromJson(e)).toList();
      Get.find<MessageController>().activeFriends.value = mapped;
      Get.find<MessageController>().activeFriends.refresh();
    });
  }

  void getOnlineUser() {
    if (socket != null && socket!.connected) {
      socket?.emit("user-online");
    }
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
    if (socket == null || !socket!.connected) {
      print("Socket is not connected");
      return;
    }

    if (channelName.isEmpty) {
      print("Invalid channelName");
      return;
    }

    print("Emitting joinStream event for channel: $channelName");
    socket?.emit('joinStream', {"channelName": channelName});
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
