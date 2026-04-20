import 'package:aitota_business/core/app-export.dart';
import 'package:aitota_business/views/outbound/grid_flow/campaign/controller/outbound_campaign_controller.dart';

class OutboundCampaignBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => OutboundCampaignController());
  }

}