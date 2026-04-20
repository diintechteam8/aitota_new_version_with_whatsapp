import 'package:aitota_business/core/app-export.dart';
import 'package:aitota_business/views/inbound/grid_flow/reports/inbound_summary/controller/inbound_reports_status_controller.dart';

import '../controller/outbound_reports_status_controller.dart';

class OutboundReportStatusBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => OutboundReportStatusController());

  }

}