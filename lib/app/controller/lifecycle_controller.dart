import 'package:echodate/app/controller/socket_controller.dart';
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

  void onAppResume() {
    final userController = Get.find<UserController>();
    userController.getUserDetails();

    final socketController = Get.find<SocketController>();
    final socket = socketController.socket;

    if (socket == null || socket.disconnected == true) {
      socketController.initializeSocket();
    }
  }
}
