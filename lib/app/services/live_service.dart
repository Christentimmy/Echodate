import 'dart:async';
import 'dart:io';

import 'package:echodate/app/utils/base_url.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LiveStreamService {
  Future<http.Response?> startLiveStream(
    String token,
    String visibility,
  ) async {
    try {
      final response = await http
          .post(
            Uri.parse("$baseUrl/live/start"),
            headers: {
              "Content-Type": "application/json",
              "Authorization": "Bearer $token"
            },
            body: visibility.isNotEmpty
                ? jsonEncode({"visibility": visibility})
                : null,
          )
          .timeout(const Duration(seconds: 60));
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

  Future<http.Response?> getActiveStreams({
    required String token,
  }) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/live/active"),
        headers: {"Authorization": "Bearer $token"},
      ).timeout(const Duration(seconds: 60));
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

  Future<http.Response?> joinLiveStream(
    String channelName,
    String token,
  ) async {
    try {
      final response = await http
          .post(
            Uri.parse("$baseUrl/live/join"),
            headers: {
              "Content-Type": "application/json",
              "Authorization": "Bearer $token"
            },
            body: jsonEncode({"channelName": channelName}),
          )
          .timeout(const Duration(seconds: 60));
      return response;
    } on SocketException catch (e) {
      debugPrint("No internet connection $e");
    } on TimeoutException {
      debugPrint("Request timeout");
    } catch (e, stackTrace) {
      debugPrint("${e.toString()} Trace: $stackTrace");
    }
    return null;
  }

  Future<http.Response?> endLiveStream(
    String channelName,
    String hostId,
    String token,
  ) async {
    try {
      final response = await http
          .post(
            Uri.parse("$baseUrl/live/end"),
            headers: {
              "Content-Type": "application/json",
              "Authorization": "Bearer $token"
            },
            body: jsonEncode({
              "channelName": channelName,
              "hostId": hostId,
            }),
          )
          .timeout(const Duration(seconds: 60));
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

  Future<http.Response?> leaveStream(
    String channelName,
    String token,
  ) async {
    try {
      final response = await http
          .post(Uri.parse("$baseUrl/live/leave"),
              headers: {
                "Content-Type": "application/json",
                "Authorization": "Bearer $token"
              },
              body: jsonEncode({"channelName": channelName}))
          .timeout(const Duration(seconds: 60));
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
