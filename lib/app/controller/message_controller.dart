import 'dart:convert';
import 'dart:typed_data';
import 'package:echodate/app/controller/storage_controller.dart';
import 'package:echodate/app/models/chat_list_model.dart';
import 'package:echodate/app/models/message_model.dart';
import 'package:echodate/app/services/message_service.dart';
import 'package:echodate/app/widget/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class MessageController extends GetxController {
  RxBool isloading = false.obs;
  RxBool isChatListLoading = false.obs;
  RxBool isChattedListFetched = false.obs;
  final MessageService _messageService = MessageService();
  RxList<ChatListModel> allChattedUserList = <ChatListModel>[].obs;
  RxList<ChatListModel> activeFriends = <ChatListModel>[].obs;
  RxList<MessageModel> chatHistoryAndLiveMessage = <MessageModel>[].obs;
  final scrollController = ItemScrollController();
  RxMap<String, RxList<MessageModel>> savedChatToAvoidLoading =
      <String, RxList<MessageModel>>{}.obs;

  final RxnString highlightedMessageId = RxnString();
  final RxDouble highlightOpacity = 1.0.obs;
  final Map<String, GlobalKey> messageKeys = {};

  //cache-system
  final Map<String, Uint8List> _cache = {};
  Uint8List? get(String url) => _cache[url];
  void set(String url, Uint8List data) => _cache[url] = data;

  Future<void> sendMessage({
    required MessageModel messageModel,
  }) async {
    isloading.value = true;
    try {
      final storageController = Get.find<StorageController>();
      String? token = await storageController.getToken();
      if (token == null || token.isEmpty) {
        CustomSnackbar.showErrorSnackBar("Authentication required");
        return;
      }

      final response = await _messageService.sendMessage(
        token: token,
        messageModel: messageModel,
      );

      if (response == null) return;
      final decoded = json.decode(response.body);
      String message = decoded["message"] ?? "";
      if (response.statusCode != 200) {
        CustomSnackbar.showErrorSnackBar(message);
        return;
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isloading.value = false;
    }
  }

  Future<void> getMessageHistory({
    required String receiverUserId,
  }) async {
    isloading.value = true;
    try {
      final storageController = Get.find<StorageController>();
      String? token = await storageController.getToken();
      if (token == null || token.isEmpty) {
        CustomSnackbar.showErrorSnackBar("Authentication required");
        return;
      }

      final response = await _messageService.getMessageHistory(
        token: token,
        receiverUserId: receiverUserId,
      );
      if (response == null) return;
      final decoded = json.decode(response.body);
      String message = decoded["message"] ?? "";
      if (response.statusCode != 200) {
        CustomSnackbar.showErrorSnackBar(message);
        return;
      }
      List chatHistory = decoded["data"] ?? [];
      chatHistoryAndLiveMessage.clear();
      if (chatHistory.isEmpty) return;
      List<MessageModel> mapped =
          chatHistory.map((json) => MessageModel.fromJson(json)).toList();
      chatHistoryAndLiveMessage.assignAll(mapped);
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isloading.value = false;
    }
  }

  Future<void> getChatList({bool showLoading = true}) async {
    if (showLoading) {
      isChatListLoading.value = true;
    }
    try {
      final storageController = Get.find<StorageController>();
      String? token = await storageController.getToken();
      if (token == null || token.isEmpty) {
        CustomSnackbar.showErrorSnackBar("Authentication required");
        return;
      }

      final response = await _messageService.getChatList(
        token: token,
      );

      if (response == null) return;
      final decoded = json.decode(response.body);
      String message = decoded["message"] ?? "";
      if (response.statusCode != 200) {
        CustomSnackbar.showErrorSnackBar(message);
        return;
      }
      List chatHistory = decoded["chatList"] ?? [];
      allChattedUserList.clear();
      if (chatHistory.isEmpty) return;
      List<ChatListModel> mapped =
          chatHistory.map((e) => ChatListModel.fromJson(e)).toList();
      allChattedUserList.value = mapped;
      allChattedUserList.refresh();
      if (response.statusCode == 200) isChattedListFetched.value = true;
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isChatListLoading.value = false;
    }
    return;
  }

  Future<void> refreshChatList() async {
    try {
      final storageController = Get.find<StorageController>();
      String? token = await storageController.getToken();
      if (token == null || token.isEmpty) {
        CustomSnackbar.showErrorSnackBar("Authentication required");
        return;
      }

      final response = await _messageService.getChatList(
        token: token,
      );

      if (response == null) return;
      final decoded = json.decode(response.body);
      String message = decoded["message"] ?? "";
      if (response.statusCode != 200) {
        CustomSnackbar.showErrorSnackBar(message);
        return;
      }
      List chatHistory = decoded["chatList"] ?? [];
      allChattedUserList.clear();
      if (chatHistory.isEmpty) return;
      List<ChatListModel> mapped =
          chatHistory.map((e) => ChatListModel.fromJson(e)).toList();
      allChattedUserList.value = mapped;
      allChattedUserList.refresh();
      if (response.statusCode == 200) isChattedListFetched.value = true;
    } catch (e) {
      debugPrint(e.toString());
    }
    return;
  }

  void scrollToBottom() async {
    // if (scrollController.hasClients) {
    //   scrollController.scrollTo(
    //     index: 0,
    //     duration: const Duration(milliseconds: 300),
    //     curve: Curves.easeOut,
    //   );
    // }
    scrollController.scrollTo(
      index: 0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void scrollToMessage(String? messageId) {
    if (messageId == null) return;
    final messageIndex = chatHistoryAndLiveMessage.indexWhere((msg) => msg.id == messageId);
    if (messageIndex == -1) return;
    final reversedIndex = chatHistoryAndLiveMessage.length - 1 - messageIndex;
    scrollController.scrollTo(
      index: reversedIndex,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      alignment: 0.1, // Show item at 10% from top
    );
    Future.delayed(const Duration(milliseconds: 600), () {
      _highlightMessage(messageId);
    });
  }

  void _highlightMessage(String messageId) {
    highlightedMessageId.value = messageId;
    highlightOpacity.value = 1.0;

    Future.delayed(const Duration(seconds: 2), () async {
      for (double i = 1.0; i >= 0; i -= 0.1) {
        await Future.delayed(const Duration(milliseconds: 100));
        highlightOpacity.value = i;
      }
      highlightedMessageId.value = null;
    });
  }

  clearChatHistory() {
    isChattedListFetched.value = false;
    activeFriends.clear();
    allChattedUserList.clear();
    chatHistoryAndLiveMessage.clear();
    savedChatToAvoidLoading.clear();
    _cache.clear();
  }
}
