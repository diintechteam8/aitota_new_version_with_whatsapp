import 'package:aitota_business/core/app-export.dart';
import '../controller/lead_status_detail_controller.dart';

class InboundLeadStatusDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => InboundLeadStatusDetailController());
  }

}