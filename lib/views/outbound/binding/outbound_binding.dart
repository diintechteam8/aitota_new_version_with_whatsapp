import 'package:aitota_business/core/app-export.dart';
import '../controller/outbound_controller.dart';

class OutboundScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => OutboundScreenController());
  }

}