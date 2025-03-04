import 'package:echodate/app/controller/live_stream_controller.dart';
import 'package:get/get.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(LiveStreamController());
  }
}
