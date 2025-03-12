import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:echodate/app/utils/base_url.dart';
import 'package:echodate/app/widget/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class StoryService {
  http.Client client = http.Client();

  Future<http.StreamedResponse?> createStory({
    required String content,
    required String token,
    required String visibility,
    required List<File> mediaFiles,
  }) async {
    try {
      var uri = Uri.parse("$baseUrl/story/create");

      var request = http.MultipartRequest('POST', uri)
        ..headers['Authorization'] = 'Bearer $token'
        ..headers['Content-Type'] = 'multipart/form-data'
        ..fields['content'] = content
        ..fields['visibility'] = visibility;

      for (var mediaFile in mediaFiles) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'media',
            mediaFile.path,
          ),
        );
      }

      var response = await request.send();
      return response;
    } on SocketException catch (e) {
      CustomSnackbar.showErrorSnackBar("Check internet connection, $e");
      debugPrint("No internet connection");
      return null;
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<http.Response?> getAllStories({
    required String token,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/story/feed');
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      ).timeout(const Duration(seconds: 15));
      return response;
    } on SocketException catch (e) {
      debugPrint("No internet connection $e");
    } on TimeoutException {
      debugPrint("Request timeout");
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<http.Response?> getUserStories({
    required String token,
    required String userId,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/story/get-user-story/$userId');
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      ).timeout(const Duration(seconds: 15));
      return response;
    } on SocketException catch (e) {
      debugPrint("No internet connection $e");
    } on TimeoutException {
      debugPrint("Request timeout");
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<http.Response?> getUserPostedStories({
    required String token,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/story/get-user-posted-story');
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      ).timeout(const Duration(seconds: 15));
      return response;
    } on SocketException catch (e) {
      debugPrint("No internet connection $e");
    } on TimeoutException {
      debugPrint("Request timeout");
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<http.Response?> updateVisibility({
    required String token,
    required String storyId,
    required String visibility,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/story/update-visibility');
      final response = await http
          .post(url,
              headers: {'Authorization': 'Bearer $token'},
              body: jsonEncode({
                "visibility": visibility,
                "storyId": storyId,
              }))
          .timeout(const Duration(seconds: 15));
      return response;
    } on SocketException catch (e) {
      debugPrint("No internet connection $e");
    } on TimeoutException {
      debugPrint("Request timeout");
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<http.Response?> deleteStory({
    required String token,
    required String storyId,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/story/delete-story/$storyId');
      final response = await http.delete(
        url,
        headers: {'Authorization': 'Bearer $token'},
      ).timeout(const Duration(seconds: 15));
      return response;
    } on SocketException catch (e) {
      debugPrint("No internet connection $e");
    } on TimeoutException {
      debugPrint("Request timeout");
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }
}
