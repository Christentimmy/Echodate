import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:echodate/app/utils/base_url.dart';
import 'package:echodate/app/utils/get_file_type.dart';
import 'package:echodate/app/widget/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

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
    String? type,
    int? limit,
    String? status,
    String? startDate,
    String? endDate,
  }) async {
    try {
      String url = "$baseUrl/user/get-user-payment-history?";
      if (type != null && type.isNotEmpty) {
        url += "&type=$type";
      }
      if (limit != null && limit != 0) {
        url += "&limit=$limit";
      }
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
        final filePath = photo.path;
        var file = await http.MultipartFile.fromPath(
          'photos',
          photo.path,
          contentType: MediaType.parse(getMimeType(filePath)),
        );
        request.files.add(file);
      }
      var response = await request.send();
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

  Future<http.Response?> updateLocation({
    required String token,
    required double latitude,
    required double longitude,
    required String address,
  }) async {
    try {
      final response = await client
          .patch(
            Uri.parse("$baseUrl/user/update-location"),
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              'latitude': latitude,
              'longitude': longitude,
              "address": address,
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
    String? token,
    String? minAge,
    String? maxAge,
    String? interestedIn,
    String? distance,
  }) async {
    try {
      final Map<String, dynamic> body = {};
      if (minAge != null && minAge.isNotEmpty) {
        body['minAge'] = int.parse(minAge);
      }
      if (maxAge != null && maxAge.isNotEmpty) {
        body['maxAge'] = int.parse(maxAge);
      }
      if (interestedIn != null && interestedIn.isNotEmpty) {
        body['interestedIn'] = interestedIn;
      }
      if (distance != null && distance.isNotEmpty) {
        body['distance'] = int.parse(distance);
      }
      final response = await client
          .patch(
            Uri.parse("$baseUrl/user/preferences"),
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
            body: jsonEncode(body),
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
      final url = Uri.parse('$baseUrl/user/user-notifications').replace(
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

  Future<http.Response?> markNotificationsRead({
    required String token,
    required List<String> notificationIds,
  }) async {
    try {
      final response = await client
          .post(
            Uri.parse("$baseUrl/user/mark-notification"),
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
            body: jsonEncode({'notificationIds': notificationIds}),
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

  Future<http.Response?> updateWeekendAvailability({
    required String token,
    required bool updateWeekendAvailability,
  }) async {
    try {
      final response = await client
          .patch(
            Uri.parse("$baseUrl/user/weekend-availability"),
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
            body:
                jsonEncode({'weekend_availability': updateWeekendAvailability}),
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

  Future<http.Response?> updateRelationshipPreference({
    required String token,
    required String relationshipPreference,
  }) async {
    try {
      final response = await client
          .patch(
            Uri.parse("$baseUrl/user/relationship-preference"),
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
            body:
                jsonEncode({'relationship_preference': relationshipPreference}),
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

  Future<http.Response?> getUserWithId({
    required String token,
    required String userId,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/user/get-user/$userId');
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
