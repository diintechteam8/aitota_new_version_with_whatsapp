import 'package:aitota_business/core/app-export.dart';
import 'package:aitota_business/views/myDial/grid_flow/call_logs/analytics/controller/call_analytics_controller.dart';
import 'package:aitota_business/views/myDial/grid_flow/call_logs/calls/controller/calls_controller.dart';
import '../controller/call_logs_controller.dart';

class CallLogsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CallsController());
    Get.lazyPut(() => CallAnalyticsController());
    Get.lazyPut(() => CallLogsController());
  }
}
