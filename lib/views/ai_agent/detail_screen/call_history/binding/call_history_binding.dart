import 'package:aitota_business/core/app-export.dart';
import 'package:aitota_business/views/ai_agent/detail_screen/call_history/controller/call_history_controller.dart';

class CallHistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CallHistoryController());
  }

}