import 'package:aitota_business/core/app-export.dart';
import 'package:aitota_business/views/outbound/grid_flow/campaign/addCampaign/controller/add_outbound_campaign_controller.dart';

class AddOutboundCampaignBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AddOutboundCampaignController());
  }

}