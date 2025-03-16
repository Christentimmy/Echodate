import 'dart:convert';
import 'package:confetti/confetti.dart';
import 'package:echodate/app/controller/socket_controller.dart';
import 'package:echodate/app/controller/storage_controller.dart';
import 'package:echodate/app/models/live_stream_model.dart';
import 'package:echodate/app/modules/live/views/broad.dart';
import 'package:echodate/app/modules/live/views/watch_live_screen.dart';
import 'package:echodate/app/services/live_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class LiveStreamController extends GetxController {
  final LiveStreamService _service = LiveStreamService();
  final _socketController = Get.find<SocketController>();
  var isLoading = false.obs;
  RxBool isJoinLoading = false.obs;
  RxBool isEndingLoading = false.obs;
  RxList<LiveStreamModel> activeStreams = <LiveStreamModel>[].obs;
  RxInt numberOfViewers = RxInt(0);
  final controllerBottomCenter = ConfettiController();

  Future<void> startLiveStream({
    required String visibility,
  }) async {
    isLoading.value = true;
    try {
      final storageController = Get.find<StorageController>();
      String? token = await storageController.getToken();
      if (token == null || token.isEmpty) return;

      final response = await _service.startLiveStream(
        token,
        visibility,
      );
      if (response == null) return;
      final decoded = json.decode(response.body);
      if (response.statusCode != 201) {
        print(decoded["message"]);
        return;
      }
      var stream = decoded["stream"] ?? "";
      if (stream == null || stream.isEmpty) return;
      LiveStreamModel liveStreamModel = LiveStreamModel.fromJson(stream);
      String? tempToken = decoded["token"];
      String? hostId = decoded["hostId"];
      String? channelName = decoded["stream"]["channelName"];
      if (tempToken == null || channelName == null || hostId == null) return;
      _socketController.joinStream(channelName);
      const prefs = FlutterSecureStorage();
      await prefs.delete(key: "channelName");
      await prefs.write(key: 'channelName', value: channelName);
      Get.off(
        () => BroadcastScreen(
          channelName: channelName,
          tempToken: tempToken,
          hostId: hostId,
          liveStreamModel: liveStreamModel,
        ),
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
      final storageController = Get.find<StorageController>();
      String? token = await storageController.getToken();
      if (token == null || token.isEmpty) return;

      final response = await _service.getActiveStreams(
        token: token,
      );
      if (response == null) return;
      final decoded = json.decode(response.body);
      print(decoded);
      if (response.statusCode != 200) {
        print(decoded["message"]);
        return;
      }
      List stream = decoded["streams"];
      activeStreams.clear();
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
      final storageController = Get.find<StorageController>();
      String? token = await storageController.getToken();
      if (token == null || token.isEmpty) return;

      final response = await _service.joinLiveStream(
        channelName,
        token,
      );
      if (response == null) {
        debugPrint("response is null");
        Get.back();
        return;
      }
      final decoded = json.decode(response.body);
      final joinToken = decoded['token'] ?? "";
      final uid = decoded['uid'];
      var stream = decoded["stream"] ?? "";
      if (joinToken == null || uid == null || stream == null) return;
      _socketController.joinStream(channelName);
      LiveStreamModel liveStreamModel = LiveStreamModel.fromJson(stream);
      Get.to(
        () => WatchLiveScreen(
          channelName: channelName,
          token: token,
          uid: uid,
          liveStreamModel: liveStreamModel,
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
    BuildContext context,
  ) async {
    isEndingLoading.value = true;
    try {
      final storageController = Get.find<StorageController>();
      String? token = await storageController.getToken();
      if (token == null || token.isEmpty) return;
      final response = await _service.endLiveStream(
        channelName,
        hostId,
        token,
      );
      if (response == null) return;
      final decoded = json.decode(response.body);
      if (response.statusCode != 200) {
        debugPrint(decoded["message"].toString());
        return;
      }
      activeStreams.clear();
      numberOfViewers.value = 0;
      const prefs = FlutterSecureStorage();
      await prefs.delete(key: 'channelName');
      Get.back();
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isEndingLoading.value = false;
    }
  }

  Future<void> leaveStream(
    String channelName,
    BuildContext context,
  ) async {
    isEndingLoading.value = true;
    try {
      final storageController = Get.find<StorageController>();
      String? token = await storageController.getToken();
      if (token == null || token.isEmpty) return;

      final response = await _service.leaveStream(
        channelName,
        token,
      );
      if (response == null) return;
      final decoded = json.decode(response.body);
      if (response.statusCode != 200) {
        debugPrint(decoded["message"].toString());
        return;
      }
      Get.back();
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isEndingLoading.value = false;
    }
  }

  @override
  void dispose() {
    controllerBottomCenter.dispose();
    super.dispose();
  }
}
