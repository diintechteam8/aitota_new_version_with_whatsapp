import 'package:get/get.dart';
import '../controller/groups_controller.dart';

class GroupsBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<GroupsController>()) {
      Get.put<GroupsController>(GroupsController(), permanent: true);
    }
  }
}


