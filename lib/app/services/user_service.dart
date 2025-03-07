import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:echodate/app/utils/base_url.dart';
import 'package:echodate/app/widget/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mime_type/mime_type.dart';

class UserService {
  http.Client client = http.Client();

  Future<http.Response?> getUserStatus({
    required String token,
  }) async {
    try {
      final response = await client.get(
        Uri.parse('$baseUrl/user/user-status'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 9));
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

  Future<http.Response?> getUserDetails({required String token}) async {
    try {
      final response = await client.get(
        Uri.parse("$baseUrl/user/get-user-details"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
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

  Future<http.Response?> saveUserOneSignalId({
    required String token,
    required String id,
  }) async {
    try {
      final response = await client.post(
        Uri.parse("$baseUrl/user/save-signal-id/$id"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
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

  Future<http.Response?> initiateStripePayment({
    required String token,
    required String coinPackageId,
  }) async {
    try {
      final response = await client
          .post(
            Uri.parse('$baseUrl/paystack/initialize'),
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
            body: jsonEncode({'coinPackageId': coinPackageId}),
          )
          .timeout(const Duration(seconds: 15));
      return response;
    } on SocketException catch (e) {
      debugPrint("No internet connection: $e");
    } on TimeoutException {
      debugPrint("Request timeout");
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<http.Response?> updateUserDetails({
    required String token,
    String? fullName,
    String? bio,
    String? email,
    String? gender,
    String? dateOfBirth,
    File? profilePicture,
  }) async {
    try {
      var request = http.MultipartRequest(
        'PATCH',
        Uri.parse('$baseUrl/user/update-user'),
      );

      // Set headers
      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Content-Type': 'multipart/form-data',
      });

      if (fullName != null) request.fields['full_name'] = fullName;
      if (bio != null) request.fields['bio'] = bio;
      if (email != null) request.fields['email'] = email;
      if (gender != null) request.fields['gender'] = gender;
      if (dateOfBirth != null) request.fields['date_of_birth'] = dateOfBirth;

      // Attach profile picture if provided
      if (profilePicture != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'profilePicture',
            profilePicture.path,
          ),
        );
      }

      // Send request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      return response;
    } on SocketException catch (e) {
      debugPrint("No internet connection: $e");
    } on TimeoutException {
      debugPrint("Request timeout");
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<http.Response?> getUserPaymentHistory({
    required String token,
    required String type,
    required int limit,
    String? status,
    String? startDate,
    String? endDate,
  }) async {
    try {
      String url =
          "$baseUrl/user/get-user-payment-history?type=$type&limit=$limit";
      if (status != null && status.isNotEmpty) {
        url += "&status=$status";
      }
      if (startDate != null && startDate.isNotEmpty) {
        url += "&startDate=$startDate";
      }
      if (endDate != null && endDate.isNotEmpty) {
        url += "&endDate=$endDate";
      }
      Uri uri = Uri.parse(url);
      final response = await client.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
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

  Future<http.StreamedResponse?> uploadPhotos({
    required List<File> photos,
    required String token,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/user/upload-photos');
      var request = http.MultipartRequest('POST', url);
      request.headers['Authorization'] = 'Bearer $token';
      for (var photo in photos) {
        var mimeType = mime(photo.path)?.split('/');
        if (mimeType != null) {
          var file = await http.MultipartFile.fromPath(
            'photos',
            photo.path,
            // contentType: MediaType(mimeType[0], mimeType[1]),
          );
          request.files.add(file);
        }
      }
      var response = await request.send();
      return response;
      // Check the response status
      // if (response.statusCode == 200) {
      //   print('Photos uploaded successfully');
      //   var responseData = await response.stream.bytesToString();
      //   print('Response: $responseData');
      // } else {
      //   print('Failed to upload photos. Status code: ${response.statusCode}');
      //   var errorData = await response.stream.bytesToString();
      //   print('Error: $errorData');
      // }
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

  Future<http.Response?> updateLocation({
    required String token,
    required double latitude,
    required double longitude,
  }) async {
    try {
      final response = await client
          .patch(
            Uri.parse("$baseUrl/user/update-location"),
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
            body: jsonEncode({'latitude': latitude, 'longitude': longitude}),
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

  Future<http.Response?> updateHobbies({
    required String token,
    required List<String> hobbies,
  }) async {
    try {
      final response = await client
          .patch(Uri.parse("$baseUrl/user/hobbies"),
              headers: {
                'Authorization': 'Bearer $token',
                'Content-Type': 'application/json',
              },
              body: jsonEncode({'hobbies': hobbies}))
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

  Future<http.Response?> updatePreference({
    required String token,
    required String minAge,
    required String maxAge,
    required String interestedIn,
    required String distance,
  }) async {
    try {
      final response = await client
          .patch(Uri.parse("$baseUrl/user/preferences"),
              headers: {
                'Authorization': 'Bearer $token',
                'Content-Type': 'application/json',
              },
              body: jsonEncode({
                'ageRange': [minAge, maxAge],
                'interestedIn': interestedIn,
                'distance': distance,
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

  Future<http.Response?> getPotentialMatches({
    required String token,
  }) async {
    try {
      final response = await client.get(
          Uri.parse(
            "$baseUrl/user/get-potential-matches",
          ),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          }).timeout(const Duration(seconds: 15));
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

  Future<http.Response?> updateGender({
    required String token,
    required String gender,
  }) async {
    try {
      final response = await client
          .patch(Uri.parse("$baseUrl/user/update-gender"),
              headers: {
                'Authorization': 'Bearer $token',
                'Content-Type': 'application/json',
              },
              body: jsonEncode({'gender': gender}))
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

  Future<http.Response?> updateInterestedIn({
    required String token,
    required String interestedIn,
  }) async {
    try {
      final response = await client
          .patch(Uri.parse("$baseUrl/user/update-interested-in"),
              headers: {
                'Authorization': 'Bearer $token',
                'Content-Type': 'application/json',
              },
              body: jsonEncode({'interest_in': interestedIn}))
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

  Future<http.Response?> swipeLike({
    required String token,
    required String swipedUserId,
  }) async {
    try {
      final response = await client
          .post(Uri.parse("$baseUrl/user/swipe/like"),
              headers: {
                'Authorization': 'Bearer $token',
                'Content-Type': 'application/json',
              },
              body: jsonEncode({'swipedUserId': swipedUserId}))
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

  Future<http.Response?> swipeDislike({
    required String token,
    required String swipedUserId,
  }) async {
    try {
      final response = await client
          .post(Uri.parse("$baseUrl/user/swipe/dislike"),
              headers: {
                'Authorization': 'Bearer $token',
                'Content-Type': 'application/json',
              },
              body: jsonEncode({'swipedUserId': swipedUserId}))
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

  Future<http.Response?> swipeSuperLike({
    required String token,
    required String swipedUserId,
  }) async {
    try {
      final response = await client
          .post(Uri.parse("$baseUrl/user/swipe/super-like"),
              headers: {
                'Authorization': 'Bearer $token',
                'Content-Type': 'application/json',
              },
              body: jsonEncode({'swipedUserId': swipedUserId}))
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

  Future<http.Response?> getMatches({
    required String token,
  }) async {
    try {
      final response = await client.get(
          Uri.parse(
            "$baseUrl/user/get-matches",
          ),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          }).timeout(const Duration(seconds: 15));
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

  Future<http.Response?> getNotifications({
    required String token,
    int? page,
    int? limit,
    bool? unread,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/user-notifications').replace(
        queryParameters: {
          if (page != null) 'page': page.toString(),
          if (limit != null) 'limit': limit.toString(),
          if (unread != null) 'unread': unread.toString(),
        },
      );
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
}
