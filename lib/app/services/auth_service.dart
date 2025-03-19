import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:echodate/app/models/user_model.dart';
import 'package:echodate/app/utils/base_url.dart';
import 'package:echodate/app/widget/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthService {
  http.Client client = http.Client();

  Future<http.Response?> signUpUser({required UserModel userModel}) async {
    try {
      final response = await client
          .post(
            Uri.parse("$baseUrl/auth/register"),
            body: userModel.toJson(),
          )
          .timeout(const Duration(seconds: 60));
      return response;
    } on SocketException catch (e) {
      CustomSnackbar.showErrorSnackBar("Check internet connection");
      debugPrint("SocketException: $e");
    } on TimeoutException {
      CustomSnackbar.showErrorSnackBar(
        "Request timeout, probably Bad network, try again",
      );
      debugPrint("Request Time out");
    } catch (e) {
      debugPrint("Error From Auth Servie: ${e.toString()}");
    }
    return null;
  }

  Future<http.Response?> loginUser({
    required String identifier,
    required String password,
  }) async {
    try {
      http.Response response = await client.post(
        Uri.parse("$baseUrl/auth/login"),
        body: {
          "identifier": identifier,
          "password": password,
        },
      ).timeout(const Duration(seconds: 15));

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

  Future<http.Response?> verifyOtp({
    required String otpCode,
    String? email,
    String? phoneNumber,
  }) async {
    try {
      final Map<String, String> body = {
        "otp": otpCode,
      };

      if (email?.isNotEmpty == true) {
        body["email"] = email!;
      }

      if (phoneNumber?.isNotEmpty == true) {
        body["phone_number"] = phoneNumber!;
      }

      final response = await client
          .post(
            Uri.parse("$baseUrl/auth/verify-otp"),
            body: body,
          )
          .timeout(const Duration(seconds: 15));
      return response;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<http.Response?> sendOtp({required String token}) async {
    try {
      final response = await client.post(
        Uri.parse("$baseUrl/auth/send-otp"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        },
      ).timeout(const Duration(seconds: 15));
      return response;
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<http.Response?> sendNumberOTP({
    required String token,
  }) async {
    try {
      final response = await client.post(
        Uri.parse("$baseUrl/auth/send-number-otp"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        },
      ).timeout(const Duration(seconds: 15));
      return response;
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<http.StreamedResponse?> completeProfile({
    required UserModel userModel,
    required String token,
    required File imageFile,
  }) async {
    try {
      var uri = Uri.parse("$baseUrl/auth/complete-profile");

      var request = http.MultipartRequest('PUT', uri)
        ..headers['Authorization'] = 'Bearer $token'
        ..headers['Content-Type'] = 'multipart/form-data'
        ..fields['full_name'] = userModel.fullName!
        ..fields['bio'] = userModel.bio!
        ..fields['dob'] = userModel.dob!
        ..files.add(
          await http.MultipartFile.fromPath(
            'avater',
            imageFile.path,
          ),
        );

      var response = await request.send().timeout(const Duration(seconds: 15));
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
      debugPrint(e.toString());
    }
    return null;
  }

  Future<http.Response?> changePassword({
    required String oldPassword,
    required String newPassword,
    required String token,
  }) async {
    try {
      final response = await client.post(
        Uri.parse("$baseUrl/auth/change-password"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: json.encode({
          "old_password": oldPassword,
          "new_password": newPassword,
        }),
      );
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

  Future<http.Response?> logout({
    required String token,
  }) async {
    try {
      final url = Uri.parse("$baseUrl/auth/logout");
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );
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

  Future<http.Response?> deleteAccount({
    required String token,
  }) async {
    try {
      final url = Uri.parse("$baseUrl/auth/delete-account");
      final response = await http.delete(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );
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

  Future<http.Response?> sendOtpForgotPassword({
    required String email,
  }) async {
    try {
      final response = await client
          .post(
            Uri.parse("$baseUrl/auth/send-otp-forgot-password"),
            headers: {"Content-Type": "application/json"},
            body: json.encode({"email": email}),
          )
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

  Future<http.Response?> forgotPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await client
          .post(
            Uri.parse("$baseUrl/auth/forgot-password"),
            headers: {"Content-Type": "application/json"},
            body: json.encode({
              "email": email,
              "password": password,
            }),
          )
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
}
