import 'package:aitota_business/core/app-export.dart';
import 'package:aitota_business/views/outbound/grid_flow/campaign/detail_screen/view_live/controller/view_live_campaign_calls_controller.dart';

class ViewLiveCampaignCallsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ViewLiveCampaignCallsController());
  }

}