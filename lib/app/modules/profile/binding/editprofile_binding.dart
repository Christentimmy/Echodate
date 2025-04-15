import 'package:echodate/app/modules/profile/controller/edit_profile_controller.dart';
import 'package:get/get.dart';

class EditprofileBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(EditProfileController());
  }
}
