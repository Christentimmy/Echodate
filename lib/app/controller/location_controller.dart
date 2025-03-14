import 'package:echodate/app/controller/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class LocationController extends GetxController {
  RxBool _isLocation = false.obs;
  RxBool get isLocation => _isLocation;
  @override
  void onInit() {
    super.onInit();
    checkLocationPermission();
  }

  Future<void> checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      _isLocation.value = true;
    } else {
      _isLocation.value = false;
    }
  }

  Future<void> requestLocationPermission() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      _isLocation.value = true;
    } else {
      _isLocation.value = false;
    }
  }

  Future<void> getCurrentCity() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      String? city = placemarks[0].subAdministrativeArea;
      if (city == null || city.isEmpty) return;
      final userController = Get.find<UserController>();
      await userController.updateLocation(
        latitude: position.latitude,
        longitude: position.longitude,
        address: city,
      );
    } catch (e, stackTrace) {
      debugPrint("${e.toString()} StackTrace: $stackTrace");
    }
  }
}
