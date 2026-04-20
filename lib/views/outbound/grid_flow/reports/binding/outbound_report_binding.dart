import 'package:aitota_business/core/app-export.dart';
import 'package:aitota_business/views/inbound/grid_flow/leads/controller/inbound_leads_controller.dart';
import 'package:aitota_business/views/inbound/grid_flow/reports/controller/inbound_reports_controller.dart';

class OutboundReportsBinding extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut(() => InboundReportsController());
    Get.lazyPut(() => InboundLeadsController());
  }

}