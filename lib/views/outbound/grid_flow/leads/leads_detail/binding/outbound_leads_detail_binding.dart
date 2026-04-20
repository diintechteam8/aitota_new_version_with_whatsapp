import 'package:aitota_business/core/app-export.dart';
import '../controller/outbound_leads_detail_controller.dart';

class OutboundLeadsDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => OutboundLeadsDetailController());
  }

}