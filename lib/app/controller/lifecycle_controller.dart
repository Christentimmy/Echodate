import 'package:echodate/app/controller/socket_controller.dart';
import 'package:echodate/app/controller/storage_controller.dart';
import 'package:echodate/app/controller/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LifecycleController extends GetxController with WidgetsBindingObserver {
  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      onAppResume();
    }
  }

  void onAppResume() async {
    final userController = Get.find<UserController>();
    final storageController = Get.put(StorageController());
    final token = await storageController.getToken();
    if (token?.isEmpty == true && userController.userModel.value?.fullName == null) {
      userController.getUserDetails();
    }

    final socketController = Get.find<SocketController>();
    if (socketController.socket?.connected != true) {
      socketController.initializeSocket();
    }
  }
}
