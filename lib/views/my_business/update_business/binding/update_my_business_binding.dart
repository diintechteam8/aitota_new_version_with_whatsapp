import 'package:aitota_business/core/app-export.dart';
import 'package:aitota_business/views/my_business/update_business/controller/update_my_business_controller.dart';

class UpdateMyBusinessBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => UpdateMyBusinessController());
  }

}