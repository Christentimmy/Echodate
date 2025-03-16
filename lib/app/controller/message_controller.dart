import 'dart:convert';
import 'package:echodate/app/controller/storage_controller.dart';
import 'package:echodate/app/models/chat_list_model.dart';
import 'package:echodate/app/models/message_model.dart';
import 'package:echodate/app/services/message_service.dart';
import 'package:echodate/app/widget/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MessageController extends GetxController {
  RxBool isloading = false.obs;
  RxBool isChatListLoading = false.obs;
  RxBool isChattedListFetched = false.obs;
  final MessageService _messageService = MessageService();
  RxList<ChatListModel> allChattedUserList = <ChatListModel>[].obs;
  RxList<ChatListModel> activeFriends = <ChatListModel>[].obs;
  RxList<MessageModel> chatHistoryAndLiveMessage = <MessageModel>[].obs;

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
      if (chatHistory.isEmpty) return;
      List<MessageModel> mapped =
          chatHistory.map((json) => MessageModel.fromJson(json)).toList();
      chatHistoryAndLiveMessage.value = mapped;
      chatHistoryAndLiveMessage.refresh();
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isloading.value = false;
    }
    return null;
  }

  Future<void> getChatList() async {
    isChatListLoading.value = true;
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
}
