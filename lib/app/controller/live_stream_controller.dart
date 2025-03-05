import 'dart:convert';
import 'package:echodate/app/controller/socket_controller.dart';
import 'package:echodate/app/models/live_stream_model.dart';
import 'package:echodate/app/modules/live/views/broad.dart';
import 'package:echodate/app/modules/live/views/view_stream.dart';
import 'package:echodate/app/services/live_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LiveStreamController extends GetxController {
  final LiveStreamService _service = LiveStreamService();
  final _socketController = Get.find<SocketController>();
  var isLoading = false.obs;
  RxBool isJoinLoading = false.obs;
  RxList<LiveStreamModel> activeStreams = <LiveStreamModel>[].obs;
  String authToken =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY3YzFhZWNhY2YwZTY2M2I4ZTU0NTAwOSIsInJvbGUiOiJ1c2VyIiwiaWF0IjoxNzQwOTM4OTUyLCJleHAiOjE3NDExMTE3NTJ9.hePBiavrDtMc3lEx8FfwT_cJEklRLtaXXkCnnC2W16I";

  Future<void> startLiveStream() async {
    isLoading.value = true;
    try {
      final response = await _service.startLiveStream(authToken);
      if (response == null) return;
      final decoded = json.decode(response.body);
      if (response.statusCode != 201) {
        print(decoded["message"]);
        return;
      }
      String? token = decoded["token"];
      String? channelName = decoded["stream"]["channelName"];
      print(channelName);
      print(token);
      if (token == null || channelName == null) return;
      Get.to(
        () => BroadcastScreen(channelName: channelName, tempToken: token),
      );
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchActiveStreams() async {
    isLoading.value = true;
    try {
      final response = await _service.getActiveStreams(token: authToken);
      if (response == null) return;
      final decoded = json.decode(response.body);
      if (response.statusCode != 200) {
        print(decoded["message"]);
        return;
      }
      List stream = decoded["streams"];
      if (stream.isEmpty) return;
      List<LiveStreamModel> mapped =
          stream.map((e) => LiveStreamModel.fromJson(e)).toList();
      activeStreams.value = mapped;
      activeStreams.refresh();
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> joinLiveStream(String channelName) async {
    isJoinLoading.value = true;
    try {
      final response = await _service.joinLiveStream(
        channelName,
        authToken,
      );
      if (response == null) {
        debugPrint("response is null");
        Get.back();
        return;
      }
      final decoded = json.decode(response.body);
      final token = decoded['token'];
      final uid = decoded['uid'];
      print("UID: $uid");
      if (token == null || uid == null) return;
      _socketController.joinStream(channelName);
      Get.to(
        () => LiveStreamScreen(
          channelName: channelName,
          token: token,
          uid: uid,
        ),
      );
    } catch (e, stackTrace) {
      debugPrint("${e.toString()}, $stackTrace");
    } finally {
      isJoinLoading.value = false;
    }
  }

  Future<void> endLiveStream(
    String channelName,
    String hostId,
    String authToken,
  ) async {
    isLoading(true);
    await _service.endLiveStream(channelName, hostId, authToken);
    // currentStream.clear();
    isLoading(false);
  }
}
