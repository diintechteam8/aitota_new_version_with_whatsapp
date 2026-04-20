import 'package:aitota_business/core/app-export.dart';

import '../controller/ai_agent_controller.dart';
import '../detail_screen/controller/ai_agent_detail_controller.dart';


class AiAgentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AiAgentController());
  }

}