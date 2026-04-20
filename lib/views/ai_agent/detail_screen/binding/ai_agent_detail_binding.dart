import 'package:aitota_business/core/app-export.dart';
import 'package:aitota_business/views/ai_agent/detail_screen/controller/ai_agent_detail_controller.dart';

class AiAgentDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AiAgentDetailController());
  }

}