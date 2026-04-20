import 'package:aitota_business/core/app-export.dart';
import 'package:aitota_business/views/inbound/controller/inbound_controller.dart';

class InboundScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => InboundScreenController());
  }

}