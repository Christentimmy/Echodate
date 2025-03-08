import 'package:echodate/app/controller/auth_controller.dart';
import 'package:echodate/app/controller/live_stream_controller.dart';
import 'package:echodate/app/controller/socket_controller.dart';
import 'package:echodate/app/controller/storage_controller.dart';
import 'package:echodate/app/controller/story_controller.dart';
import 'package:echodate/app/controller/user_controller.dart';
import 'package:get/get.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(StorageController());
    Get.put(StoryController());
    Get.put(UserController());
    Get.put(SocketController());
    Get.put(LiveStreamController());
    Get.put(AuthController());
  }
}
