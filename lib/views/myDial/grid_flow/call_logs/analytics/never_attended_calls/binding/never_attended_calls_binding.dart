import 'package:get/get.dart';
import '../controller/never_attended_calls_controller.dart';

class NeverAttendedCallsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NeverAttendedCallsController());
  }
}
