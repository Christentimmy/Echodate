import 'package:echodate/app/controller/user_controller.dart';
import 'package:echodate/app/models/user_model.dart';
import 'package:get/get.dart';

class TinderCardController extends GetxController {
  final _userController = Get.find<UserController>();
  final userModel = Rxn<UserModel>();
  RxList cleanPhotos = [].obs;
  final RxInt activeIndex = 0.obs;
  RxBool isExpanded = false.obs;
  int maxBioLength = 250;

  void getUserDetails({required String id}) async {
    final response = await _userController.getUserWithId(
      userId: id,
    );
    if (response != null) {
      userModel.value = response;
      cleanPhotos.value = userModel.value?.photos
              ?.where((e) => e.trim().isNotEmpty)
              .cast<String>()
              .toList() ??
          [];
    }
  }

  void toggleShowFullBio() {
    isExpanded.value = !isExpanded.value;
  }

  @override
  void dispose() {
    super.dispose();
    userModel.value = null;
  }
}
