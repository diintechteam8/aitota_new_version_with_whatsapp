import 'package:aitota_business/core/app-export.dart';

import '../controller/my_service_controller.dart';

class MyServiceBinding extends Bindings {
  @override
  void dependencies() {
     Get.lazyPut(()=> MyServiceController());
  }

}