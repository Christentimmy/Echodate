import 'package:echodate/app/controller/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:geocoding/geocoding.dart' as geo;

class LocationController extends GetxController {
  final RxBool _isLocation = false.obs;
  RxBool get isLocation => _isLocation;
  Location location = Location();

  @override
  void onInit() {
    super.onInit();
    checkLocationPermission();
  }

  Future<void> checkLocationPermission() async {
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
    }

    PermissionStatus permission = await location.hasPermission();
    if (permission == PermissionStatus.granted ||
        permission == PermissionStatus.grantedLimited) {
      _isLocation.value = true;
    } else {
      _isLocation.value = false;
    }
  }

  Future<void> requestLocationPermission() async {
    PermissionStatus permission = await location.requestPermission();
    if (permission == PermissionStatus.granted ||
        permission == PermissionStatus.grantedLimited) {
      _isLocation.value = true;
    } else {
      _isLocation.value = false;
    }
  }

  Future<void> getCurrentCity() async {
    try {
      bool serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          return;
        }
      }
      PermissionStatus permission = await location.hasPermission();
      if (permission == PermissionStatus.denied) {
        permission = await location.requestPermission();
      }
     LocationData locationData = await location.getLocation();
      List<geo.Placemark> placemarks = await geo.placemarkFromCoordinates(
        locationData.latitude ?? 0.0,
        locationData.longitude ?? 0.0,
      );
      String? city = placemarks[0].subAdministrativeArea;
      if (city == null || city.isEmpty) return;
      final userController = Get.find<UserController>();
      await userController.updateLocation(
        latitude: locationData.latitude ?? 0.0,
        longitude: locationData.longitude ?? 0.0,
        address: city,
      );
    } catch (e, stackTrace) {
      debugPrint("${e.toString()} StackTrace: $stackTrace");
    }
  }
}
