import '../../../../../../../core/app-export.dart';
import '../controller/incoming_calls_controller.dart';

class IncomingCallsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => IncomingCallsController());
  }
}
