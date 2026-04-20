import 'package:aitota_business/core/app-export.dart';
import 'package:aitota_business/views/myDial/grid_flow/saleDone/controller/my_dial_sale_controller.dart';

class MyDialSaleBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MyDialSaleController());
  }

}