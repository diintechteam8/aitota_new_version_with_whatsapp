import 'package:get/get.dart';
import '../../../../../../core/app-export.dart';
import '../product/controller/my_product_controller.dart';
import '../service/controller/my_service_controller.dart';

class MyBusinessController extends GetxController {
  void onProductsTap() {
    // Trigger data refresh in MyProductController
    final productController = Get.find<MyProductController>();
    productController.fetchMyProducts();
  }

  void onServicesTap() {
    // Trigger data refresh in MyServiceController
    final serviceController = Get.find<MyServiceController>();
    serviceController.fetchMyServices();
  }
}