import 'package:aitota_business/core/app-export.dart';
import 'package:aitota_business/views/my_business/product/controller/my_product_controller.dart';

class MyProductBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MyProductController());
  }

}