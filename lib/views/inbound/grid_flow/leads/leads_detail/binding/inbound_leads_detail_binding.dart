import 'package:aitota_business/core/app-export.dart';
import 'package:aitota_business/views/inbound/grid_flow/leads/leads_detail/controller/inbound_leads_detail_controller.dart';

class InboundLeadsDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => InboundLeadsDetailController());
  }

}