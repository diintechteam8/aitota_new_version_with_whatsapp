import 'package:aitota_business/core/app-export.dart';
import 'package:aitota_business/views/outbound/grid_flow/campaign/detail_screen/controller/outbound_campaign_detail_controller.dart';

class OutboundCampaignDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => OutboundCampaignDetailController());
  }

}