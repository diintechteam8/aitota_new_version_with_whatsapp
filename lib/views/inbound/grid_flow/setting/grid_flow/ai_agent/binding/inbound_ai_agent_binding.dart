import 'package:aitota_business/core/app-export.dart';

import '../controller/inbound_ai_agent_controller.dart';

class InboundAiAgentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => InboundAiAgentController());
  }

}