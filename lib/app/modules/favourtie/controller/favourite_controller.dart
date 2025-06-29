import 'package:echodate/app/controller/user_controller.dart';
import 'package:get/get.dart';

class FavouriteController extends GetxController {
  final _userController = Get.find<UserController>();

  void filterLikeList(String status) async {
    if (status.isEmpty) return;
    if (status == "recent") {
      await _userController.getUserWhoLikesMe();
      return;
    }
    if (status == "nearby") {}
  }
}
