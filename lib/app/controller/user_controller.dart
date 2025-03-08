import 'dart:convert';
import 'dart:io';
import 'package:echodate/app/controller/location_controller.dart';
import 'package:echodate/app/controller/storage_controller.dart';
import 'package:echodate/app/models/transaction_model.dart';
import 'package:echodate/app/models/user_model.dart';
import 'package:echodate/app/modules/Interest/views/interested_in_screen.dart';
import 'package:echodate/app/modules/Interest/views/pick_hobbies_screen.dart';
import 'package:echodate/app/modules/Interest/views/relationtionship_preference_screen.dart';
import 'package:echodate/app/modules/auth/views/otp_verify_screen.dart';
import 'package:echodate/app/modules/auth/views/signup_screen.dart';
import 'package:echodate/app/modules/bottom_navigation/views/bottom_navigation_screen.dart';
import 'package:echodate/app/modules/profile/views/complete_profile_screen.dart';
import 'package:echodate/app/services/user_service.dart';
import 'package:echodate/app/utils/url_launcher.dart';
import 'package:echodate/app/widget/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  final UserService _userService = UserService();
  Rxn<UserModel> userModel = Rxn<UserModel>();
  RxList<UserModel> potentialMatchesList = <UserModel>[].obs;
  RxList<UserModel> matchesList = <UserModel>[].obs;
  RxList<TransactionModel> userTransactionHistory = <TransactionModel>[].obs;
  RxBool isloading = false.obs;
  RxBool isPaymentProcessing = false.obs;
  RxBool isPaymentHistoryFetched = false.obs;
  RxBool isPotentialMatchFetched = false.obs;
  RxBool isUserDetailsFetched = false.obs;

  @override
  void onInit() async {
    super.onInit();
    getUserDetails();
    getPotentialMatches();
    getMatches();
    getUserPaymentHistory();
  }

  Future<void> getUserDetails() async {
    isloading.value = true;
    try {
      final storageController = Get.find<StorageController>();
      String? token = await storageController.getToken();
      if (token == null || token.isEmpty) return;

      final response = await _userService.getUserDetails(token: token);
      if (response == null) return;
      final decoded = json.decode(response.body);
      String message = decoded["message"];

      if (message == "Token has expired.") {
        Get.offAll(() => RegisterScreen());
        return;
      }

      if (response.statusCode != 200) {
        debugPrint(message);
        return;
      }

      var userData = decoded["data"];
      userModel.value = UserModel.fromJson(userData);
      userModel.refresh();
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isloading.value = false;
    }
  }

  Future<bool> getUserStatus() async {
    try {
      final storageController = Get.find<StorageController>();
      String? token = await storageController.getToken();
      if (token == null || token.isEmpty) return false;
      final response = await _userService.getUserStatus(token: token);
      if (response == null) {
        Get.offAll(() => RegisterScreen());
        return true;
      }
      final decoded = json.decode(response.body);
      print("decoded: $decoded");
      String message = decoded["message"] ?? "";
      if (response.statusCode != 200) {
        Get.offAll(() => RegisterScreen());
        debugPrint(message);
        return true;
      }
      String status = decoded["data"]["status"];
      String email = decoded["data"]["email"];
      bool isEmailVerified = decoded["data"]["is_verified"] ?? false;
      bool isProfileCompleted = decoded["data"]["profile_completed"] ?? false;
      String address = decoded["data"]["location"]?["address"];
      print("address: $address");
      if (status == "banned" || status == "blocked") {
        CustomSnackbar.showErrorSnackBar("Your account has been banned.");
        Get.offAll(() => RegisterScreen());
        return true;
      }
      if (!isEmailVerified) {
        CustomSnackbar.showErrorSnackBar("Your account email is not verified.");
        Get.offAll(() => OTPVerificationScreen(
            email: email,
            onVerifiedCallBack: () {
              getUserStatus();
              // Get.offAll(() => BottomNavigationScreen());
            }));
        return true;
      }
      if (!isProfileCompleted) {
        CustomSnackbar.showErrorSnackBar("Your profile is not completed.");
        Get.offAll(() => CompleteProfileScreen(
              nextScreen: () {
                getUserStatus();
              },
            ));
        return true;
      }
      final locationController = Get.find<LocationController>();
      if (address.isEmpty) {
        await locationController.getCurrentCity();
        Get.offAll(() => BottomNavigationScreen());
        return true;
      }
      return false;
    } catch (e) {
      debugPrint(e.toString());
    }
    return false;
  }

  Future<void> saveUserOneSignalId({
    required String oneSignalId,
  }) async {
    try {
      final storageController = Get.find<StorageController>();
      String? token = await storageController.getToken();
      if (token == null || token.isEmpty) return;
      final response = await _userService.saveUserOneSignalId(
        token: token,
        id: oneSignalId,
      );
      if (response == null) return;
      print(response.body);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> buyCoin({
    required String coinPackageId,
  }) async {
    isPaymentProcessing.value = true;
    try {
      final storageController = Get.find<StorageController>();
      String? token = await storageController.getToken();
      if (token == null || token.isEmpty) {
        CustomSnackbar.showErrorSnackBar("Authentication required");
        return;
      }
      final response = await _userService.initiateStripePayment(
        token: token,
        coinPackageId: coinPackageId,
      );

      if (response == null) return;
      final decoded = json.decode(response.body);
      if (response.statusCode != 200) {
        CustomSnackbar.showErrorSnackBar(decoded["message"]);
        return;
      }

      String? authorizationUrl = decoded["data"]["authorization_url"];
      if (authorizationUrl != null) {
        CustomSnackbar.showErrorSnackBar("Failed to initiate payment");
        urlLauncher(authorizationUrl);
        return;
      }
      await getUserPaymentHistory();
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isPaymentProcessing.value = false;
    }
  }

  Future<void> getUserPaymentHistory({
    String? type,
    int? limit = 10,
    String? status,
    String? startDate,
    String? endDate,
  }) async {
    if (isloading.value) return;
    isloading.value = true;
    try {
      final storageController = Get.find<StorageController>();
      String? token = await storageController.getToken();
      if (token == null || token.isEmpty) return;

      final response = await _userService.getUserPaymentHistory(
        token: token,
        type: type,
        limit: limit,
        startDate: startDate,
        endDate: endDate,
        status: status,
      );

      if (response == null) return;
      final decoded = json.decode(response.body);
      String message = decoded["message"];
      if (response.statusCode != 200) {
        debugPrint(message);
        return;
      }

      final payments = decoded["payments"] as List;
      // final totalPages = decoded["totalPages"];
      // final currentPage = decoded["page"];
      if (payments.isEmpty) return;
      userTransactionHistory.addAll(
        payments.map((payment) => TransactionModel.fromJson(payment)).toList(),
      );
      if (response.statusCode == 200) isPaymentHistoryFetched.value = true;
    } catch (e) {
      debugPrint("❌ Error fetching payments: $e");
    } finally {
      isloading.value = false;
    }
  }

  Future<void> updateUserDetails({
    String? fullName,
    String? bio,
    String? email,
    String? gender,
    String? dateOfBirth,
    File? profilePicture,
  }) async {
    isloading.value = true;
    try {
      final storageController = Get.find<StorageController>();
      String? token = await storageController.getToken();
      if (token == null || token.isEmpty) return;

      final response = await _userService.updateUserDetails(
        token: token,
        fullName: fullName,
        bio: bio,
        email: email,
        gender: gender,
        dateOfBirth: dateOfBirth,
        profilePicture: profilePicture,
      );
      if (response == null) return;
      final decoded = json.decode(response.body);
      String message = decoded["message"];
      if (response.statusCode != 200) {
        debugPrint(message);
        return;
      }
      await getUserDetails();
      Get.back();
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isloading.value = false;
    }
  }

  Future<void> uploadPhotos({
    required List<File> photos,
  }) async {
    isloading.value = true;
    try {
      final storageController = Get.find<StorageController>();
      String? token = await storageController.getToken();
      if (token == null || token.isEmpty) {
        CustomSnackbar.showErrorSnackBar("Authentication required");
        return;
      }

      final response = await _userService.uploadPhotos(
        photos: photos,
        token: token,
      );

      if (response == null) return;
      var responseData = await response.stream.bytesToString();
      final decoded = json.decode(responseData);
      if (response.statusCode != 200) {
        CustomSnackbar.showErrorSnackBar(decoded["message"]);
        return;
      }
      CustomSnackbar.showErrorSnackBar(decoded["message"]);
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isloading.value = false;
    }
  }

  Future<void> updateLocation({
    required double latitude,
    required double longitude,
    required String address,
  }) async {
    isloading.value = true;
    try {
      final storageController = Get.find<StorageController>();
      String? token = await storageController.getToken();
      if (token == null || token.isEmpty) {
        CustomSnackbar.showErrorSnackBar("Authentication required");
        return;
      }
      final response = await _userService.updateLocation(
        token: token,
        latitude: latitude,
        longitude: longitude,
        address: address,
      );

      if (response == null) return;
      print(response.body);
      final decoded = json.decode(response.body);
      if (response.statusCode != 200) {
        CustomSnackbar.showErrorSnackBar(decoded["message"]);
        return;
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isloading.value = false;
    }
  }

  Future<void> updateHobbies({
    required List<String> hobbies,
  }) async {
    isloading.value = true;
    try {
      final storageController = Get.find<StorageController>();
      String? token = await storageController.getToken();
      if (token == null || token.isEmpty) {
        CustomSnackbar.showErrorSnackBar("Authentication required");
        return;
      }
      final response = await _userService.updateHobbies(
        token: token,
        hobbies: hobbies,
      );
      if (response == null) return;
      final decoded = json.decode(response.body);
      if (response.statusCode != 200) {
        CustomSnackbar.showSuccessSnackBar(decoded["message"]);
        return;
      }
      Get.offAll(() => BottomNavigationScreen());
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isloading.value = false;
    }
  }

  Future<void> updatePreference({
    String? minAge,
    String? maxAge,
    String? interestedIn,
    String? distance,
  }) async {
    isloading.value = true;
    try {
      final storageController = Get.find<StorageController>();
      String? token = await storageController.getToken();
      if (token == null || token.isEmpty) {
        CustomSnackbar.showErrorSnackBar("Authentication required");
        return;
      }
      final response = await _userService.updatePreference(
        token: token,
        minAge: minAge,
        maxAge: maxAge,
        interestedIn: interestedIn,
        distance: distance,
      );
      if (response == null) return;
      final decoded = json.decode(response.body);
      if (response.statusCode != 200) {
        CustomSnackbar.showErrorSnackBar(decoded["message"]);
        return;
      }
      CustomSnackbar.showSuccessSnackBar(decoded["message"]);
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isloading.value = false;
    }
  }

  Future<void> getPotentialMatches() async {
    try {
      final storageController = Get.find<StorageController>();
      String? token = await storageController.getToken();
      if (token == null || token.isEmpty) return;
      final response = await _userService.getPotentialMatches(token: token);
      if (response == null) return;
      final decoded = json.decode(response.body);
      if (response.statusCode != 200) {
        debugPrint(decoded["message"].toString());
        return;
      }
      List matches = decoded["data"];
      if (matches.isEmpty) return;
      potentialMatchesList.value =
          matches.map((e) => UserModel.fromJson(e)).toList();
      potentialMatchesList.refresh();
      isPotentialMatchFetched.value = true;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> updateGender({
    required String gender,
    VoidCallback? nextScreen,
  }) async {
    isloading.value = true;
    try {
      final storageController = Get.find<StorageController>();
      String? token = await storageController.getToken();
      if (token == null || token.isEmpty) {
        CustomSnackbar.showErrorSnackBar("Authentication required");
        return;
      }

      final response = await _userService.updateGender(
        token: token,
        gender: gender,
      );

      if (response == null) return;
      final decoded = json.decode(response.body);
      if (response.statusCode != 200) {
        CustomSnackbar.showErrorSnackBar(decoded["message"]);
        return;
      }
      if (nextScreen != null) {
        nextScreen();
      }
      final locationController = Get.find<LocationController>();
      await locationController.getCurrentCity();
      Get.to(() => const InterestedInScreen());
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isloading.value = false;
    }
  }

  Future<void> updateInterestedIn({
    required String interestedIn,
  }) async {
    isloading.value = true;
    try {
      final storageController = Get.find<StorageController>();
      String? token = await storageController.getToken();
      if (token == null || token.isEmpty) {
        CustomSnackbar.showErrorSnackBar("Authentication required");
        return;
      }

      final response = await _userService.updateInterestedIn(
        token: token,
        interestedIn: interestedIn,
      );

      if (response == null) return;
      final decoded = json.decode(response.body);
      if (response.statusCode != 200 && response.statusCode != 201) {
        CustomSnackbar.showErrorSnackBar(decoded["message"]);
        return;
      }
      Get.to(() => const RelationtionshipPreferenceScreen());
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isloading.value = false;
    }
  }

  Future<void> swipeLike({
    required String swipedUserId,
  }) async {
    isloading.value = true;
    try {
      final storageController = Get.find<StorageController>();
      String? token = await storageController.getToken();
      if (token == null || token.isEmpty) {
        CustomSnackbar.showErrorSnackBar("Authentication required");
        return;
      }

      final response = await _userService.swipeLike(
        token: token,
        swipedUserId: swipedUserId,
      );

      if (response == null) return;
      final decoded = json.decode(response.body);
      if (response.statusCode != 200 && response.statusCode != 201) {
        CustomSnackbar.showErrorSnackBar(decoded["message"]);
        return;
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isloading.value = false;
    }
  }

  Future<void> swipeDislike({
    required String swipedUserId,
  }) async {
    isloading.value = true;
    try {
      final storageController = Get.find<StorageController>();
      String? token = await storageController.getToken();
      if (token == null || token.isEmpty) {
        CustomSnackbar.showErrorSnackBar("Authentication required");
        return;
      }

      final response = await _userService.swipeDislike(
        token: token,
        swipedUserId: swipedUserId,
      );

      if (response == null) return;
      final decoded = json.decode(response.body);
      if (response.statusCode != 200 && response.statusCode != 201) {
        CustomSnackbar.showErrorSnackBar(decoded["message"]);
        return;
      }
      CustomSnackbar.showSuccessSnackBar(decoded["message"]);
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isloading.value = false;
    }
  }

  Future<void> swipeSuperLike({
    required String swipedUserId,
  }) async {
    isloading.value = true;
    try {
      final storageController = Get.find<StorageController>();
      String? token = await storageController.getToken();
      if (token == null || token.isEmpty) {
        CustomSnackbar.showErrorSnackBar("Authentication required");
        return;
      }

      final response = await _userService.swipeSuperLike(
        token: token,
        swipedUserId: swipedUserId,
      );

      if (response == null) return;
      final decoded = json.decode(response.body);
      if (response.statusCode != 200 && response.statusCode != 201) {
        CustomSnackbar.showErrorSnackBar(decoded["message"]);
        return;
      }
      CustomSnackbar.showSuccessSnackBar(decoded["message"]);
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isloading.value = false;
    }
  }

  Future<void> getMatches() async {
    isloading.value = true;
    try {
      final storageController = Get.find<StorageController>();
      String? token = await storageController.getToken();
      if (token == null || token.isEmpty) {
        CustomSnackbar.showErrorSnackBar("Authentication required");
        return;
      }

      final response = await _userService.getMatches(token: token);

      if (response == null) return;
      final decoded = json.decode(response.body);
      if (response.statusCode != 200 && response.statusCode != 201) {
        CustomSnackbar.showErrorSnackBar(decoded["message"]);
        return;
      }
      List matches = decoded["data"];
      if (matches.isEmpty) return;
      matchesList.value = matches.map((e) => UserModel.fromJson(e)).toList();
      matchesList.refresh();
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isloading.value = false;
    }
  }

  Future<void> getNotifications({
    int? page,
    int? limit,
    bool? unread,
  }) async {
    isloading.value = true;
    try {
      final storageController = Get.find<StorageController>();
      String? token = await storageController.getToken();
      if (token == null || token.isEmpty) {
        CustomSnackbar.showErrorSnackBar("Authentication required");
        return;
      }

      final response = await _userService.getNotifications(
        token: token,
        page: page,
        limit: limit,
        unread: unread,
      );

      if (response == null) return;
      final decoded = json.decode(response.body);
      if (response.statusCode != 200 && response.statusCode != 201) {
        CustomSnackbar.showErrorSnackBar(decoded["message"]);
        return;
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isloading.value = false;
    }
  }

  Future<void> markNotificationsRead({
    required List<String> notificationIds,
  }) async {
    isloading.value = true;
    try {
      final storageController = Get.find<StorageController>();
      String? token = await storageController.getToken();
      if (token == null || token.isEmpty) {
        CustomSnackbar.showErrorSnackBar("Authentication required");
        return;
      }

      final response = await _userService.markNotificationsRead(
        token: token,
        notificationIds: notificationIds,
      );

      if (response == null) return;
      final decoded = json.decode(response.body);
      if (response.statusCode != 200 && response.statusCode != 201) {
        CustomSnackbar.showErrorSnackBar(decoded["message"]);
        return;
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isloading.value = false;
    }
  }

  Future<void> updateWeekendAvailability({
    required bool updateWeekendAvailability,
  }) async {
    isloading.value = true;
    try {
      final storageController = Get.find<StorageController>();
      String? token = await storageController.getToken();
      if (token == null || token.isEmpty) {
        CustomSnackbar.showErrorSnackBar("Authentication required");
        return;
      }

      final response = await _userService.updateWeekendAvailability(
        token: token,
        updateWeekendAvailability: updateWeekendAvailability,
      );

      if (response == null) return;
      final decoded = json.decode(response.body);
      if (response.statusCode != 200 && response.statusCode != 201) {
        CustomSnackbar.showErrorSnackBar(decoded["message"]);
        return;
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isloading.value = false;
    }
  }

  Future<void> updateRelationshipPreference({
    required String relationshipPreference,
  }) async {
    isloading.value = true;
    try {
      final storageController = Get.find<StorageController>();
      String? token = await storageController.getToken();
      if (token == null || token.isEmpty) {
        CustomSnackbar.showErrorSnackBar("Authentication required");
        return;
      }

      final response = await _userService.updateRelationshipPreference(
        token: token,
        relationshipPreference: relationshipPreference,
      );

      if (response == null) return;
      final decoded = json.decode(response.body);
      if (response.statusCode != 200 && response.statusCode != 201) {
        CustomSnackbar.showErrorSnackBar(decoded["message"]);
        return;
      }
      Get.to(() => const PickHobbiesScreen());
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isloading.value = false;
    }
  }

  Future<UserModel?> getUserWithId({required String userId}) async {
    try {
      final storageController = Get.find<StorageController>();
      String? token = await storageController.getToken();
      if (token == null || token.isEmpty) {
        CustomSnackbar.showErrorSnackBar("Authentication required");
        return null;
      }
      final response =
          await _userService.getUserWithId(token: token, userId: userId);
      if (response == null) return null;
      final decoded = json.decode(response.body);
      if (response.statusCode != 200 && response.statusCode != 201) {
        CustomSnackbar.showErrorSnackBar(decoded["message"]);
        return null;
      }
      return UserModel.fromJson(decoded["data"]);
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  void clearUserData() {
    potentialMatchesList.clear();
    matchesList.clear();
    userTransactionHistory.clear();
    userModel.value = null;
    isPaymentHistoryFetched.value = false;
    isPotentialMatchFetched.value = false;
    isUserDetailsFetched.value = false;
  }
}
