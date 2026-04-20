import 'package:aitota_business/core/app-export.dart';
import 'package:aitota_business/views/outbound/grid_flow/ai_leads/campaign_contacts/contact_detail/controller/ai_leads_contact_detail_controller.dart';

class AiLeadsContactDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AiLeadsContactDetailController());
  }

}