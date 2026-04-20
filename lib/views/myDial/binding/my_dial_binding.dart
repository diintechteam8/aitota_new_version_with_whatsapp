import 'package:aitota_business/core/app-export.dart';
import 'package:aitota_business/views/myDial/controller/my_dial_controller.dart';
import 'package:aitota_business/views/myDial/grid_flow/call_logs/controller/call_logs_controller.dart';
import 'package:aitota_business/views/myDial/grid_flow/reports/controller/my_dial_reports_controller.dart';
import 'package:aitota_business/views/myDial/grid_flow/saleDone/controller/my_dial_sale_controller.dart';

import '../grid_flow/leads/controller/my_dial_leads_controller.dart';

class MyDialBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MyDialController());
    Get.lazyPut(() => CallLogsController());
    Get.lazyPut(() => MyDialLeadsController());
    Get.lazyPut(() => MyDialReportsController());
    Get.lazyPut(() => MyDialSaleController());
  }
}