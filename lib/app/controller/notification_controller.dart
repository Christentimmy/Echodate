import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class NotificationController extends GetxController {
  final RxBool _isNotification = false.obs;

  RxBool get isNotification => _isNotification;

  @override
  void onInit() {
    super.onInit();
    checkNotificationPermission();
  }


  Future<void> checkNotificationPermission() async {
    final bool hasPermission = OneSignal.Notifications.permission;
    _isNotification.value = hasPermission;
  }

  Future<void> toggleNotification(bool value) async {
    if (value) {
      await OneSignal.Notifications.requestPermission(true);
    } else {
      await OneSignal.Notifications.clearAll();
    }
    _isNotification.value = value;
  }
}