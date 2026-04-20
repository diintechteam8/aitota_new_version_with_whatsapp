import 'package:aitota_business/core/app-export.dart';
import 'package:aitota_business/views/myDial/grid_flow/reports/controller/my_dial_reports_controller.dart';

import '../../leads/controller/my_dial_leads_controller.dart';

class MyDialReportsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MyDialReportsController());
    Get.lazyPut(() => MyDialLeadsController());
  }

}