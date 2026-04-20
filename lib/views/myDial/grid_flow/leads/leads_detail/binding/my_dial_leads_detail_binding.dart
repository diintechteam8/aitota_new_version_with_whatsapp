import 'package:aitota_business/core/app-export.dart';
import '../controller/my_dial_leads_detail_controller.dart';

class MyDialLeadsDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MyDialLeadsDetailController());
  }

}