import 'package:aitota_business/core/app-export.dart';
import '../controller/total_phone_call_controller.dart';

class TotalPhoneCallsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TotalPhoneCallsController());
  }
}
