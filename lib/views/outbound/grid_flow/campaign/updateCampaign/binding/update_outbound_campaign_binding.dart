import 'package:aitota_business/core/app-export.dart';
import 'package:aitota_business/views/outbound/grid_flow/campaign/updateCampaign/controller/update_outbound_campaign_controller.dart';

class UpdateOutboundCampaignBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => UpdateOutboundCampaignController());
  }

}