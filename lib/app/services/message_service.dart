import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:echodate/app/controller/storage_controller.dart';
import 'package:echodate/app/models/message_model.dart';
import 'package:echodate/app/utils/base_url.dart';
import 'package:echodate/app/widget/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class MessageService {
  http.Client client = http.Client();

  Future<http.Response?> sendMessage({
    required String token,
    required MessageModel messageModel,
  }) async {
    try {
      http.Response response = await client
          .post(
            Uri.parse("$baseUrl/message/send"),
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
            body: jsonEncode(messageModel.toJson()),
          )
          .timeout(const Duration(seconds: 15));
      return response;
    } on SocketException catch (e) {
      CustomSnackbar.showErrorSnackBar("Check internet connection, $e");
      debugPrint("No internet connection");
      return null;
    } on TimeoutException {
      CustomSnackbar.showErrorSnackBar(
        "Request timeout, probably bad network, try again",
      );
      debugPrint("Request timeout");
      return null;
    } catch (e) {
      throw Exception("Unexpected error $e");
    }
  }

  Future<http.Response?> getMessageHistory({
    required String token,
    required String receiverUserId,
  }) async {
    try {
      http.Response response = await client.get(
        Uri.parse("$baseUrl/message/history/$receiverUserId"),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 60));
      return response;
    } on SocketException catch (e) {
      CustomSnackbar.showErrorSnackBar("Check internet connection, $e");
      debugPrint("No internet connection");
      return null;
    } on TimeoutException {
      CustomSnackbar.showErrorSnackBar(
        "Request timeout, probably bad network, try again",
      );
      debugPrint("Request timeout");
      return null;
    } catch (e) {
      throw Exception("Unexpected error $e");
    }
  }

  Future<http.Response?> getChatList({
    required String token,
  }) async {
    try {
      http.Response response = await client.get(
        Uri.parse("$baseUrl/message/get-chat-list"),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 60));
      return response;
    } on SocketException catch (e) {
      CustomSnackbar.showErrorSnackBar("Check internet connection, $e");
      debugPrint("No internet connection");
      return null;
    } on TimeoutException {
      debugPrint("Request timeout");
      return null;
    } catch (e) {
      throw Exception("Unexpected error $e");
    }
  }

  Future<String?> uploadMedia(File file) async {
    final token = await Get.find<StorageController>().getToken();
    var request = http.MultipartRequest(
      "POST",
      Uri.parse("$baseUrl/message/upload"),
    );

    request.headers.addAll({
      'Authorization': 'Bearer $token',
      'Content-Type': 'multipart/form-data',
    });

    request.files.add(
      await http.MultipartFile.fromPath(
        'file',
        file.path,
        contentType: file.path.endsWith('.mp4')
            ? MediaType("video", "mp4")
            : MediaType("image", "jpeg"),
      ),
    );

    var response = await request.send();

    if (response.statusCode == 200) {
      var responseData = await response.stream.bytesToString();
      var jsonResponse = jsonDecode(responseData);
      return jsonResponse["mediaUrl"];
    } else {
      return null; // Upload failed
    }
  }
}
