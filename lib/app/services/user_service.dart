import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:echodate/app/models/bank_model.dart';
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
    int? index, // Optional index to replace a photo
  }) async {
    try {
      final url = Uri.parse('$baseUrl/user/upload-photos');
      var request = http.MultipartRequest('POST', url)
        ..headers['Authorization'] = 'Bearer $token';

      if (index != null) {
        // If index is provided, replace the photo at the given index
        request.fields['index'] = index.toString();
      }

      for (var photo in photos) {
        var file = await http.MultipartFile.fromPath(
          'photos',
          photo.path,
          contentType: MediaType.parse(getMimeType(photo.path)),
        );
        request.files.add(file);
      }

      var response = await request.send();
      return response;
    } on SocketException catch (e) {
      CustomSnackbar.showErrorSnackBar("Check internet connection, $e");
      return null;
    } on TimeoutException {
      CustomSnackbar.showErrorSnackBar("Request timeout, try again");
      return null;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<http.StreamedResponse?> deletePhoto({
    required String token,
    required int index,
  }) async {
    try {
      final url = Uri.parse("$baseUrl/user/delete-photo");
      var request = http.Request("DELETE", url)
        ..headers['Authorization'] = 'Bearer $token'
        ..headers['Content-Type'] = 'application/json'
        ..body = json.encode({"index": index});

      var response = await request.send();
      return response;
    } on SocketException catch (e) {
      CustomSnackbar.showErrorSnackBar("Check internet connection, $e");
      return null;
    } on TimeoutException {
      CustomSnackbar.showErrorSnackBar("Request timeout, try again");
      return null;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<http.StreamedResponse?> updateProfilePicture({
    required String token,
    required File imageFile,
  }) async {
    try {
      var uri = Uri.parse("$baseUrl/user/update-profile-picture");

      var request = http.MultipartRequest('PUT', uri)
        ..headers['Authorization'] = 'Bearer $token'
        ..files.add(
          await http.MultipartFile.fromPath(
            'avatar', // Corrected field name from "avater"
            imageFile.path,
          ),
        );

      var response = await request.send().timeout(const Duration(seconds: 15));
      return response;
    } on SocketException catch (e) {
      CustomSnackbar.showErrorSnackBar("Check internet connection, $e");
      return null;
    } on TimeoutException {
      CustomSnackbar.showErrorSnackBar("Request timeout, try again");
      return null;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
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

  Future<http.Response?> editProfile({
    required String fullName,
    required String bio,
    required String token,
    required String gender,
  }) async {
    try {
      final response = await client
          .patch(Uri.parse("$baseUrl/user/edit-profile"),
              headers: {
                'Authorization': 'Bearer $token',
                'Content-Type': 'application/json',
              },
              body: jsonEncode({
                'gender': gender,
                'full_name': fullName,
                'bio': bio,
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

  Future<http.Response?> getUserWhoLikesMe({
    required String token,
  }) async {
    try {
      final response = await client.get(
          Uri.parse(
            "$baseUrl/user/get-likes",
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

  Future<http.Response?> getSubscriptionPlans({
    required String token,
  }) async {
    try {
      final response = await client.get(
          Uri.parse(
            "$baseUrl/user/get-subscriptions-plan",
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

  Future<http.Response?> subscribeToPlan({
    required String token,
    required String planId,
  }) async {
    try {
      final response = await client
          .post(
            Uri.parse("$baseUrl/user/purchase-subscription"),
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
            body: jsonEncode({'planId': planId}),
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

  Future<http.Response?> getAllEchoCoins({
    required String token,
  }) async {
    try {
      final response = await client.get(
          Uri.parse(
            "$baseUrl/user/get-coins-packages",
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

  Future<http.Response?> getEchoCoinBalance({
    required String token,
  }) async {
    try {
      final response = await client.get(
          Uri.parse(
            "$baseUrl/user/coins/balance",
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

  Future<List> fetchBank() async {
    try {
      final response = await client.get(
          Uri.parse("https://api.paystack.co/bank?country=ghana"),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          });
      if (response.statusCode != 200) {
        return [];
      }
      final decoded = jsonDecode(response.body);
      List data = decoded["data"] ?? [];
      if (data.isEmpty) return [];
      return data;
    } on SocketException catch (e) {
      debugPrint("No internet connection $e");
    } on TimeoutException {
      debugPrint("Request timeout");
    } catch (e) {
      debugPrint(e.toString());
    }
    return [];
  }

  Future<http.Response?> addBank({
    required String token,
    required BankModel bankModel,
  }) async {
    try {
      final response = await client
          .post(
            Uri.parse("$baseUrl/paystack/add-bank"),
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
            body: jsonEncode(bankModel.toMap()),
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

  Future<http.Response?> fetchAllLinkedBanks({
    required String token,
  }) async {
    try {
      final response = await client.get(
          Uri.parse(
            "$baseUrl/paystack/get-linked-bank-accounts",
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

  Future<http.Response?> withdrawCoin({
    required String token,
    required String coins,
    required String recipientCode,
  }) async {
    try {
      final response = await client
          .post(
            Uri.parse("$baseUrl/paystack/withdraw"),
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              "coins": coins,
              "recipientCode": recipientCode,
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

  Future<http.Response?> sendGift({
    required String token,
    required String coins,
    required String streamerId,
  }) async {
    try {
      final response = await client
          .post(
            Uri.parse("$baseUrl/user/send-gift"),
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              "coins": coins,
              "streamerId": streamerId,
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

  Future<http.Response?> deleteBankAccount({
    required String token,
    required String recipientCode,
  }) async {
    try {
      final response = await client
          .delete(
            Uri.parse("$baseUrl/paystack/delete-bank-account"),
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              "recipientCode": recipientCode,
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

  Future<http.Response?> sendCoins({
    required String token,
    required String coins,
    required String recipientUserId,
  }) async {
    try {
      final response = await client
          .post(
            Uri.parse("$baseUrl/user/send-coins"),
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              "coins": coins,
              "recipientUserId": recipientUserId,
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
}
