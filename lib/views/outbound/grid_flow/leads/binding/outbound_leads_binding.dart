import 'package:aitota_business/core/app-export.dart';
import '../controller/outbound_leads_controller.dart';

class OutboundLeadsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => OutboundLeadsController());
  }

}