import 'package:aitota_business/core/app-export.dart';
import 'package:aitota_business/views/myDial/grid_flow/call_logs/calls/controller/calls_controller.dart';
import '../../../../controller/my_dial_controller.dart';

class CallsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MyDialController());
    Get.lazyPut(() => CallsController());
  }
}
