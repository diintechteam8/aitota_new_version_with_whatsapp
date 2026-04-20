import 'package:aitota_business/core/app-export.dart';
import 'package:aitota_business/views/outbound/grid_flow/campaign/detail_screen/see_more/controller/see_more_campaign_logs_controller.dart';

class SeeMoreCampaignLogsBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => SeeMoreCampaignLogsController());
  }

}