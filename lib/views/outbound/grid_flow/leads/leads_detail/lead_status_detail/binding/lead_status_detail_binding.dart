import 'package:aitota_business/core/app-export.dart';
import '../controller/outbound_lead_status_detail_controller.dart';

class OutboundLeadStatusDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => OutboundLeadStatusDetailController());
  }

}