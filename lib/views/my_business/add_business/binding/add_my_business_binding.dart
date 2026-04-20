import 'package:aitota_business/core/app-export.dart';
import 'package:aitota_business/views/my_business/add_business/controller/add_my_business_controller.dart';

class AddMyBusinessBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AddMyBusinessController());
  }

}