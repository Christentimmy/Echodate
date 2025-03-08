import 'dart:convert';
import 'dart:io';

import 'package:echodate/app/controller/storage_controller.dart';
import 'package:echodate/app/models/story_model.dart';
import 'package:echodate/app/services/story_service.dart';
import 'package:echodate/app/widget/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StoryController extends GetxController {
  RxBool isloading = false.obs;
  final StoryService _storyService = StoryService();
  RxList<StoryModel> allstoriesList = RxList<StoryModel>();
  RxList<StoryModel> userPostedStoryList = RxList<StoryModel>();

  Future<void> createStory({
    required File media,
    required String content,
    required String visibility,
  }) async {
    isloading.value = true;
    try {
      final storageController = Get.find<StorageController>();
      final String? token = await storageController.getToken();
      if (token == null) return;
      final response = await _storyService.createStory(
        content: content,
        token: token,
        visibility: visibility,
        media: media,
      );
      if (response == null) return;
      final responseBody = await response.stream.bytesToString();
      final decoded = json.decode(responseBody);
      if (response.statusCode != 200) {
        CustomSnackbar.showErrorSnackBar(decoded["message"]);
        return;
      }
      CustomSnackbar.showSuccessSnackBar("Story created successfully!");
      Get.back();
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isloading.value = false;
    }
  }

  Future<void> getAllStories() async {
    isloading.value = true;
    try {
      final storageController = Get.find<StorageController>();
      final String? token = await storageController.getToken();
      if (token == null) return;
      final response = await _storyService.getAllStories(token: token);
      if (response == null) return;
      final decoded = json.decode(response.body);
      if (response.statusCode != 200) {
        CustomSnackbar.showErrorSnackBar(decoded["message"]);
        return;
      }
      List stories = decoded["data"];
      if (stories.isEmpty) return;
      List<StoryModel> mappedList =
          stories.map((data) => StoryModel.fromJson(data)).toList();
      allstoriesList.value = mappedList;
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isloading.value = false;
    }
  }

  Future<List<StoryModel>?> getUserStories({
    required String userId,
  }) async {
    isloading.value = true;
    try {
      final storageController = Get.find<StorageController>();
      final String? token = await storageController.getToken();
      if (token == null) return null;
      final response =
          await _storyService.getUserStories(userId: userId, token: token);
      if (response == null) return null;
      final decoded = json.decode(response.body);
      if (response.statusCode != 200) {
        CustomSnackbar.showErrorSnackBar(decoded["message"]);
        return null;
      }
      List stories = decoded["data"];
      if (stories.isEmpty) return null;
      List<StoryModel> mappedList =
          stories.map((data) => StoryModel.fromJson(data)).toList();
      return mappedList;
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isloading.value = false;
    }
    return null;
  }

  Future<void> updateVisibility({
    required String storyId,
    required String visibility,
  }) async {
    try {
      final storageController = Get.find<StorageController>();
      final String? token = await storageController.getToken();
      if (token == null) return;
      final response = await _storyService.updateVisibility(
        token: token,
        storyId: storyId,
        visibility: visibility,
      );
      if (response == null) return;
      final decoded = json.decode(response.body);
      if (response.statusCode != 200) {
        CustomSnackbar.showErrorSnackBar(decoded["message"]);
        return;
      }
      CustomSnackbar.showSuccessSnackBar("Visibility updated successfully!");
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> deleteStory({
    required String storyId,
  }) async {
    isloading.value = true;
    try {
      final storageController = Get.find<StorageController>();
      final String? token = await storageController.getToken();
      if (token == null) return;
      final response =
          await _storyService.deleteStory(storyId: storyId, token: token);
      if (response == null) return;
      final decoded = json.decode(response.body);
      if (response.statusCode != 200) {
        CustomSnackbar.showErrorSnackBar(decoded["message"]);
        return;
      }
      CustomSnackbar.showSuccessSnackBar("Story deleted successfully!");
      allstoriesList.removeWhere((story) => story.id == storyId);
      await getAllStories();
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isloading.value = false;
    }
  }

  Future<void> getUserPostedStories() async {
    try {
      final storageController = Get.find<StorageController>();
      final String? token = await storageController.getToken();
      if (token == null) return;
      final response = await _storyService.getUserPostedStories(token: token);
      if (response == null) return;
      final decoded = json.decode(response.body);
      if (response.statusCode != 200) {
        CustomSnackbar.showErrorSnackBar(decoded["message"]);
        return;
      }
      List stories = decoded["data"];
      if (stories.isEmpty) return;
      List<StoryModel> mappedList =
          stories.map((e) => StoryModel.fromJson(e)).toList();
      userPostedStoryList.value = mappedList;
      userPostedStoryList.refresh();
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
