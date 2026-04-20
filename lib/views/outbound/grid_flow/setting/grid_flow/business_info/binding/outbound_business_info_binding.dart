import 'package:aitota_business/core/app-export.dart';
import '../controller/outbound_business_info_controller.dart';

class OutboundBusinessInfoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => OutboundBusinessInfoController());
  }
}