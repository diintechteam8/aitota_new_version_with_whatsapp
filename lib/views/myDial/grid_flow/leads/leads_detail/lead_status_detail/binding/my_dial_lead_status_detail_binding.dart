import 'package:aitota_business/core/app-export.dart';
import '../controller/my_dial_lead_status_detail_controller.dart';

class MyDialLeadStatusDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MyDialLeadStatusDetailController());
  }

}