import 'package:get/get.dart';
import '../controller/profile_select_controller.dart';

class ProfileSelectBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileSelectController>(() => ProfileSelectController());
  }
}


