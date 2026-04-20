import 'package:aitota_business/core/app-export.dart';
import 'package:aitota_business/views/outbound/grid_flow/ai_leads/controller/ai_leads_controller.dart';

class AILeadsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AILeadsCampaignController());
  }

}