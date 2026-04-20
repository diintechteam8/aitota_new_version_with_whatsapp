import 'package:aitota_business/core/app-export.dart';
import 'package:aitota_business/views/ai_agent/detail_screen/call_history/detail_screen/controller/call_histroy_detail_controller.dart';

class CallHistoryDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CallHistoryDetailController());
  }

}