import 'package:aitota_business/core/app-export.dart';
import '../controller/my_business_controller.dart';

class MyBusinessBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MyBusinessController());
  }

}