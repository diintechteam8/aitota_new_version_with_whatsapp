import 'package:aitota_business/core/app-export.dart';
import 'package:aitota_business/views/outbound/grid_flow/campaign/detail_screen/view_completed/controller/view_completed_campaign_calls_controller.dart';

class ViewCompletedCampaignCallsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ViewCompletedCampaignCallsController());
  }

}