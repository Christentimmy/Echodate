import 'package:echodate/app/utils/base_url.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LiveStreamService {
  
  Future<http.Response?> startLiveStream(
    String token,
  ) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/live/start"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
      );
      return response;
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
      );
      return response;
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
      final response = await http.post(
        Uri.parse("$baseUrl/live/join"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: jsonEncode({"channelName": channelName}),
      );
      return response;
    } catch (e, stackTrace) {
      debugPrint("${e.toString()} Trace: $stackTrace");
    }
    return null;
  }

  Future<bool> endLiveStream(
    String channelName,
    String hostId,
    String token,
  ) async {
    final response = await http.post(
      Uri.parse("$baseUrl/live/end"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
      body: jsonEncode({
        "channelName": channelName,
        "hostId": hostId,
      }),
    );

    return response.statusCode == 200;
  }
}
