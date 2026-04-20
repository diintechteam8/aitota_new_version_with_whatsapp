import 'package:aitota_business/core/app-export.dart';
import 'package:aitota_business/views/my_business/detail_screen/controller/my_business_detail_controller.dart';

class MyBusinessDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MyBusinessDetailsController());
  }

}