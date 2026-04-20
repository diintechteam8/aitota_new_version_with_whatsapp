import 'package:aitota_business/core/app-export.dart';
import 'package:aitota_business/views/myDial/grid_flow/leads/controller/my_dial_leads_controller.dart';

class MyDialLeadsBinding extends Bindings {
  @override
  void dependencies() {
   Get.lazyPut(() => MyDialLeadsController());
  }
}