import 'package:aitota_business/core/app-export.dart';
import '../controller/my_assign_leads_controller.dart';

class MyAssignBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyAssignController>(() => MyAssignController());
  }
}
