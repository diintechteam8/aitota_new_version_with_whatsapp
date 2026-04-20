import 'package:aitota_business/core/app-export.dart';
import '../controller/myassign_group_detail_controller.dart';

class MyAssignGroupDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MyAssignGroupDetailController());
  }
}
