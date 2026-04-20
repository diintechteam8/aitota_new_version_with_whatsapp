import 'package:aitota_business/core/app-export.dart';
import 'package:aitota_business/views/inbound/grid_flow/reports/inbound_summary/detail_screen/controller/inbound_reports_detail_controller.dart';

import '../controller/outbound_reports_detail_controller.dart';

class OutboundReportStatusDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => OutboundReportStatusDetailController());
  }

}