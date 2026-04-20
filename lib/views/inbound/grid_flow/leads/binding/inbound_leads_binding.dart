import 'package:aitota_business/core/app-export.dart';
import 'package:aitota_business/views/inbound/grid_flow/leads/controller/inbound_leads_controller.dart';

class InboundLeadsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => InboundLeadsController());
  }

}