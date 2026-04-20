import 'package:aitota_business/core/app-export.dart';
import 'package:aitota_business/views/outbound/grid_flow/ai_leads/campaign_contacts/controller/ai_leads_campaign_contacts_controller.dart';

class AiLeadsCampaignContactsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AiLeadsCampaignContactsController());
  }

}