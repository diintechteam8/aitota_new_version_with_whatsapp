import 'package:aitota_business/core/app-export.dart';
import '../controller/inbound_business_info_controller.dart';

class InboundBusinessInfoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => InboundBusinessInfoController());
  }
}