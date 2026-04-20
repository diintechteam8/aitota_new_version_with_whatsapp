import 'package:aitota_business/core/app-export.dart';

import '../controller/outbound_ai_agent_controller.dart';

class OutboundAiAgentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => OutboundAiAgentController());
  }

}