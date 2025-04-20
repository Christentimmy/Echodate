import 'package:echodate/app/controller/auth_controller.dart';
import 'package:echodate/app/controller/lifecycle_controller.dart';
// import 'package:echodate/app/controller/live_stream_controller.dart';
import 'package:echodate/app/controller/location_controller.dart';
import 'package:echodate/app/controller/message_controller.dart';
import 'package:echodate/app/controller/one_signal_controller.dart';
import 'package:echodate/app/controller/socket_controller.dart';
import 'package:echodate/app/controller/storage_controller.dart';
import 'package:echodate/app/controller/story_controller.dart';
import 'package:echodate/app/controller/user_controller.dart';
import 'package:echodate/app/controller/verification_controller.dart';
import 'package:echodate/app/modules/profile/controller/edit_profile_controller.dart';
import 'package:get/get.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(OneSignalController());
    Get.put(StorageController());
    Get.put(StoryController());
    Get.put(SocketController());
    Get.put(MessageController());
    // Get.put(LiveStreamController());
    Get.put(UserController());
    Get.put(LocationController());
    Get.put(AuthController());
    Get.put(EditProfileController());
    Get.put(LifecycleController());
    Get.put(VerificationController());
  }
}
